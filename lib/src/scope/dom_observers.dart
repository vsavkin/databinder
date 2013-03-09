part of databinder_impl;

class DomObservers {
  List<StreamSubscription> subscriptions = [];
  Scope scope;

  DomObservers(this.scope);

  register(Stream stream, listener){
    subscriptions.add(stream.listen(listenerWithNotification(listener)));
  }

  removeAll()
    => subscriptions.forEach((_) => _.cancel());

  listenerWithNotification(listener)
    => (e){listener(e); scope.digest();};

  bool get isEmpty
    => subscriptions.isEmpty;
}