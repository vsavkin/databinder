part of databinder_test;

testTwoWayDataBinding() {

  group("two-way data binding", () {

    test("does nothing when no bindings", () {
      var person = new Person();
      var element = boundElement("<input/>", person);
      expect(element.value, equals(""));
    });

    test("sets the value from the bound object", () {
      var person = new Person(name: "Dolly");
      var element = boundElement("<input data-bind='value:name'/>", person);
      expect(element.value, equals("Dolly"));
    });

    test("sets the value from the bound object (with types)", () {
      var person = new Person(age: 99);
      var element = boundElement("<input data-bind='int:age'/>", person);
      expect(element.value, equals("99"));
    });

    test("updates the bound property when object changes", () {
      var person = new Person(name: "Dolly");
      var binder = bind("<input data-bind='value:name'/>", person);

      person.name = "Sam";
      binder.digest();

      expect(binder.targetElement.value, equals("Sam"));
    });

    test("works with child nodes", () {
      var person = new Person(name: "Dolly");
      var element = boundElement("<div><input data-bind='value:name' id='child'/></div>", person);
      var child = element.query("#child");

      expect(child.value, equals("Dolly"));
    });

    test("updates the bound object when the fields gets updated", () {
      var person = new Person(name: "Dolly");
      var element = boundElement("<input data-bind='value:name'/>", person);

      element.value = "Sam";
      element.on.change.dispatch(new Event("input"));

      expect(person.name, equals("Sam"));
    });

    test("updates the bound object when the fields gets updated (with types)", () {
      var person = new Person(age: 99);
      var element = boundElement("<input data-bind='int:age'/>", person);

      element.value = "100";
      element.on.change.dispatch(new Event("input"));

      expect(person.age, equals(100));
    });

    test("updates all model listeners after a DOM event has been processed", () {
      var person = new Person(name: "Dolly");
      var html = "<div><input data-bind='value:name' id='el1'/><input data-bind='value:name' id='el2'/></div>";

      var element = boundElement(html, person);
      var el1 = element.query("#el1");
      var el2 = element.query("#el2");

      el1.value = "Sam";
      el1.on.change.dispatch(new Event("input"));

      expect(el2.value, equals("Sam"));
    });

    test("unbinds models watchers", () {
      var person = new Person(name: "Dolly");
      var binder = bind("<input data-bind='value:name'/>", person);

      person.name = "Sam";

      binder.unbind();
      binder.digest();

      expect(binder.targetElement.value, equals("Dolly"));
    });

    test("unbinds DOM watchers", () {
      var person = new Person(name: "Dolly");
      var binder = bind("<input data-bind='value:name'/>", person);
      binder.unbind();

      binder.targetElement.value = "Sam";
      binder.targetElement.on.change.dispatch(new Event("input"));

      expect(person.name, equals("Dolly"));
    });

//
//exception in a callback, figure out how to test it
//    test("non-string fields", () {
//      var person = new Person("Dolly", 99);
//      var element = bind("<input data-bind='value:age'/>", person);
//
//      element.value = "10";
//      element.on.change.dispatch(new Event("change"));
//
//      expect(person.age, equals(10));
//    });

//TODO: invalid format

  });
}