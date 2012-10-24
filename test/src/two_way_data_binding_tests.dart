part of databinder_test;

testTwoWayDataBinding() {

  //teardown => unregister all events
  group("two-way data binding", () {

    test("no bindings", () {
      var person = new Person("Dolly");
      var element = bind("<input/>", person);
      expect(element.value, equals(""));
    });

    test("setting a value from the object", () {
      var person = new Person("Dolly");
      var element = bind("<input data-bind='value:name'/>", person);
      expect(element.value, equals("Dolly"));
    });

    test("update a bound property multiple times", () {
      var person = new Person("Dolly");
      var element = bind("<input data-bind='value:name'/>", person);

      person.name = "Sam";
      dispatch();

      expect(element.value, equals("Sam"));
    });

    test("bindinds inside a child node", () {
      var person = new Person("Dolly");
      var element = bind("<div><input data-bind='value:name' id='child'/></div>", person);
      var child = element.query("#child");

      expect(child.value, equals("Dolly"));
    });

    test("bindings to a non-string property", () {
      var person = new Person("Dolly", 99);
      var element = bind("<input data-bind='value:age'/>", person);
      expect(element.value, equals("99"));
    });

    test("update an object when a field is updated", () {
      var person = new Person("Dolly");
      var element = bind("<input data-bind='value:name'/>", person);

      element.value = "Sam";
      element.on.change.dispatch(new Event("change"));

      expect(person.name, equals("Sam"));
    });

// exception in a callback, figure out how to test it
//    test("non-string fields", () {
//      var person = new Person("Dolly", 99);
//      var element = bind("<input data-bind='value:age'/>", person);
//
//      element.value = "10";
//      element.on.change.dispatch(new Event("change"));
//
//      expect(person.age, equals(10));
//    });


    test("unbinding model-to-view watchers", () {
      var person = new Person("Dolly");
      var element = new Element.html("<input data-bind='value:name'/>");

      var binder = new DataBinder(element, person);
      binder.bind();

      person.name = "Sam";

      binder.unbind();
      dispatch();

      expect(element.value, equals("Dolly"));
    });

    test("unbinding view-to-model watchers", () {
      var person = new Person("Dolly");
      var element = new Element.html("<input data-bind='value:name'/>");

      var binder = new DataBinder(element, person);
      binder.bind();
      binder.unbind();

      element.value = "Sam";
      element.on.change.dispatch(new Event("change"));

      expect(person.name, equals("Dolly"));
    });
  });
}