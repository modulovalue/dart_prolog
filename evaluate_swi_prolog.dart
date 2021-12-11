
import 'dart:io';

/// Loads the given program in swipl and returns the given predicate.
Future<String> evaluateSwiProlog({
  // The whole database.
  required final String db,
  // A predicate/1 that will be written out via write.
  required final String predicateOne,
  // If true, prints out error messages and ignored standard output.
  final bool debug = true,
  // Runs the goal through profile/1 and shows the results via show_profile.
  final bool profile = false,
  // How long to wait until the database is loaded.
  final int msLoadBuffer = 500,
}) async {
  bool keep = false;
  String buffer = "";
  final p = await Process.start("swipl", []).then((final p) {
    if (debug) {
      p.stderr.listen(
            (final a) => print(systemEncoding.decode(a)),
      );
    }
    p.stdout.listen(
          (final a) {
        if (keep) {
          buffer += systemEncoding.decode(a);
        } else {
          if (debug) {
            print(systemEncoding.decode(a));
          }
        }
      },
    );
    return p;
  });
  p.stdin.writeln("""open_string("${db.replaceAll('\"', '\\"')}", Stream), load_files('myfile', [stream(Stream)]).""");
  await Future<void>.delayed(Duration(milliseconds: msLoadBuffer));
  keep = true;
  if (profile) {
    p.stdin.writeln('''profile($predicateOne(X)), write(X), show_profile([]), halt(0).''');
  } else {
    p.stdin.writeln('''$predicateOne(X), write(X), halt(0).''');
  }
  await p.exitCode;
  return buffer;
}
