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
  });
}