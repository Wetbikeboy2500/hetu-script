import 'package:hetu_script/hetu_script.dart';

void main() {
  var hetu = HT_ASTInterpreter();

  hetu.evalf('script/import_2.ht', invokeFunc: 'main');
}
