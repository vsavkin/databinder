import '../lib/databinder.dart';
import 'dart:html';

class Person {
  String firstName, lastName;

  Person(this.firstName, this.lastName);

  toUpperCase(e){
    firstName = firstName.toUpperCase();
    lastName = lastName.toUpperCase();
  }

  toLowerCase(e){
    firstName = firstName.toLowerCase();
    lastName = lastName.toLowerCase();
  }
}

main(){
  //create a singleton object
  var person = new Person("Jim", "Smith");

  //find all elements we are going to bind to
  var twoWayForm1 = query("#two-way-form-1");
  var twoWayForm2 = query("#two-way-form-2");
  var oneWay = query("#one-way");
  var actions = query("#actions");
  var elementsToBindTo = [twoWayForm1, twoWayForm2, oneWay, actions];

  var binders = [];

  bind(e){
    if(! binders.isEmpty()) return;
    binders = elementsToBindTo.map((_) => new DataBinder(_, person));
    binders.forEach((_) => _.bind());
  }

  unbind(e){
    binders.forEach((_) => _.unbind());
    binders = [];
  }

  query("#bind-btn").on.click.add(bind);

  query("#unbind-btn").on.click.add(unbind);

  bind(null);
}