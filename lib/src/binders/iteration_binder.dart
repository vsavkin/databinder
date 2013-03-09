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
  ElementGenerator elementGenerator;
  BinderBase parentBinder;
  String variableName;
  Iterable dataBinders = [];

  IterationElement(this.parentBinder, this.variableName, template) {
    elementGenerator = new ElementGenerator(template, template);
  }

  createCallback() {
    return (ObserverEvent e) {
      unbindAll();
      var elements = elementGenerator.generateElements(e.newValue.length);
      var pairs = zip(e.newValue, elements);
      dataBinders = pairs.map((p) => createDataBinder(p[0], p[1])).toList();
    };
  }

  createDataBinder(object, element){
    var childScope = parentBinder.scope.createChild();
    childScope.bindObject(variableName, object);
    return new DataBinder(element, childScope, parentBinder.transformations)..bind();
  }

  unbindAll()
    => dataBinders.forEach((_) => _.unbind());

}