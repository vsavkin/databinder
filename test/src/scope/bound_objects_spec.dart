part of databinder_test;

testBoundObjects() {
  group("bound objects", () {
    group("match", () {
      test("returns the root object when nothing matches", () {
        var obj = new BoundObjects.fromMap({"": "root", "item": "another object"});

        var match = obj.match("complex.selector");

        expect(match.object, equals("root"));
        expect(match.methodSelector, equals("complex.selector"));
      });

      test("always returns root when the selector is simple", () {
        var obj = new BoundObjects.fromMap({"": "root", "item": "another object"});

        var match = obj.match("item");

        expect(match.object, equals("root"));
        expect(match.methodSelector, equals("item"));
      });

      test("returns the matching object", () {
        var obj = new BoundObjects.fromMap({"": "root", "item": "another object"});

        var match = obj.match("item.name");

        expect(match.object, equals("another object"));
        expect(match.methodSelector, equals("name"));
      });
    });
  });
}