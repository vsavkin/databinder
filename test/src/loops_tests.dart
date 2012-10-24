part of databinder_test;

testLoops() {

  group("no loop", () {

    test("no conditional", () {
      var person = new Person("Dolly", 50);
      var element = bind("<button/>", person);
      element.on.click.dispatch(new Event("click"));

      expect(person.age, equals(50));
    });

  });
}