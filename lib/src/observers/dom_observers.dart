part of databinder_impl;

class DomObservers {
  List<DomObserver> observers = [];

  register(h.EventListenerList list, h.EventListener listener){
    var observer = new DomObserver(list, listener);
    observer.bind();
    observers.add(observer);
  }

  removeAll()
    => observers.forEach((_) => _.unbind());
}

class DomObserver {
  var list, listener;

  DomObserver(this.list, this.listener);

  bind()
    => list.add(listener);

  unbind()
    => list.remove(listener);
}