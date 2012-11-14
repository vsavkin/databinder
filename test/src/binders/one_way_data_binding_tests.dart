part of databinder_test;

testOneWayDataBinding() {
  group("one-way data binding", () {

    test("does nothing when no bindings", () {
      var person = new Person();
      var element = boundElement("<div>Hello</div>", person);
      expect(element.text, equals("Hello"));
    });

    test("updates text inside the root element", () {
      var person = new Person(name: "Dolly");
      var element = boundElement("<div>Hello {{name}}!</div>", person);
      expect(element.text, equals("Hello Dolly!"));
    });

    test("throws an exception when invalid property", () {
      var person = new Person();
      expect(
        () => bind("<div>{{invalid}}</div>", person),
        throwsA(new isInstanceOf<DataBinderException>()));
    });

    test("binds the same property multiple times", () {
      var person = new Person(name: "Dolly");
      var element = boundElement("<div>{{name}} {{name}}</div>", person);
      expect(element.text, equals("Dolly Dolly"));
    });

    test("binds a child node", () {
      var person = new Person(name: "Dolly");
      var element = boundElement("<div><div id='child'>{{name}}</div></div>", person);
      var child = element.query("#child");

      expect(child.text, equals("Dolly"));
    });

    test("binds an attribute", () {
      var person = new Person(name: "Dolly");
      var element = boundElement("<div greeting='Hi {{name}}!'></div>", person);
      var attr = element.attributes['greeting'];

      expect(attr, equals("Hi Dolly!"));
    });

    test("updates a bound propery (text)", () {
      var person = new Person(name: "Dolly");
      var binder = bind("<div>{{name}}</div>", person);

      person.name = "Sam";
      binder.digest();

      expect(binder.targetElement.text, equals("Sam"));
    });

    test("update a bound property (attribute)", () {
      var person = new Person(name: "Dolly");
      var binder = bind("<div greeting='Hi {{name}}!'></div>", person);

      person.name = "Sam";
      binder.digest();

      expect(binder.targetElement.attributes['greeting'], equals("Hi Sam!"));
    });

    test("binds multiple nodes", () {
      var person = new Person(name: "Dolly", age: 99);
      var element = boundElement("<div>{{age}} <div id='child'>{{name}}</div></div>", person);
      var child = element.query("#child");

      expect(child.text, equals("Dolly"));
      expect(element.text, equals("99 Dolly"));
    });

    test("unbinds", () {
      var person = new Person(name: "Dolly");
      var binder = bind("<div>Hello {{name}}!</div>", person);

      person.name = "Sam";
      binder.unbind();

      binder.digest();

      expect(binder.targetElement.text, equals("Hello Dolly!"));
    });

    test("raises an exception when binding twice", (){
      var person = new Person(name: "Dolly");
      var binder = bind("<div>Hello {{name}}!</div>", person);
      binder.unbind();

      expect(
          () => binder.bind(),
          throwsA(new isInstanceOf<DataBinderException>()));
    });
  });
}