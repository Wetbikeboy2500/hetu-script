import 'package:hetu_script/hetu_script.dart';

var script = '''
fun test({argName}) {
  print(argName)
}

fun main() {
  test(wrongArgName: 1)
}
''';

void main() async {
  var hetu = HTAstInterpreter();

  await hetu.init();

  await hetu.eval(script, invokeFunc: 'main');
}
