part of databinder_impl;

class DataBinder {
  final _parser = new Parser();
  final _binders = [];

  final h.Element targetElement;
  final sourceObject;
  bool _ran = false;

  DataBinder(this.targetElement, this.sourceObject){
    _binders.add(new OneWayDataBinder(sourceObject));
    _binders.add(new TwoWayDataBinder(sourceObject));
    _binders.add(new DataActionBinder(sourceObject));
  }

  void bind() {
    if(_ran) throw new DataBinderException("Bind cannot be called multiple times");

    var targetNode = _parser.parse(targetElement);
    _binders.forEach((_) => targetNode.visit(_));

    _ran = true;
  }

  void unbind()
    => _binders.forEach((_) => _.unbind());
}
