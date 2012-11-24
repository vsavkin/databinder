part of databinder_impl;

class DataActionBinder extends BinderBase{
  DataActionBinder(sourceObject, scope) : super(sourceObject, scope);

  visitDataAction(DataActionNode d) {
    var eventList = reflector.readProperty(d.element.on, d.eventName);
    var callback = reflector.createCallback(scope.boundObjects, d.pathExpression);
    scope.registerDomObserver(eventList, callback);
  }
}