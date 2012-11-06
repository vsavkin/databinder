part of databinder_impl;

class ModelObservers {
  List<ModelObserver> registeredObservers = [];

  register(exp, callback){
    var observer = new ModelObserver(exp, callback)..notify();
    registeredObservers.add(observer);
  }

  notify(){
    var iteration = 0;
    while(notifyObservers()){
      iteration += 1;
      if(iteration == 10)
        throw new ModelObserverException();
    }
  }

  removeAll()
    => registeredObservers = [];

  notifyObservers(){
    var dirty = false;
    for(var obs in registeredObservers){
      if(obs.notify()){
        dirty = true;
      }
    }
    return dirty;
  }
}

class ModelObserverException extends RuntimeError {
  ModelObserverException() : super("Models cannot be stabilized");
}

class ObserverEvent {
  var oldValue, newValue;
  ObserverEvent(this.oldValue, this.newValue);
}

class ModelObserver {
  var exp, callback, lastValue;

  ModelObserver(this.exp, this.callback);

  notify(){
    var newValue = exp();
    if (lastValue != newValue) {
      callback(new ObserverEvent(lastValue, newValue));
      lastValue = newValue;
      return true;
    }
    return false;
  }
}