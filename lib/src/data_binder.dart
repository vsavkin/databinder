part of databinder;

class DataBinder {
  final Parser _parser = new Parser();
  final List _binders = [];

  final h.Element element;
  final object;
  bool _ran = false;

  DataBinder(this.element, this.object){
    _binders.add(new _OneWayDataBinder(object));
    _binders.add(new _TwoWayDataBinder(object));
    _binders.add(new _DataActionBinder(object));
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
