part of databinder_test;

testTransformations() {
  group("transformations", () {
    test("StringTransformation", () {
      var t = new StringTransformation();
      expect(t.modelToView("str"), equals("str"));
      expect(t.viewToModel("str"), equals("str"));
    });

    test("IntTransformation", () {
      var t = new IntTransformation();
      expect(t.modelToView(10), equals("10"));
      expect(t.viewToModel("10"), equals(10));
    });

    test("BoolTransformation", () {
      var t = new BoolTransformation();
      expect(t.modelToView(true), equals("true"));
      expect(t.viewToModel("true"), equals(true));
    });

    test("returns a registered transformations", () {
      var transformations = new Transformations();
      var t = new BoolTransformation();

      transformations.register("type", t);
      expect(transformations.find("type"), equals(t));
    });

    test("raises an exception when no trasformation found", () {
      var transformations = new Transformations();
      expect(() => transformations.find("type"), throws);
    });
  });
}

