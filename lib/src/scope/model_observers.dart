part of databinder_impl;

class ModelObservers {
  List<ModelObserver> registeredObservers = [];
  Scope scope;

  ModelObservers(this.scope);

  register(ObservableExpression exp, ObserverCallback callback){
    var observer = new ModelObserver(exp, callback)..dirtyCheck();
    registeredObservers.add(observer);
  }

  registerListObserver(ObservableExpression exp, ObserverCallback callback){
    var observer = new ListObserver(exp, callback)..dirtyCheck();
    registeredObservers.add(observer);
  }

  removeAll()
    => registeredObservers = [];

  dirtyCheck(){
    var dirty = false;
    for(var obs in registeredObservers){
      if(obs.dirtyCheck()){
        dirty = true;
      }
    }
    return dirty;
  }

  bool get isEmpty
    => registeredObservers.isEmpty;
}

class ModelObserverException extends DataBinderException {
  ModelObserverException() : super("ModelObserver: Models cannot be stabilized");
}

class ObserverEvent {
  var oldValue, newValue;
  ObserverEvent(this.oldValue, this.newValue);
}

typedef ObservableExpression();

typedef ObserverCallback(ObserverEvent event);

class ModelObserver {
  var exp, callback, lastValue;

  ModelObserver(this.exp, this.callback);

  dirtyCheck(){
    var newValue = exp();
    if (lastValue != newValue) {
      callback(new ObserverEvent(lastValue, newValue));
      lastValue = newValue;
      return true;
    }
    return false;
  }
}

class ListObserver {
  var exp, callback, lastValue;

  ListObserver(this.exp, this.callback);

  dirtyCheck(){
    var newValue = exp();
    if (!equal(lastValue, newValue)) {
      callback(new ObserverEvent(lastValue, newValue));
      lastValue = new List.from(newValue);
      return true;
    }
    return false;
  }

  equal(List a, List b){
    var aLength = a == null ? 0 : a.length;
    var bLength = b == null ? 0 : b.length;

    if(aLength != bLength) return false;

    for (int i = 0 ; i < aLength; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}