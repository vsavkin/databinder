part of databinder_impl;

class IterationBinder extends BinderBase {
  IterationBinder(scope, transformations) : super(scope, transformations);

  visitTemplate(TemplateNode t) {
    if(! t.hasIterationAttribute) return;

    var listHandle = reflector.createPropertyHandle(scope.boundObjects, t.iterationExpression);
    var iterationElement = new IterationElement(this, t.iterationVariable, t.element);

    scope.registerListObserver(listHandle.getter, iterationElement.createCallback());
  }
}

class IterationElement {
  ElementGenerator placeHolder;
  BinderBase parentBinder;
  String name;
  List dataBinders = [];

  IterationElement(this.parentBinder, this.name, template) {
    placeHolder = new ElementGenerator(template, template);
  }

  createCallback() {
    return (ObserverEvent e) {
      dataBinders.forEach((binder) => binder.unbind());

      var elements = placeHolder.generateElements(e.newValue.length);

      //unbind all elements properly
      for(var i = 0; i < e.newValue.length; ++i){
        var childScope = parentBinder.scope.createChild();
        childScope.bindObject(name, e.newValue[i]);

        var dataBinder = new DataBinder(elements[i], childScope, parentBinder.transformations);
        dataBinder.bind();

        dataBinders.add(dataBinder);
      }
    };
  }
}