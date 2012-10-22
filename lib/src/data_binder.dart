part of databinder;

class DataBinder {
  Parser parser = new Parser();

  Element element;
  Object object;
  List _watchers = [];

  DataBinder(this.element, this.object);

  void bind() {
    var elementDescriptor = parser.parse(element);

    var oneWay = new _OneWayDataBinder(object);
    elementDescriptor.visit(oneWay);

    _watchers = oneWay.watchers;
  }

  void unbind(){
    _watchers.forEach((_) => _());
  }
}
