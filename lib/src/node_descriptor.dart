part of databinder;

abstract class NodeDescriptor {
  List<String> boundNames;
  List<NodeDescriptor> children;

  NodeDescriptor(this.boundNames, this.children);

  void update(String boundName, newValue){
  }

  _applyNewValue(str, name, newValue) => str.replaceAll("{{${name}}}", newValue);
}

class TextNodeDescriptor extends NodeDescriptor{
  Text node;

  TextNodeDescriptor(this.node, boundNames): super(boundNames, []);

  void update(String boundName, newValue){
    var newText = _applyNewValue(node.text, boundName, newValue);
    node.replaceWholeText(newText);
  }
}

class AttributeDescriptor extends NodeDescriptor {
  Element element;
  String attrName;

  AttributeDescriptor(this.element, this.attrName, boundNames) : super(boundNames, []);

  void update(String boundName, newValue){
    var newText = _applyNewValue(element.attributes[attrName], boundName, newValue);
    element.attributes[attrName] = newText;
  }
}

class ElementNodeDescriptor extends NodeDescriptor {
  Element element;

  ElementNodeDescriptor(this.element, children) : super([], children);

  ElementNodeDescriptor.empty(this.element) : super([], []);
}
