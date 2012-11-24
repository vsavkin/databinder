part of databinder_impl;

class Scope {
  ModelObservers modelObservers;
  DomObservers domObservers;
  List<Scope> children = [];

  Scope(){
    modelObservers = new ModelObservers(this);
    domObservers = new DomObservers(this);
  }

  registerModelObserver(ObservableExpression exp, ObserverCallback callback)
    => modelObservers.register(exp, callback);

  registerDomObserver(h.EventListenerList list, h.EventListener listener)
    => domObservers.register(list, listener);

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

  createChild(){
    var childScope = new Scope();
    children.add(childScope);
    return childScope;
  }
}