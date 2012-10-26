part of databinder_impl;

class TextNode {
  final h.Text node;
  final List<String> boundNames;

  TextNode(this.node, this.boundNames);

  String get value
    => node.text;

  set value(newValue)
    => node.text = newValue;

  void visit(visitor)
    => visitor.visitText(this);
}

class AttributeNode {
  final h.Element element;
  final String attrName;
  final List<String> boundNames;

  AttributeNode(this.element, this.attrName, this.boundNames);

  String get value
    => element.attributes[attrName];

  set value(newValue)
    => element.attributes[attrName] = newValue;

  void visit(visitor)
    => visitor.visitAttribute(this);
}

class DataBindingNode {
  final h.Element element;
  final String _propName;

  DataBindingNode(this.element, this._propName);

  String get propName
    => _propName.substring(6);

  String get value
    => element.value;

  set value(newValue)
    => element.value = newValue.toString();

  void visit(visitor)
    => visitor.visitDataBinding(this);
}

class DataActionNode {
  final h.Element element;
  final String expression;

  DataActionNode(this.element, this.expression);

  String get eventName
    => expression.split(":")[0];

  String get methodName
    => expression.split(":")[1];

  void visit(visitor)
    => visitor.visitDataAction(this);
}

class ElementNode {
  h.Element element;
  final List children;

  ElementNode(this.element, this.children);
  ElementNode.empty(this.element) : children = [];

  void visit(visitor)
    => visitor.visitElement(this);
}

class TemplateNode{
  h.Element element;

  TemplateNode(this.element);

  bool get isLoop
    => element.attributes["iterate"];

  String get loopVariable
    => element.attributes["iterate"].split(" ")[0];

  String get propName
    => element.attributes["iterate"].split(" ")[2];

  void visit(visitor)
    => visitor.visitTemplate(this);
}
