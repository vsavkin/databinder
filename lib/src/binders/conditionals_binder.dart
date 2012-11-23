part of databinder_impl;

class ConditionalsBinder extends BinderBase {
  ConditionalsBinder(sourceObject, scope) : super(sourceObject, scope);

  visitTemplate(TemplateNode t) {
    var handle = reflector.createPropertyHandle(sourceObject, t.ifExpression);
    var template = new TemplateElement(t.element, t.element);
    var conditionalObserver = new ConditionalCallback(template, sourceObject, scope);

    scope.registerModelObserver(handle.getter, conditionalObserver.createCallback());
  }
}

class ConditionalCallback {
  TemplateElement template;
  DataBinder dataBinder;
  Scope scope;
  var sourceObject;

  ConditionalCallback(this.template, this.sourceObject, this.scope) {
    template.replaceWithMarker();
  }

  createCallback() {
    return (ObserverEvent e) {
      if (e.newValue == true) {
        createTemplateAndSetupDataBinder();
      } else {
        unbindAndRemoveTemplate();
      }
    };
  }

  createTemplateAndSetupDataBinder() {
    var element = template.replaceWithTemplate();
    var childScope = scope.createChild();
    dataBinder = new DataBinder(element, sourceObject, childScope)..bind();
  }

  unbindAndRemoveTemplate() {
    if (dataBinder != null){
      dataBinder.unbind();
      template.replaceWithMarker();
    }
  }
}

class TemplateElement {
  h.Element template;
  h.Element marker;
  h.Element current;

  TemplateElement(h.Element templateEl, h.Element currEl) {
    template = createTemplateElement(templateEl);
    marker = createMarkerElement();
    current = currEl;
  }

  replaceWithMarker() {
    current.replaceWith(marker);
    current = marker;
    return current;
  }

  replaceWithTemplate() {
    var instanceOfTemplate = template.clone(true);
    current.replaceWith(instanceOfTemplate);
    current = instanceOfTemplate;
    return current;
  }

  createTemplateElement(e) {
    if (hasRoot(e)) {
      return e.nodes[0].clone(true);
    } else {
      var elTemplate = new h.Element.html("<div>");
      elTemplate.nodes = e.nodes;
      return elTemplate.clone(true);
    }
  }

  hasRoot(e) => e.nodes.length == 1 && e.nodes[0] is h.Element;

  createMarkerElement() => new h.Element.html("<span style='display:none'></span>");
}