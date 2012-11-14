part of databinder_test;

testConditionals() {

  group("conditionals", () {

    test("does nothing when expression is false", () {
      var person = new Person(married: false);
      var element = boundElement("<template data-if='married'>Hello</template>", person);
      expect(element.text, equals("Hello"));
    });

  });
}