import 'token.dart';
import 'lexicon.dart';
import 'type.dart';

/// 抽象的访问者模式，包含访问表达式的抽象语法树的接口
///
/// 访问语句称作execute，访问表达式称作evaluate
abstract class ASTNodeVisitor {
  /// Null
  dynamic visitNullExpr(NullExpr expr);

  // 布尔
  dynamic visitBooleanExpr(BooleanExpr expr);

  /// 数字常量
  dynamic visitConstIntExpr(ConstIntExpr expr);

  /// 数字常量
  dynamic visitConstFloatExpr(ConstFloatExpr expr);

  /// 字符串常量
  dynamic visitConstStringExpr(ConstStringExpr expr);

  /// 数组字面量
  dynamic visitLiteralVectorExpr(LiteralVectorExpr expr);

  /// 字典字面量
  dynamic visitLiteralDictExpr(LiteralDictExpr expr);

  /// 圆括号表达式
  dynamic visitGroupExpr(GroupExpr expr);

  /// 单目表达式
  dynamic visitUnaryExpr(UnaryExpr expr);

  /// 双目表达式
  dynamic visitBinaryExpr(BinaryExpr expr);

  /// 类型名
  // dynamic visitTypeExpr(TypeExpr expr);

  /// 变量名
  dynamic visitSymbolExpr(SymbolExpr expr);

  /// 赋值表达式，返回右值，执行顺序优先右边
  ///
  /// 因此，a = b = c 解析为 a = (b = c)
  dynamic visitAssignExpr(AssignExpr expr);

  /// 下标取值表达式
  dynamic visitSubGetExpr(SubGetExpr expr);

  /// 下标赋值表达式
  dynamic visitSubSetExpr(SubSetExpr expr);

  /// 属性取值表达式
  dynamic visitMemberGetExpr(MemberGetExpr expr);

  /// 属性赋值表达式
  dynamic visitMemberSetExpr(MemberSetExpr expr);

  /// 函数调用表达式，即便返回值是void的函数仍然还是表达式
  dynamic visitCallExpr(CallExpr expr);

  /// This表达式
  dynamic visitThisExpr(ThisExpr expr);

  /// 导入语句
  dynamic visitImportStmt(ImportStmt stmt);

  /// 表达式语句
  dynamic visitExprStmt(ExprStmt stmt);

  /// 语句块：用于既允许单条语句，又允许语句块的场合，比如IfStatment
  dynamic visitBlockStmt(BlockStmt stmt);

  /// 返回语句
  dynamic visitReturnStmt(ReturnStmt stmt);

  /// If语句
  dynamic visitIfStmt(IfStmt stmt);

  /// While语句
  dynamic visitWhileStmt(WhileStmt stmt);

  /// Break语句
  dynamic visitBreakStmt(BreakStmt stmt);

  /// Continue语句
  dynamic visitContinueStmt(ContinueStmt stmt);

  /// 变量声明语句
  dynamic visitVarDeclStmt(VarDeclStmt stmt);

  /// 参数声明语句
  dynamic visitParamDeclStmt(ParamDeclStmt stmt);

  /// 函数声明和定义
  dynamic visitFuncDeclStmt(FuncDeclaration stmt);

  /// 类
  dynamic visitClassDeclStmt(ClassDeclStmt stmt);

  /// 枚举类
  dynamic visitEnumDeclStmt(EnumDeclStmt stmt);
}

abstract class ASTNode {
  final String type;

  final String fileName;
  final int line;
  final int column;

  /// 取表达式右值，返回值本身
  dynamic accept(ASTNodeVisitor visitor);

  ASTNode(this.type, this.fileName, this.line, this.column);

  ASTNode clone();
}

class NullExpr extends ASTNode {
  @override
  dynamic accept(ASTNodeVisitor visitor) => visitor.visitNullExpr(this);

  NullExpr(String fileName, int line, int column) : super(HT_Lexicon.nullExpr, fileName, line, column);

  @override
  ASTNode clone() => NullExpr(fileName, line, column);
}

class BooleanExpr extends ASTNode {
  @override
  dynamic accept(ASTNodeVisitor visitor) => visitor.visitBooleanExpr(this);

  final bool value;

  BooleanExpr(this.value, String fileName, int line, int column)
      : super(HT_Lexicon.literalBooleanExpr, fileName, line, column);

  @override
  ASTNode clone() => BooleanExpr(value, fileName, line, column);
}

class ConstIntExpr extends ASTNode {
  @override
  dynamic accept(ASTNodeVisitor visitor) => visitor.visitConstIntExpr(this);

  final int constIndex;

  ConstIntExpr(this.constIndex, String fileName, int line, int column)
      : super(HT_Lexicon.literalIntExpr, fileName, line, column);

  @override
  ASTNode clone() => ConstIntExpr(constIndex, fileName, line, column);
}

class ConstFloatExpr extends ASTNode {
  @override
  dynamic accept(ASTNodeVisitor visitor) => visitor.visitConstFloatExpr(this);

  final int constIndex;

  ConstFloatExpr(this.constIndex, String fileName, int line, int column)
      : super(HT_Lexicon.literalFloatExpr, fileName, line, column);

  @override
  ASTNode clone() => ConstFloatExpr(constIndex, fileName, line, column);
}

class ConstStringExpr extends ASTNode {
  @override
  dynamic accept(ASTNodeVisitor visitor) => visitor.visitConstStringExpr(this);

  final int constIndex;

  ConstStringExpr(this.constIndex, String fileName, int line, int column)
      : super(HT_Lexicon.literalStringExpr, fileName, line, column);

  @override
  ASTNode clone() => ConstStringExpr(constIndex, fileName, line, column);
}

class LiteralVectorExpr extends ASTNode {
  @override
  dynamic accept(ASTNodeVisitor visitor) => visitor.visitLiteralVectorExpr(this);

  final List<ASTNode> vector;

  LiteralVectorExpr(String fileName, int line, int column, [this.vector = const []])
      : super(HT_Lexicon.literalVectorExpr, fileName, line, column);

  @override
  ASTNode clone() {
    var new_list = <ASTNode>[];
    for (final expr in vector) {
      new_list.add(expr.clone());
    }
    return LiteralVectorExpr(fileName, line, column, new_list);
  }
}

class LiteralDictExpr extends ASTNode {
  @override
  dynamic accept(ASTNodeVisitor visitor) => visitor.visitLiteralDictExpr(this);

  final Map<ASTNode, ASTNode> map;

  LiteralDictExpr(String fileName, int line, int column, [this.map = const {}])
      : super(HT_Lexicon.blockExpr, fileName, line, column);

  @override
  ASTNode clone() {
    var new_map = <ASTNode, ASTNode>{};
    for (final expr in map.keys) {
      new_map[expr.clone()] = map[expr]!.clone();
    }
    return LiteralDictExpr(fileName, line, column, new_map);
  }
}

class GroupExpr extends ASTNode {
  @override
  dynamic accept(ASTNodeVisitor visitor) => visitor.visitGroupExpr(this);

  final ASTNode inner;

  GroupExpr(this.inner) : super(HT_Lexicon.groupExpr, inner.fileName, inner.line, inner.column);

  @override
  ASTNode clone() => GroupExpr(inner.clone());
}

class UnaryExpr extends ASTNode {
  @override
  dynamic accept(ASTNodeVisitor visitor) => visitor.visitUnaryExpr(this);

  /// 各种单目操作符
  final Token op;

  /// 变量名、表达式、函数调用
  final ASTNode value;

  UnaryExpr(this.op, this.value) : super(HT_Lexicon.unaryExpr, op.fileName, op.line, op.column);

  @override
  ASTNode clone() => UnaryExpr(op, value.clone());
}

class BinaryExpr extends ASTNode {
  @override
  dynamic accept(ASTNodeVisitor visitor) => visitor.visitBinaryExpr(this);

  /// 左值
  final ASTNode left;

  /// 各种双目操作符
  final Token op;

  /// 变量名、表达式、函数调用
  final ASTNode right;

  BinaryExpr(this.left, this.op, this.right) : super(HT_Lexicon.binaryExpr, op.fileName, op.line, op.column);

  @override
  ASTNode clone() => BinaryExpr(left.clone(), op, right.clone());
}

// class TypeExpr extends Expr {
//   @override
//   final String type = env.lexicon.VarExpr;

//   @override
//   dynamic accept(ExprVisitor visitor) => visitor.visitTypeExpr(this);

//   final Token name;

//   final List<TypeExpr> arguments;

//   TypeExpr(this.name, this.typeParams, String fileName) : super(name.line, name.column, fileName);

//   Expr clone() => TypeExpr(name, typeParams, fileName);
// }

class SymbolExpr extends ASTNode {
  @override
  dynamic accept(ASTNodeVisitor visitor) => visitor.visitSymbolExpr(this);

  final Token id;

  SymbolExpr(this.id) : super(HT_Lexicon.symbolExpr, id.fileName, id.line, id.column);

  @override
  ASTNode clone() => SymbolExpr(id);
}

class AssignExpr extends ASTNode {
  @override
  dynamic accept(ASTNodeVisitor visitor) => visitor.visitAssignExpr(this);

  /// 变量名
  final Token variable;

  /// 各种赋值符号变体
  final Token op;

  /// 变量名、表达式、函数调用
  final ASTNode value;

  AssignExpr(this.variable, this.op, this.value) : super(HT_Lexicon.assignExpr, variable.fileName, op.line, op.column);

  @override
  ASTNode clone() => AssignExpr(variable, op, value);
}

class SubGetExpr extends ASTNode {
  @override
  dynamic accept(ASTNodeVisitor visitor) => visitor.visitSubGetExpr(this);

  /// 数组
  final ASTNode collection;

  /// 索引
  final ASTNode key;

  SubGetExpr(this.collection, this.key)
      : super(HT_Lexicon.subGetExpr, collection.fileName, collection.line, collection.column);

  @override
  ASTNode clone() => SubGetExpr(collection, key);
}

class SubSetExpr extends ASTNode {
  @override
  dynamic accept(ASTNodeVisitor visitor) => visitor.visitSubSetExpr(this);

  /// 数组
  final ASTNode collection;

  /// 索引
  final ASTNode key;

  /// 值
  final ASTNode value;

  SubSetExpr(this.collection, this.key, this.value)
      : super(HT_Lexicon.subSetExpr, collection.fileName, collection.line, collection.column);

  @override
  ASTNode clone() => SubSetExpr(collection, key, value);
}

class MemberGetExpr extends ASTNode {
  @override
  dynamic accept(ASTNodeVisitor visitor) => visitor.visitMemberGetExpr(this);

  /// 集合
  final ASTNode collection;

  /// 属性
  final Token key;

  MemberGetExpr(this.collection, this.key)
      : super(HT_Lexicon.memberGetExpr, collection.fileName, collection.line, collection.column);

  @override
  ASTNode clone() => MemberGetExpr(collection, key);
}

class MemberSetExpr extends ASTNode {
  @override
  dynamic accept(ASTNodeVisitor visitor) => visitor.visitMemberSetExpr(this);

  /// 集合
  final ASTNode collection;

  /// 属性
  final Token key;

  /// 值
  final ASTNode value;

  MemberSetExpr(this.collection, this.key, this.value)
      : super(HT_Lexicon.memberSetExpr, collection.fileName, collection.line, collection.column);

  @override
  ASTNode clone() => MemberSetExpr(collection, key, value);
}

class CallExpr extends ASTNode {
  @override
  dynamic accept(ASTNodeVisitor visitor) => visitor.visitCallExpr(this);

  /// 可能是单独的变量名，也可能是一个表达式作为函数使用
  final ASTNode callee;

  /// 函数声明的参数是parameter，调用时传入的变量叫argument
  final List<ASTNode> positionalArgs;

  final Map<String, ASTNode> namedArgs;

  CallExpr(this.callee, this.positionalArgs, this.namedArgs)
      : super(HT_Lexicon.callExpr, callee.fileName, callee.line, callee.column);

  @override
  ASTNode clone() {
    var new_args = <ASTNode>[];
    for (final expr in positionalArgs) {
      new_args.add(expr.clone());
    }

    var new_named_args = <String, ASTNode>{};
    for (final name in namedArgs.keys) {
      new_named_args[name] = namedArgs[name]!.clone();
    }

    return CallExpr(callee.clone(), new_args, new_named_args);
  }
}

class ThisExpr extends ASTNode {
  @override
  dynamic accept(ASTNodeVisitor visitor) => visitor.visitThisExpr(this);

  final Token keyword;

  ThisExpr(this.keyword) : super(HT_Lexicon.thisExpr, keyword.fileName, keyword.line, keyword.column);

  @override
  ASTNode clone() => ThisExpr(keyword);
}

class ImportStmt extends ASTNode {
  @override
  dynamic accept(ASTNodeVisitor visitor) => visitor.visitImportStmt(this);

  final Token keyword;

  final String path;

  final String? nameSpace;

  ImportStmt(this.keyword, this.path, [this.nameSpace])
      : super(HT_Lexicon.importStmt, keyword.fileName, keyword.line, keyword.column);

  @override
  ASTNode clone() => ImportStmt(keyword, path, nameSpace);
}

class ExprStmt extends ASTNode {
  @override
  dynamic accept(ASTNodeVisitor visitor) => visitor.visitExprStmt(this);

  /// 可能是单独的变量名，也可能是一个表达式作为函数使用
  final ASTNode expr;

  ExprStmt(this.expr) : super(HT_Lexicon.exprStmt, expr.fileName, expr.line, expr.column);

  @override
  ASTNode clone() => ExprStmt(expr.clone());
}

class BlockStmt extends ASTNode {
  @override
  dynamic accept(ASTNodeVisitor visitor) => visitor.visitBlockStmt(this);

  final List<ASTNode> block;

  BlockStmt(this.block, String fileName, int line, int column) : super(HT_Lexicon.blockStmt, fileName, line, column);

  @override
  ASTNode clone() {
    var new_list = <ASTNode>[];
    for (final expr in block) {
      new_list.add(expr.clone());
    }
    return BlockStmt(new_list, fileName, line, column);
  }
}

class ReturnStmt extends ASTNode {
  @override
  dynamic accept(ASTNodeVisitor visitor) => visitor.visitReturnStmt(this);

  final Token keyword;

  final ASTNode? value;

  ReturnStmt(this.keyword, this.value) : super(HT_Lexicon.returnStmt, keyword.fileName, keyword.line, keyword.column);

  @override
  ASTNode clone() => ReturnStmt(keyword, value?.clone());
}

class IfStmt extends ASTNode {
  @override
  dynamic accept(ASTNodeVisitor visitor) => visitor.visitIfStmt(this);

  final ASTNode condition;

  final ASTNode? thenBranch;

  final ASTNode? elseBranch;

  IfStmt(this.condition, this.thenBranch, this.elseBranch)
      : super(HT_Lexicon.ifStmt, condition.fileName, condition.line, condition.column);

  @override
  ASTNode clone() => IfStmt(condition.clone(), thenBranch?.clone(), elseBranch?.clone());
}

class WhileStmt extends ASTNode {
  @override
  dynamic accept(ASTNodeVisitor visitor) => visitor.visitWhileStmt(this);

  final ASTNode condition;

  final ASTNode? loop;

  WhileStmt(this.condition, this.loop)
      : super(HT_Lexicon.whileStmt, condition.fileName, condition.line, condition.column);

  @override
  ASTNode clone() => WhileStmt(condition.clone(), loop?.clone());
}

class BreakStmt extends ASTNode {
  @override
  dynamic accept(ASTNodeVisitor visitor) => visitor.visitBreakStmt(this);

  final Token keyword;

  BreakStmt(this.keyword) : super(HT_Lexicon.breakStmt, keyword.fileName, keyword.line, keyword.column);

  @override
  ASTNode clone() => BreakStmt(keyword);
}

class ContinueStmt extends ASTNode {
  @override
  dynamic accept(ASTNodeVisitor visitor) => visitor.visitContinueStmt(this);

  final Token keyword;

  ContinueStmt(this.keyword) : super(HT_Lexicon.continueStmt, keyword.fileName, keyword.line, keyword.column);

  @override
  ASTNode clone() => ContinueStmt(keyword);
}

class VarDeclStmt extends ASTNode {
  @override
  dynamic accept(ASTNodeVisitor visitor) => visitor.visitVarDeclStmt(this);

  final Token id;

  final HT_TypeId declType;

  final ASTNode? initializer;

  final bool isDynamic;

  final bool isImmutable;

  final bool isExtern;

  final bool isStatic;

  VarDeclStmt(
    this.id, {
    this.declType = HT_TypeId.ANY,
    this.initializer,
    this.isDynamic = false,
    this.isImmutable = false,
    this.isExtern = false,
    this.isStatic = false,
  }) : super(HT_Lexicon.varDeclStmt, id.fileName, id.line, id.column);

  @override
  ASTNode clone() => VarDeclStmt(id,
      declType: declType,
      initializer: initializer,
      isDynamic: isDynamic,
      isImmutable: isImmutable,
      isExtern: isExtern,
      isStatic: isStatic);
}

class ParamDeclStmt extends VarDeclStmt {
  @override
  final type = HT_Lexicon.paramStmt;

  @override
  dynamic accept(ASTNodeVisitor visitor) => visitor.visitParamDeclStmt(this);

  final bool isVariadic;

  final bool isOptional;

  final bool isNamed;

  ParamDeclStmt(Token id,
      {HT_TypeId declType = HT_TypeId.ANY,
      ASTNode? initializer,
      bool isDynamic = false,
      bool isImmutable = false,
      bool isExtern = false,
      bool isStatic = false,
      this.isVariadic = false,
      this.isOptional = false,
      this.isNamed = false})
      : super(id, declType: declType, initializer: initializer, isDynamic: isDynamic, isImmutable: isImmutable);

  @override
  ASTNode clone() => ParamDeclStmt(id,
      declType: declType,
      initializer: initializer,
      isDynamic: isDynamic,
      isImmutable: isImmutable,
      isExtern: isExtern,
      isStatic: isStatic,
      isVariadic: isVariadic,
      isOptional: isOptional,
      isNamed: isNamed);
}

enum FunctionType {
  normal,
  constructor,
  getter,
  setter,
  method, // normal function within a class
  literal, // function expression with no function name
}

class FuncDeclaration extends ASTNode {
  static int functionIndex = 0;

  @override
  dynamic accept(ASTNodeVisitor visitor) => visitor.visitFuncDeclStmt(this);

  final Token? id;

  final List<String> typeParams;

  final HT_TypeId returnType;

  late final String _internalName;
  String get internalName => _internalName;

  final String? className;

  final List<ParamDeclStmt> params;

  final int arity;

  final List<ASTNode>? definition;

  final bool isExtern;

  final bool isStatic;

  final bool isConst;

  final bool isVariadic;

  final FunctionType funcType;

  FuncDeclaration(this.returnType, this.params, String fileName, int line, int column,
      {this.id,
      this.className,
      this.typeParams = const [],
      this.arity = 0,
      this.definition,
      this.isExtern = false,
      this.isStatic = false,
      this.isConst = false,
      this.isVariadic = false,
      this.funcType = FunctionType.normal})
      : super(HT_Lexicon.funcDeclStmt, fileName, line, column) {
    var func_name = id?.lexeme ?? HT_Lexicon.anonymousFunction + (functionIndex++).toString();

    if (funcType == FunctionType.constructor) {
      (id != null) ? _internalName = '$className.$func_name' : _internalName = '$className';
    } else if (funcType == FunctionType.getter) {
      _internalName = HT_Lexicon.getter + func_name;
    } else if (funcType == FunctionType.setter) {
      _internalName = HT_Lexicon.setter + func_name;
    } else {
      _internalName = func_name;
    }
  }

  @override
  ASTNode clone() {
    var new_params = <ParamDeclStmt>[];
    for (final expr in params) {
      new_params.add(expr.clone() as ParamDeclStmt);
    }

    var new_body;
    if (definition != null) {
      new_body = <ASTNode>[];
      for (final expr in definition!) {
        new_body.add(expr.clone());
      }
    }

    return FuncDeclaration(returnType, new_params, fileName, line, column,
        id: id,
        className: className,
        typeParams: typeParams,
        arity: arity,
        definition: new_body,
        isExtern: isExtern,
        isStatic: isStatic,
        isConst: isConst,
        funcType: funcType);
  }
}

class ClassDeclStmt extends ASTNode {
  @override
  dynamic accept(ASTNodeVisitor visitor) => visitor.visitClassDeclStmt(this);

  final Token id;

  final List<VarDeclStmt> variables;

  final List<FuncDeclaration> methods;

  final List<String> typeParams;

  final SymbolExpr? superClass;

  final ClassDeclStmt? superClassDeclStmt;

  final HT_TypeId? superClassTypeArgs;

  final bool isExtern;

  ClassDeclStmt(this.id, this.variables, this.methods,
      {this.typeParams = const [],
      this.superClass,
      this.superClassDeclStmt,
      this.superClassTypeArgs,
      this.isExtern = false})
      : super(HT_Lexicon.classDeclStmt, id.fileName, id.line, id.column);

  @override
  ASTNode clone() {
    var new_vars = <VarDeclStmt>[];
    for (final expr in variables) {
      new_vars.add(expr.clone() as VarDeclStmt);
    }

    var new_methods = <FuncDeclaration>[];
    for (final expr in methods) {
      new_methods.add(expr.clone() as FuncDeclaration);
    }

    return ClassDeclStmt(id, new_vars, new_methods,
        typeParams: typeParams,
        superClass: superClass,
        superClassDeclStmt: superClassDeclStmt,
        superClassTypeArgs: superClassTypeArgs,
        isExtern: isExtern);
  }
}

class EnumDeclStmt extends ASTNode {
  @override
  dynamic accept(ASTNodeVisitor visitor) => visitor.visitEnumDeclStmt(this);
  final Token id;

  final List<String> enumerations;

  final bool isExtern;

  EnumDeclStmt(this.id, this.enumerations, {this.isExtern = false})
      : super(HT_Lexicon.enumDeclStmt, id.fileName, id.line, id.column);

  @override
  ASTNode clone() => EnumDeclStmt(id, enumerations, isExtern: isExtern);
}
