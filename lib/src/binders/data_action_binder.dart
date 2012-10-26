part of databinder_impl;

class DataActionBinder extends BinderBase{
  DataActionBinder(sourceObject) : super(sourceObject);

  visitDataAction(DataActionNode d) {
    var eventList = reflector.readProperty(d.element.on, d.eventName);
    var callback = reflector.createCallback(sourceObject, d.methodName);
    domObservers.register(eventList, callback);
  }
}