part of databinder;

class DataBinder {
  Parser parser = new Parser();

  Element element;
  Object object;
  List binders = [];

  DataBinder(this.element, this.object);

  void bind() {
    var elementDescriptor = parser.parse(element);

    binders.add(new _OneWayDataBinder(object));
    binders.add(new _TwoWayDataBinder(object));

    for(var b in binders){
      elementDescriptor.visit(b);
    }
  }

  void unbind()
    => binders.forEach((_) => _.unbind());
}
