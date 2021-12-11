import 'dart:io';

import 'evaluate_logtalk.dart';

Future<void> main() async {
  final file = File("mydb.lgt");
  file.writeAsStringSync(
    """
:- object(list).
    :- public(hello/1).
        hello('world').
:- end_object.

:- object(fake_list).
    :- public(member/1).
        member('world').
:- end_object.

""",
  );
  final result = await evaluateLogtalk(
    db: """{mydb}.""",
    predicateOne: "list::hello",
  );
  print(result);
  file.deleteSync();
}
