part of databinder_test;

testActionListener() {

  group("action listener", () {

    test("no listener", () {
      var person = new Person("Dolly", 50);
      var element = bind("<button/>", person);
      element.on.click.dispatch(new Event("click"));

      expect(person.age, equals(50));
    });

    test("listener", () {
      var person = new Person("Dolly", 50);
      var element = bind("<button data-action='click:doubleAge'/>", person);
      element.on.click.dispatch(new Event("click"));

      expect(person.age, equals(100));
    });

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


    //invalid format

    test("unbinding", () {
      var person = new Person("Dolly", 50);
      var element = new Element.html("<button data-action='click:doubleAge'/>");

      var binder = new DataBinder(element, person);
      binder.bind();
      binder.unbind();

      element.on.click.dispatch(new Event("click"));

      expect(person.age, equals(50));
    });
  });
}