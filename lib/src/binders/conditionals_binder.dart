part of databinder_impl;

class ConditionalsBinder extends BinderBase {
  ConditionalsBinder(scope, transformations) : super(scope, transformations);

  visitTemplate(TemplateNode t) {
    if(! t.hasIfExpression) return;

    var handle = reflector.createPropertyHandle(scope.boundObjects, t.ifExpression);
    var conditionalElement = new ConditionalElement(this, t.element);

    scope.registerModelObserver(handle.getter, conditionalElement.createCallback());
  }
}

class ConditionalElement {
  ElementGenerator elementGenerator;
  DataBinder dataBinder;
  BinderBase parentBinder;

  ConditionalElement(this.parentBinder, template) {
    elementGenerator = new ElementGenerator(template, template);
  }

  createCallback() {
    return (ObserverEvent e) {
      if (e.newValue == true) {
        createElementAndSetupDataBinder();
      } else {
        unbindAndRemoveElements();
      }
    };
  }

  createElementAndSetupDataBinder() {
    var element = elementGenerator.generateElements(1)[0];
    var childScope = parentBinder.scope.createChild();
    dataBinder = new DataBinder(element, childScope, parentBinder.transformations)..bind();
  }

  unbindAndRemoveElements() {
    if (dataBinder != null){
      dataBinder.unbind();
    }
    elementGenerator.clear();
  }
}