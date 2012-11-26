part of databinder_test;

testNodes() {
  group("nodes", () {
    group("DataBindingNode", (){
      test("returns pathExpression", (){
        var n = new DataBindingNode(null, "something:pathExpression");
        expect(n.pathExpression, equals("pathExpression"));
      });

      test("returns pathExpression when no type", (){
        var n = new DataBindingNode(null, "pathExpression");
        expect(n.pathExpression, equals("pathExpression"));
      });

      test("returns type", (){
        var n = new DataBindingNode(null, "int:propName");
        expect(n.type, equals("int"));
      });

      test("returns null when no type", (){
        var n = new DataBindingNode(null, "propName");
        expect(n.type, isNull);
      });
    });

    group("TemplateNode", (){
      Element e;

      setUp((){
        e = new Element.html("<template data-iterate='item in items'></template>");
      });

      test("returns iteration variable name", (){
        var n = new TemplateNode(e);
        expect(n.iterationVariable, equals("item"));
      });

      test("returns iteration expression", (){
        var n = new TemplateNode(e);
        expect(n.iterationExpression, equals("items"));
      });

      test("returns true when there is an iteration attribute", (){
        var n = new TemplateNode(e);
        expect(n.hasIterationAttribute, isTrue);
      });

      test("returns false when there no iteration attribute", (){
        var e = new Element.html("<template></template>");
        var n = new TemplateNode(e);
        expect(n.hasIterationAttribute, isFalse);
      });

      test("iterationExpression throws an exception when there is a malformed iteration attribute", (){
        var e = new Element.html("<template data-iterate='items'></template>");
        var n = new TemplateNode(e);
        expect(() => n.iterationExpression, throwsA(new isInstanceOf<DataBinderException>()));
      });

      test("iterationVariable throws an exception when there is a malformed iteration attribute", (){
        var e = new Element.html("<template data-iterate='items'></template>");
        var n = new TemplateNode(e);
        expect(() => n.iterationVariable, throwsA(new isInstanceOf<DataBinderException>()));
      });
    });
  });
}