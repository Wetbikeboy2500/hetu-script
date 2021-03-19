import 'binding.dart';
import 'lexicon.dart';
import 'namespace.dart';
import 'parser.dart' show ParseStyle;
import 'type.dart';
import 'read_file.dart';

mixin InterpreterRef {
  late final Interpreter interpreter;
}

abstract class Interpreter with BindingHandler {
  late int curLine;
  late int curColumn;
  late String curFileName;
  late String workingDirectory;

  late bool debugMode;
  late ReadFileMethod readFileMethod;

  /// 全局命名空间
  late HTNamespace globals;

  /// 当前语句所在的命名空间
  late HTNamespace context;

  Future<dynamic> eval(
    String content, {
    String libName = HTLexicon.global,
    HTNamespace? namespace,
    ParseStyle style = ParseStyle.library,
    String? invokeFunc,
    List<dynamic> positionalArgs = const [],
    Map<String, dynamic> namedArgs = const {},
  });

  Future<dynamic> import(
    String fileName, {
    String? directory,
    String? libName,
    ParseStyle style = ParseStyle.library,
    String? invokeFunc,
    List<dynamic> positionalArgs = const [],
    Map<String, dynamic> namedArgs = const {},
  });

  dynamic invoke(String functionName,
      {List<dynamic> positionalArgs = const [], Map<String, dynamic> namedArgs = const {}});

  HTTypeId typeof(dynamic object);
}
