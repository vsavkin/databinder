import 'package:databinder/databinder.dart';
import 'dart:html';

class Person {
  String name;
  String language;
  bool married;

  Person(this.name, this.language, this.married);

  toUpperCase(e){
    name = name.toUpperCase();
  }

  toLowerCase(e){
    name = name.toLowerCase();
  }
}

main(){
  //create a singleton object
  var person = new Person("Jim", "English", false);

  //find all elements we are going to bind to
  var twoWayForm1 = query("#two-way-form-1");
  var twoWayForm2 = query("#two-way-form-2");
  var oneWay = query("#one-way");
  var actions = query("#actions");
  var elementsToBindTo = [twoWayForm1, twoWayForm2, oneWay, actions];

  var binders = [];

  bind(e){
    if(! binders.isEmpty) return;
    var scope = new Scope();
    binders = elementsToBindTo.map((_) => new DataBinder(_, person, scope));
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