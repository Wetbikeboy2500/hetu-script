import 'type.dart';

/// 变量的声明，包含了类型等额外信息
///
/// 这个类的具体实现需要包含初始化代码 initializer
///
/// 在需要的时候根据具体的解释器类型来取值
class HTDeclaration {
  final String id;
  // 为了允许保存宿主程序变量，这里是dynamic，而不是HTObject
  dynamic value;

  /// 只在继承类中用到类型
  late final HTTypeId? declType;

  final Function? getter;
  final Function? setter;

  final bool isExtern;
  final bool isNullable;
  final bool isImmutable;

  /// 基础类没有初始化、类型推断和类型检查
  ///
  /// 这些工作都是在Ast和字节码各自的实现中分别写的
  HTDeclaration(this.id,
      {this.value,
      HTTypeId? declType,
      this.getter,
      this.setter,
      this.isExtern = false,
      this.isNullable = false,
      this.isImmutable = false}) {
    if (declType != null) {
      this.declType = declType;
    }
  }

  HTDeclaration clone() {
    return HTDeclaration(id,
        value: value,
        declType: declType,
        getter: getter,
        setter: setter,
        isExtern: isExtern,
        isNullable: isNullable,
        isImmutable: isImmutable);
  }

  /// 调用这个接口来初始化这个变量声明
  void initialize() {}
}
