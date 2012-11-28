part of databinder_test;

class Address {
  String street;

  Address(this.street);

  uppercase(e)
    => street = street.toUpperCase();

  operator ==(other)
    => street == other.street;
}

class Person {
  String name;
  int age;
  Address address;
  bool married;

  Person({this.name, this.age, this.married});

  doubleAge(e)
    => age = age * 2;

  methodWithoutArguments(){
    throw new Exception("Cannot be called through callbacks");
  }
}

class Addresses {
  List<Address> collection;
  Addresses(this.collection);
}

DataBinder bind(String text, object){
  var element = new Element.html(text);

  var binder = new DataBinder.root(element, object);
  binder.bind();

  return binder;
}

Element boundElement(String text, object)
  => bind(text, object).targetElement;
