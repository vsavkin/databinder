part of databinder_impl;

class DomObservers {
  List<DomObserver> registeredObservers = [];
  Scope scope;

  DomObservers(this.scope);

  register(h.EventListenerList list, h.EventListener listener){
    var observer = new DomObserver(list, listenerWithNotification(listener));
    observer.bind();
    registeredObservers.add(observer);
  }

  removeAll()
    => registeredObservers.forEach((_) => _.unbind());

  listenerWithNotification(listener)
    => (e){listener(e); scope.digest();};
}

class DomObserver {
  var list, listener;

  DomObserver(this.list, this.listener);

  bind()
    => list.add(listener);

  unbind()
    => list.remove(listener);
}