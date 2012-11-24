part of databinder_impl;

class DataActionBinder extends BinderBase{
  DataActionBinder(sourceObject, scope, transformations) : super(sourceObject, scope, transformations);

  visitDataAction(DataActionNode d) {
    var eventList = reflector.readProperty(d.element.on, d.eventName);
    var callback = reflector.createCallback(sourceObject, d.pathExpression);
    scope.registerDomObserver(eventList, callback);
  }
}