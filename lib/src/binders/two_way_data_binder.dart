part of databinder_impl;

class TwoWayDataBinder extends BinderBase{

  TwoWayDataBinder(sourceObject, scope, transformations) : super(sourceObject, scope, transformations);

  visitDataBinding(DataBindingNode d){
    var propHandle = createPropertyHandle(d);
    setupModelToViewListener(d, propHandle);
    setupViewToModelListener(d, propHandle);
  }

  createPropertyHandle(node)
    => reflector.createPropertyHandle(sourceObject, node.pathExpression);

  setupModelToViewListener(node, propHandle){
    var t = transformations.find(node.type);
    var updateViewCallback = (ObserverEvent event) => node.value = t.modelToView(event.newValue);
    scope.registerModelObserver(propHandle.getter, updateViewCallback);
  }

  setupViewToModelListener(node, propHandle){
    var t = transformations.find(node.type);
    var updateModelCallback = (_) => propHandle.setter(t.viewToModel(node.value));

    if(node.isCheckbox || node.isRadio){
      scope.registerDomObserver(node.element.on.change, updateModelCallback);
    } else {
      scope.registerDomObserver(node.element.on.input, updateModelCallback);
      scope.registerDomObserver(node.element.on.keyDown, updateModelCallback);
    }
  }
}