part of databinder_impl;

class Scope {
  ModelObservers modelObservers;
  DomObservers domObservers;
  Transformations transformations;

  Scope(){
    modelObservers = new ModelObservers(this);
    domObservers = new DomObservers(this);
    transformations = new Transformations.standard();
  }

  registerModelObserver(ObservableExpression exp, ObserverCallback callback)
    => modelObservers.register(exp, callback);

  registerDomObserver(h.EventListenerList list, h.EventListener listener)
    => domObservers.register(list, listener);

  registerTransformation(String type, Transformation t)
    => transformations.register(type, t);

  transformation(String type)
    => transformations.find(type);

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