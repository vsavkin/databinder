import 'dart:mirrors';

class Person {
  String name;
  int age;

  Person(this.name, [this.age]);
}

main(){
  var person = new Person("Dolly", 99);

  var mirror = reflect(person);
  mirror.setField("age", 77);

  print(person.age);

  mirror.setField("age", "88");
  print(person.age.runtimeType);
}

