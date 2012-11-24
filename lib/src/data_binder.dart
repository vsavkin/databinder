part of databinder_impl;

class DataBinder {
  final _parser = new Parser();
  final _binders = [];

  final h.Element targetElement;
  Scope scope;
  bool _ran = false;

  DataBinder(this.targetElement, this.scope, Transformations transformations){
    _binders.add(new OneWayDataBinder(scope, transformations));
    _binders.add(new TwoWayDataBinder(scope, transformations));
    _binders.add(new DataActionBinder(scope, transformations));
    _binders.add(new ConditionalsBinder(scope, transformations));
  }

  DataBinder.root(targetElement, sourceObject):
    this(targetElement, new Scope(new BoundObjects.root(sourceObject)), new Transformations.standard());

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
