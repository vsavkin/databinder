part of databinder_impl;

class TextNode {
  final h.Text node;
  final List<String> pathExpressions;

  TextNode(this.node, this.pathExpressions);

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
  final List<String> pathExpressions;

  AttributeNode(this.element, this.attrName, this.pathExpressions);

  String get value
    => element.attributes[attrName];

  set value(newValue)
    => element.attributes[attrName] = newValue;

  void visit(visitor)
    => visitor.visitAttribute(this);
}

class DataBindingNode {
  final h.InputElement element;
  final String _expValue;

  DataBindingNode(this.element, this._expValue);

  String get pathExpression {
    var parts = _expValue.split(":");
    return parts.length > 1 ? parts[1] : parts[0];
  }

  String get type {
    var parts = _expValue.split(":");
    return parts.length > 1 ? parts[0] : null;
  }

  String get value {
    if(isCheckbox){
      return element.checked.toString();
    } else if (isRadio) {
      return element.value;
    } else {
      return element.value;
    }
  }

  set value(String newValue){
    if(isCheckbox){
      element.checked = newValue == "true";
    } else if (isRadio) {
      element.checked = element.value == newValue;
    } else {
      element.value = newValue;
    }
  }

  bool get isCheckbox
    => element.type == "checkbox";

  bool get isRadio
    => element.type == "radio";

  void visit(visitor)
    => visitor.visitDataBinding(this);
}

class DataActionNode {
  final h.Element element;
  final String _expValue;

  DataActionNode(this.element, this._expValue);

  String get eventName
    => _expValue.split(":")[0];

  String get pathExpression
    => _expValue.split(":")[1];

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

  String get ifExpression
    => element.attributes["data-if"];

  void visit(visitor)
    => visitor.visitTemplate(this);
}
