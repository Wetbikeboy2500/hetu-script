import 'package:hetu_script/hetu_script.dart';

void main() async {
  var hetu = HTAstInterpreter();

  await hetu.init();

  await hetu.eval(r'''
      class Person {
        var name: String
        var age: num
        fun greeting {
          print('Hi! I\'m', name, ', my age is', age)
        }
        fun meaning {
          print('The meaning of life is nil.')
        }
      }

      class Jimmy extends Person {
        get number { return 42 }
        construct ({name: String = 'Jimmy', age: num = 17}) {
          this.name = name
          this.age = age
        }
        fun meaning {
          print('The meaning of life is', number.toString())
        }
      }

      fun main {
        var jimmy = Jimmy()
        print('This is', jimmy.typeid)
        
        var j2 = Jimmy(name: 'j2')
        print(j2.name)

        print(jimmy.name)

        jimmy.meaning();
      }
      ''', invokeFunc: 'main');
}
