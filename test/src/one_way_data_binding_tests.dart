part of databinder_test;

testOneWayDataBinding() {
  group("one-way data binding", () {

    test("no bindings", () {
      var person = new Person("Dolly");
      var element = bind("<div>Hello</div>", person);
      expect(element.text, equals("Hello"));
    });

    test("text inside the root element", () {
      var person = new Person("Dolly");
      var element = bind("<div>Hello {{name}}!</div>", person);
      expect(element.text, equals("Hello Dolly!"));
    });

    test("it throws an exception when invalid property", () {
      var person = new Person("Dolly");
      expect(
        () => bind("<div>{{invalid}}</div>", person),
        throwsA(new isInstanceOf<DataBinderException>()));
    });

    test("multiple bindings", () {
      var person = new Person("Dolly", 99);
      var element = bind("<div>{{name}} is {{age}}</div>", person);
      expect(element.text, equals("Dolly is 99"));
    });

    test("multiple binding to the same property", () {
      var person = new Person("Dolly");
      var element = bind("<div>{{name}} {{name}}</div>", person);
      expect(element.text, equals("Dolly Dolly"));
    });

    test("update a bound property multiple times", () {
      var person = new Person("Dolly");
      var element = bind("<div>{{name}}</div>", person);
      person.name = "Sam";
      dispatch();

      expect(element.text, equals("Sam"));
    });

    test("bindinds inside a child node", () {
      var person = new Person("Dolly");
      var element = bind("<div><div id='child'>{{name}}</div></div>", person);
      var child = element.query("#child");

      expect(child.text, equals("Dolly"));
    });

    test("bindinds inside an attribute", () {
      var person = new Person("Dolly");
      var element = bind("<div greeting='Hi {{name}}!'></div>", person);
      var attr = element.attributes['greeting'];

      expect(attr, equals("Hi Dolly!"));
    });

    test("update a bound property (inside attribute) multiple times", () {
      var person = new Person("Dolly");
      var element = bind("<div greeting='Hi {{name}}!'></div>", person);
      person.name = "Sam";
      dispatch();

      var attr = element.attributes['greeting'];

      expect(attr, equals("Hi Sam!"));
    });

    test("bindings inside the root and child nodes", () {
      var person = new Person("Dolly", 99);
      var element = bind("<div>{{age}} <div id='child'>{{name}}</div></div>", person);
      var child = element.query("#child");

      expect(child.text, equals("Dolly"));
      expect(element.text, equals("99 Dolly"));
    });

    test("unbinding", () {
      var element = new Element.html("<div>Hello {{name}}!</div>");
      var person = new Person("Dolly");

      var binder = new DataBinder(element, person);
      binder.bind();

      person.name = "Sam";

      binder.unbind();
      dispatch();

      expect(element.text, equals("Hello Dolly!"));
    });

    test("raising an exception when trying to bind twice", (){
      var element = new Element.html("<div>Hello {{name}}!</div>");
      var person = new Person("Dolly");

      var binder = new DataBinder(element, person);
      binder.bind();
      binder.unbind();

      expect(
          () => binder.bind(),
          throwsA(new isInstanceOf<DataBinderException>()));
    });
  });
}