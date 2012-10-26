part of databinder_impl;

class ModelObservers {
  List<WatcherDisposer> observers = [];

  register(exp, callback)
    => observers.add(watchAndInvoke(exp, callback));

  removeAll()
    => observers.forEach((_) => _());

  notify()
    => dispatch();
}