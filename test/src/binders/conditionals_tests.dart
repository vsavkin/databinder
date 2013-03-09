part of databinder_test;

testConditionals() {

  group("conditionals", () {

    test("renders the template when the condition is true", () {
      var person = new Person(name: 'Jim', married: true);
      var element = boundElement("<div><div data-template='true' data-if='married'>{{name}} is married</div></div>", person);

      expect(element.text, equals("Jim is married"));
    });

    test("doesn't render the template when the condition is false", () {
      var person = new Person(name: 'Jim', married: false);
      var element = boundElement("<div><div data-template='true' data-if='married'>{{name}} is married</div></div>", person);

      expect(element.text, equals(""));
    });

    test("updates the template when the model changes", () {
      var person = new Person(name: 'Jim', married: false);

      var binder = bind("<div><div data-template='true' data-if='married'>{{name}} is married</div></div>", person);
      person.married = true;
      binder.digest();

      expect(binder.targetElement.text, equals("Jim is married"));
    });

    test("works when reinserting the same element multiple times", () {
      var person = new Person(name: 'Jim', married: true);

      var binder = bind("<div><div data-template='true' data-if='married'>{{name}} is married</div></div>", person);
      person.married = false;
      binder.digest();

      person.name = "Sam";
      person.married = true;
      binder.digest();

      expect(binder.targetElement.text, equals("Sam is married"));
    });
  });
}