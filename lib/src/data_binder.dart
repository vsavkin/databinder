part of databinder_impl;

class DataBinder {
  final _parser = new Parser();
  final _binders = [];

  final h.Element targetElement;
  final sourceObject;
  Scope scope;
  bool _ran = false;

  DataBinder(this.targetElement, this.sourceObject, this.scope){
    _binders.add(new OneWayDataBinder(sourceObject, scope));
    _binders.add(new TwoWayDataBinder(sourceObject, scope));
    _binders.add(new DataActionBinder(sourceObject, scope));
    _binders.add(new ConditionalsBinder(sourceObject, scope));
  }

  DataBinder.root(targetElement, sourceObject):
    this(targetElement, sourceObject, new Scope());

  void bind() {
    if(_ran) throw new DataBinderException("Bind cannot be called multiple times");

    var targetNode = _parser.parse(targetElement);
    _binders.forEach((_) => targetNode.visit(_));

    _ran = true;
  }

  void unbind()
    => scope.destroy();

  void digest()
    => scope.digest();
}
