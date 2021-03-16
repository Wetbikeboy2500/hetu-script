import 'errors.dart';
import 'lexicon.dart';
import 'type.dart';
import 'declaration.dart';
import 'object.dart';
import 'context.dart';
import 'ast_interpreter.dart';

class HT_Namespace extends HT_Object with HT_Context, ASTInterpreterRef {
  static int spaceIndex = 0;

  static String getFullId(String id, HT_Namespace space) {
    var fullName = id;
    var cur_space = space.closure;
    while ((cur_space != null) && (cur_space.id != HT_Lexicon.global)) {
      fullName = cur_space.id + HT_Lexicon.memberGet + fullName;
      cur_space = cur_space.closure;
    }
    return fullName;
  }

  @override
  final typeid = HT_TypeId.namespace;

  late final String id;

  @override
  String toString() => '${HT_Lexicon.NAMESPACE} $id';

  late String _fullName;
  String get fullName => _fullName;

  final Map<String, HT_Declaration> defs = {};
  HT_Namespace? _closure;
  HT_Namespace? get closure => _closure;
  set closure(HT_Namespace? closure) {
    _closure = closure;
    _fullName = getFullId(id, _closure!);
  }

  HT_Namespace(
    HT_ASTInterpreter interpreter, {
    String? id,
    HT_Namespace? closure,
  }) : super() {
    this.id = id ?? '${HT_Lexicon.anonymousNamespace}${spaceIndex++}';
    this.interpreter = interpreter;
    _fullName = getFullId(this.id, this);
    _closure = closure;
  }

  HT_Namespace closureAt(int distance) {
    var namespace = this;
    for (var i = 0; i < distance; ++i) {
      namespace = namespace.closure!;
    }

    return namespace;
  }

  @override
  bool contains(String varName) {
    if (defs.containsKey(varName)) {
      return true;
    }
    if (closure != null) {
      return closure!.contains(varName);
    }
    return false;
  }

  /// 在当前命名空间定义一个变量的类型
  @override
  void define(String varName,
      {HT_TypeId? declType,
      dynamic value,
      bool isExtern = false,
      bool isImmutable = false,
      bool isNullable = false,
      bool isDynamic = false}) {
    var val_type = HT_TypeOf(value);
    if (declType == null) {
      if ((!isDynamic) && (value != null)) {
        declType = val_type;
      } else {
        declType = HT_TypeId.ANY;
      }
    }
    if (val_type.isA(declType)) {
      defs[varName] = HT_Declaration(varName,
          declType: declType, value: value, isExtern: isExtern, isNullable: isNullable, isImmutable: isImmutable);
    } else {
      throw HT_Error_Type(varName, val_type.toString(), declType.toString());
    }
  }

  @override
  dynamic fetch(String varName, {String? from}) {
    if (fullName.startsWith(HT_Lexicon.underscore) && !from!.startsWith(fullName)) {
      throw HT_Error_PrivateDecl(fullName);
    } else if (varName.startsWith(HT_Lexicon.underscore) && !from!.startsWith(fullName)) {
      throw HT_Error_PrivateMember(varName);
    }

    if (defs.containsKey(varName)) {
      return defs[varName]!.value;
    }

    if (closure != null) {
      return closure!.fetch(varName, from: from);
    }

    throw HT_Error_Undefined(varName);
  }

  dynamic fetchAt(String varName, int distance, {String? from}) {
    var space = closureAt(distance);
    return space.fetch(varName, from: space.fullName);
  }

  /// 向一个已经定义的变量赋值
  @override
  void assign(String varName, dynamic value, {String? from}) {
    if (fullName.startsWith(HT_Lexicon.underscore) && !from!.startsWith(fullName)) {
      throw HT_Error_PrivateDecl(fullName);
    } else if (varName.startsWith(HT_Lexicon.underscore) && !from!.startsWith(fullName)) {
      throw HT_Error_PrivateMember(varName);
    }

    if (defs.containsKey(varName)) {
      var decl_type = defs[varName]!.declType;
      var var_type = HT_TypeOf(value);
      if (var_type.isA(decl_type)) {
        var decl = defs[varName]!;
        if (!decl.isImmutable) {
          if (!decl.isExtern) {
            decl.value = value;
            return;
          } else {
            interpreter.setExternalVariable('$id.$varName', value);
            return;
          }
        }
        throw HT_Error_Immutable(varName);
      }
      throw HT_Error_Type(varName, var_type.toString(), decl_type.toString());
    } else if (closure != null) {
      closure!.assign(varName, value, from: from);
      return;
    }

    throw HT_Error_Undefined(varName);
  }

  void assignAt(String varName, dynamic value, int distance, {String? from}) {
    var space = closureAt(distance);
    space.assign(
      varName,
      value,
      from: space.fullName,
    );
  }
}
