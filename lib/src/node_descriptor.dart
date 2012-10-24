part of databinder;

class TextDescriptor {
  final h.Text node;
  final List<String> boundNames;

  TextDescriptor(this.node, this.boundNames);

  String get value
    => node.text;

  set value(newValue)
    => node.text = newValue;

  void visit(visitor)
    => visitor.visitText(this);
}

class AttributeDescriptor {
  final h.Element element;
  final String attrName;
  final List<String> boundNames;

  AttributeDescriptor(this.element, this.attrName, this.boundNames);

  String get value
    => element.attributes[attrName];

  set value(newValue)
    => element.attributes[attrName] = newValue;

  void visit(visitor)
    => visitor.visitAttribute(this);
}

class DataBindingDescriptor {
  final h.Element element;
  final String propName;

  DataBindingDescriptor(this.element, this.propName);

  String get value
    => element.value;

  set value(newValue)
    => element.value = newValue.toString();

  void visit(visitor)
    => visitor.visitDataBinding(this);
}

class DataActionDescriptor {
  final h.Element element;
  final String expression;

  DataActionDescriptor(this.element, this.expression);

  String get eventName
    => expression.split(":")[0];

  String get methodName
    => expression.split(":")[1];

  void visit(visitor)
    => visitor.visitDataAction(this);
}

class ElementDescriptor {
  h.Element element;
  final List children;

  ElementDescriptor(this.element, this.children);
  ElementDescriptor.empty(this.element) : children = [];

  void visit(visitor)
    => visitor.visitElement(this);
}

class TemplateDescriptor {
  h.Element element;

  TemplateDescriptor(this.element);

  void visit(visitor)
    => visitor.visitTemplate(this);
}
