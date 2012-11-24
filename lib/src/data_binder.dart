part of databinder_impl;

class DataBinder {
  final _parser = new Parser();
  final _binders = [];

  final h.Element targetElement;
  final sourceObject;
  Scope scope;
  bool _ran = false;

  DataBinder(this.targetElement, this.sourceObject, this.scope, Transformations transformations){
    _binders.add(new OneWayDataBinder(sourceObject, scope, transformations));
    _binders.add(new TwoWayDataBinder(sourceObject, scope, transformations));
    _binders.add(new DataActionBinder(sourceObject, scope, transformations));
    _binders.add(new ConditionalsBinder(sourceObject, scope, transformations));
  }

  DataBinder.root(targetElement, sourceObject):
    this(targetElement, sourceObject, new Scope(), new Transformations.standard());

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
