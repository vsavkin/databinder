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
  ElementPlaceholder placeHolder;
  DataBinder dataBinder;
  BinderBase parentBinder;

  ConditionalElement(this.parentBinder, template) {
    placeHolder = new ElementPlaceholder(template, template);
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
    var element = placeHolder.generateElements(1)[0];
    var childScope = parentBinder.scope.createChild();
    dataBinder = new DataBinder(element, childScope, parentBinder.transformations)..bind();
  }

  unbindAndRemoveTemplate() {
    if (dataBinder != null){
      dataBinder.unbind();
    }
    placeHolder.generateElements(0);
  }
}


class ElementPlaceholder {
  h.Element template;
  h.Element marker;
  List<h.Element> current = [];

  ElementPlaceholder(h.Element templateEl, h.Element place){
    template = createTemplateElement(templateEl);
    marker = createMarkerElement();

    place.replaceWith(marker);
    current = [marker];
  }

  generateElements(int number) {
    var parent = current[0].parent;

    var elements = [];
    for(var i = 0; i < number; ++i){
      elements.add(template.clone(true));
    }

    if(number == 0){
      replaceElements(parent, current, [marker]);
      current = [marker];
      return [];

    } else {
      replaceElements(parent, current, elements);
      current = elements;
      return current;
    }
  }

  replaceElements(h.Element parent, List oldChildren, List newChildren){
    var index = parent.nodes.indexOf(oldChildren[0]);
    var lastIndex = parent.nodes.indexOf(oldChildren.last);

    var newNodes = parent.nodes.getRange(0, index);
    newNodes.addAll(newChildren);
    newNodes.addAll(parent.nodes.getRange(lastIndex + 1, parent.nodes.length - lastIndex - 1));
    parent.nodes = newNodes;
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