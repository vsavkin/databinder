part of databinder_impl;

class TwoWayDataBinder extends BinderBase{
  TwoWayDataBinder(sourceObject, scope) : super(sourceObject, scope);

  visitDataBinding(DataBindingNode d){
    var propHandle = createPropertyHandle(d);
    setupModelToViewListener(d, propHandle);
    setupViewToModelListener(d, propHandle);
  }

  createPropertyHandle(node)
    => reflector.createPropertyHandle(sourceObject, node.propName);

  setupModelToViewListener(node, propHandle){
    var updateViewCallback = (ObserverEvent event) => node.value = event.newValue;
    scope.registerModelObserver(propHandle.getter, updateViewCallback);
  }

  setupViewToModelListener(node, propHandle){
    var updateModelCallback = (_) => propHandle.setter(node.value);

    //TODO: check the type of the element to attach right events
    scope.registerDomObserver(node.element.on.input, updateModelCallback);
    scope.registerDomObserver(node.element.on.keyDown, updateModelCallback);
  }
}