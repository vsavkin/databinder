part of databinder;

class DataBinder {
  final Parser _parser = new Parser();
  final List _binders = [];

  final Element element;
  final Object object;
  bool _ran = false;

  DataBinder(this.element, this.object){
    _binders.add(new _OneWayDataBinder(object));
    _binders.add(new _TwoWayDataBinder(object));
  }

  void bind() {
    if(_ran) throw new DataBinderException("Bind cannot be called multiple times");

    var elementDescriptor = _parser.parse(element);
    for(var b in _binders){
      elementDescriptor.visit(b);
    }

    _ran = true;
  }

  void unbind()
    => _binders.forEach((_) => _.unbind());
}
