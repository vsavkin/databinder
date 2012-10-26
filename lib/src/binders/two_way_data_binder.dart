part of databinder_impl;

class TwoWayDataBinder extends BinderBase{
  TwoWayDataBinder(sourceObject) : super(sourceObject);

  visitDataBinding(DataBindingNode d){
    var propHandle = createPropertyHandle(d);
    setupModelToViewListener(d, propHandle);
    setupViewToModelListener(d, propHandle);
  }

  createPropertyHandle(node)
    => reflector.createPropertyHandle(sourceObject, node.propName);

  setupModelToViewListener(node, propHandle){
    var updateViewCallback = (WatchEvent event) => node.value = event.newValue;
    modelObservers.register(propHandle.getter, updateViewCallback);
  }

  setupViewToModelListener(node, propHandle){
    var updateModelCallback = (_) => propHandle.setter(node.value);
    domObservers.register(node.element.on.change, updateModelCallback);
  }
}