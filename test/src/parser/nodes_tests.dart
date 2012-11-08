part of databinder_test;

testNodes() {
  group("nodes", () {
    group("DataBindingNode", (){
      test("returns propName", (){
        var n = new DataBindingNode(null, "something:propName");
        expect(n.propName, equals("propName"));
      });

      test("returns propName when no type", (){
        var n = new DataBindingNode(null, "propName");
        expect(n.propName, equals("propName"));
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