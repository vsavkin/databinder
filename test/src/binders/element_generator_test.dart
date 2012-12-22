part of databinder_test;

testElementGenerator() {
  group("element generator", (){
    Element template;
    Element place;

    setUp((){
      template = new Element.html("<template>t</template>");
      place = new Element.html("<div><div></div></div>").elements[0];
    });

    test("initializes with a marker", (){
      var g = new ElementGenerator(template, place);
      expect(g.current[0].outerHtml, equals('<span style="display:none"></span>'));
    });

    test("wraps elements into divs when no root element", (){
      var g = new ElementGenerator(template, place);

      g.generateElements(1);

      expect(g.current[0].outerHtml, equals('<div>t</div>'));
    });

    test("does not wrap elements into divs when there is a root element", (){
      template = new Element.html("<template> <span>t</span> </template>");

      var g = new ElementGenerator(template, place);

      g.generateElements(1);

      expect(g.current[0].outerHtml, equals('<span>t</span>'));
    });

    test("generates multiple elemnets", (){
      var g = new ElementGenerator(template, place);

      g.generateElements(3);

      expect(g.current.length, equals(3));
    });

    test("clears", (){
      var g = new ElementGenerator(template, place);

      g.generateElements(2);
      g.clear();

      expect(g.current.length, equals(1));
      expect(g.current[0].outerHtml, equals('<span style="display:none"></span>'));
    });
  });
}