part of databinder_test;

class Person {
  String name;
  int age;

  Person(this.name, [this.age]);
}

Element bind(String text, object){
  var element = new Element.html(text);

  var binder = new DataBinder(element, object);
  binder.bind();

  return element;
}
