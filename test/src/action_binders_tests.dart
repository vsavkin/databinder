part of databinder_test;

testActionBinders() {

  group("action binders", () {

    test("does nothing when nothing is bound", () {
      var person = new Person("Dolly", 50);
      var element = boundElement("<button/>", person);
      element.on.click.dispatch(new Event("click"));

      expect(person.age, equals(50));
    });

    test("calls the specified method on the bound object", () {
      var person = new Person("Dolly", 50);
      var element = boundElement("<button data-action='click:doubleAge'/>", person);
      element.on.click.dispatch(new Event("click"));

      expect(person.age, equals(100));
    });

    test("unbinds", () {
      var person = new Person("Dolly", 50);
      var binder = bind("<button data-action='click:doubleAge'/>", person);
      binder.unbind();

      binder.targetElement.on.click.dispatch(new Event("click"));

      expect(person.age, equals(50));
    });

//TODO: invalid format

// exception in a callback, not sure how to test
//    test("raising an exception when invalid method name", () {
//      var person = new Person("Dolly", 50);
//      var element = bind("<button data-action='click:boom'/>", person);
//
//      element.on.click.dispatch(new Event("click"));
//      expect(
//          () => element.on.click.dispatch(new Event("click")),
//          throwsA(new isInstanceOf<DataBinderException>()));
//    });
//
//    test("raising an exception when invalid method signature", () {
//      var person = new Person("Dolly", 50);
//      var element = bind("<button data-action='click:methodWithoutArguments'/>", person);
//
//      expect(
//          () => element.on.click.dispatch(new Event("click")),
//          throwsA(new isInstanceOf<DataBinderException>()));
//    });

  });
}