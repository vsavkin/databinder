part of databinder_impl;

class Scope {
  ModelObservers modelObservers;
  DomObservers domObservers;
  BoundObjects boundObjects;
  List<Scope> children = [];

  Scope([this.boundObjects]){
    modelObservers = new ModelObservers(this);
    domObservers = new DomObservers(this);
  }

  Scope.root(boundObject) : this(new BoundObjects.root(boundObject));

  registerModelObserver(ObservableExpression exp, ObserverCallback callback)
    => modelObservers.register(exp, callback);

  registerListObserver(ObservableExpression exp, ObserverCallback callback)
    => modelObservers.registerListObserver(exp, callback);

  registerDomObserver(Stream stream, listener)
    => domObservers.register(stream, listener);

  bindObject(String name, obj)
    => boundObjects.register(name, obj);

  destroy(){
    modelObservers.removeAll();
    domObservers.removeAll();
  }

  digest(){
    var iteration = 0;
    while(dirtyCheck()){
      iteration += 1;
      if(iteration == 10) throw new ModelObserverException();
    }
  }

  dirtyCheck(){
    bool localObserversDirty = modelObservers.dirtyCheck();
    return children.reduce(localObserversDirty, (memo, curr) => memo || curr.dirtyCheck());
  }

  Scope createChild(){
    var childScope = new Scope(boundObjects.copy());
    children.add(childScope);
    return childScope;
  }
}