part of databinder_impl;

class TwoWayDataBinder extends BinderBase{

  TwoWayDataBinder(scope, transformations) : super(scope, transformations);

  visitDataBinding(DataBindingNode d){
    var propHandle = createPropertyHandle(d);
    setupModelToViewListener(d, propHandle);
    setupViewToModelListener(d, propHandle);
  }

  createPropertyHandle(node)
    => reflector.createPropertyHandle(scope.boundObjects, node.pathExpression);

  setupModelToViewListener(node, propHandle){
    var t = transformations.find(node.type);
    var updateViewCallback = (ObserverEvent event) => node.value = t.modelToView(event.newValue);
    scope.registerModelObserver(propHandle.getter, updateViewCallback);
  }

  setupViewToModelListener(node, propHandle){
    var t = transformations.find(node.type);
    var updateModelCallback = (_) => propHandle.setter(t.viewToModel(node.value));

    if(node.isCheckbox || node.isRadio){
      scope.registerDomObserver(node.element.onChange, updateModelCallback);
    } else {
      scope.registerDomObserver(node.element.onInput, updateModelCallback);
      scope.registerDomObserver(node.element.onKeyDown, updateModelCallback);
    }
  }
}