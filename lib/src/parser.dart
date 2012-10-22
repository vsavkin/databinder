part of databinder;

class Parser {
  final BinderConfiguration _config = new BinderConfiguration();

  ElementNodeDescriptor parse(Element e) {
    var res = _parseElement(e);
    return res != null ? res : new ElementNodeDescriptor.empty(e);
  }

  _parseElement(Element e) {
    var nodes = _parseChildrenNodes(e);
    nodes.addAll(_parseAttributes(e));
    return (!nodes.isEmpty()) ? new ElementNodeDescriptor(e, nodes) : null;
  }

  _parseChildrenNodes(element) =>
    element
      .nodes
      .map((_) => _parseNode(_))
      .filter((_) => _ != null);

  _parseNode(node) =>
    (node is Text) ?
      _parseTextNode(node) :
      _parseElement(node);

  _parseTextNode(textNode) {
    var matches = _config.oneWayBindingRegex.allMatches(textNode.text);
    if (matches == null) return null;

    var attrNames = matches.map((Match m) => m.group(1));
    return new TextNodeDescriptor(textNode, attrNames);
  }

  _parseAttributes(element){
    var res = [];
    element.attributes.forEach((k,v){
      res.add(_parseAttribute(element, k, v));
    });
    return res.filter((_) => _ != null);
  }

  _parseAttribute(element, attrName, attrValue){
    var matches = _config.oneWayBindingRegex.allMatches(attrValue);
    if (matches == null) return null;

    var attrNames = matches.map((Match m) => m.group(1));
    return new AttributeDescriptor(element, attrName, attrNames);
  }
}