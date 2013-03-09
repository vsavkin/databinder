part of databinder_test;

testIteration() {

  group("iterations", () {

    test("renders the template", () {
      var addresses = new Addresses([new Address("one"), new Address("two")]);
      var element = boundElement("<div><div data-template='true' data-iterate='a in collection'>{{a.street}}!</div></div>", addresses);
      expect(element.text, equals("one!two!"));
    });

    test("doesn't render the template when the collection is empty", () {
      var addresses = new Addresses([]);
      var element = boundElement("<div><div data-template='true' data-iterate='a in collection'>{{a.street}}!</div></div>", addresses);

      expect(element.text, equals(""));
    });

    test("updates the template when the model changes", () {
      var addresses = new Addresses([]);
      var binder = bind("<div><div data-template='true' data-iterate='a in collection'>{{a.street}}!</div></div>", addresses);

      addresses.collection.add(new Address("one"));
      binder.digest();

      expect(binder.targetElement.text, equals("one!"));
    });

    test("works when reinserting the same element multiple times", () {
      var addresses = new Addresses([new Address("one")]);
      var binder = bind("<div><div data-template='true' data-iterate='a in collection'>{{a.street}}!</div></div>", addresses);

      addresses.collection.clear();
      binder.digest();

      addresses.collection.add(new Address("two"));
      binder.digest();

      expect(binder.targetElement.text, equals("two!"));
    });
  });
}