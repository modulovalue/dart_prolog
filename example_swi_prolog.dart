import 'evaluate_swi_prolog.dart';

Future<void> main() async {
  final result = await evaluateSwiProlog(
    db: """
hello(world).
""",
    predicateOne: "hello",
  );
  print(result);
}
