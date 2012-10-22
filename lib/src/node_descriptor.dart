part of databinder;

class TextNodeDescriptor {
  final Text node;
  final List<String> boundNames;

  TextNodeDescriptor(this.node, this.boundNames);

  String get value => node.text;
  set value(newValue) => node.text = newValue;

  void visit(visitor){
    visitor.visitText(this);
  }
}

class AttributeDescriptor {
  final Element element;
  final String attrName;
  final List<String> boundNames;

  AttributeDescriptor(this.element, this.attrName, this.boundNames);

  String get value => element.attributes[attrName];
  set value(newValue) => element.attributes[attrName] = newValue;

  void visit(visitor){
    visitor.visitAttribute(this);
  }
}

class ElementNodeDescriptor {
  Element element;
  final List children;

  ElementNodeDescriptor(this.element, this.children);
  ElementNodeDescriptor.empty(this.element) : children = [];

  void visit(visitor){
    visitor.visitElement(this);
  }
}
