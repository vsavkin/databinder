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

  get children {
    return [new Person("Sam", "English", false), new Person("Liz", "English", false)];
  }

  operator == (other)
    => name == other.name;
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
    var scope = new Scope.root(person);
    binders = elementsToBindTo.map((_) => new DataBinder(_, scope, new Transformations.standard()));
    binders.forEach((_) => _.bind());
  }

  unbind(e){
    binders.forEach((_) => _.unbind());
    binders = [];
  }

  query("#bind-btn").onClick.listen(bind);

  query("#unbind-btn").onClick.listen(unbind);

  bind(null);
}