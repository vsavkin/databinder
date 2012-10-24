part of databinder;

class _DataActionBinder extends _BinderBase{
  List listeners = [];

  _DataActionBinder(object) : super(object);

  unbind(){
    listeners.forEach((_) => _.deattach());
  }

  visitDataAction(DataActionDescriptor d) {
    var eventList = reflector.readProperty(d.element.on, d.eventName);
    var callback = reflector.createCallback(object, d.methodName);
    _createListener(eventList, callback);
  }

  _createListener(eventList, callback){
    var listener = new _AttachedListener(eventList, callback);
    listeners.add(listener);
    listener.attach();
  }
}