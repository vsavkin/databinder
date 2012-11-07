part of databinder;

class Scope {
  ModelObservers modelObservers;
  DomObservers domObservers;

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
    while(modelObservers.dirtyCheck()){
      iteration += 1;
      if(iteration == 10)
        throw new ModelObserverException();
    }
  }
}