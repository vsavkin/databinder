part of databinder;

class Parser {
  final BinderConfiguration _config = new BinderConfiguration();

  ElementDescriptor parse(h.Element element) {
    var res = _parseElement(element);
    return res != null ? res : new ElementDescriptor.empty(element);
  }

  _parseElement(element)
    => (element.tagName == "template") ?
      _parseTemplate(element) :
      _parseSimpleElement(element);

  _parseTemplate(element)
    => new TemplateDescriptor(element);

  _parseSimpleElement(element) {
    var nodes = _parseChildrenNodes(element);
    nodes.addAll(_parseAttributes(element));
    return (!nodes.isEmpty()) ? new ElementDescriptor(element, nodes) : null;
  }

  _parseChildrenNodes(element)
    => element
      .nodes
      .map((_) => _parseNode(_))
      .filter((_) => _ != null);

  _parseNode(node)
    => (node is h.Text) ?
      _parseTextNode(node) :
      _parseElement(node);

  _parseTextNode(textNode) {
    var matches = _config.oneWayBindingRegex.allMatches(textNode.text);
    if (matches == null) return null;

    var attrNames = matches.map((Match m) => m.group(1));
    return new TextDescriptor(textNode, attrNames);
  }

  _parseAttributes(element){
    var res = [];
    element.attributes.forEach((k,v){
      res.add(_parseAttribute(element, k, v));
    });
    return res.filter((_) => _ != null);
  }

  _parseAttribute(element, attrName, attrValue){
    switch(attrName){
      case "data-bind":
        return _parseDataBinding(element, attrValue);
      case "data-action":
        return _parseDataAction(element, attrValue);
      default:
        return _parseSimpleAttribute(element, attrName, attrValue);
    }
  }

  _parseSimpleAttribute(element, attrName, attrValue) {
    var matches = _config.oneWayBindingRegex.allMatches(attrValue);
    if (matches == null) return null;

    var attrNames = matches.map((Match m) => m.group(1));
    return new AttributeDescriptor(element, attrName, attrNames);
  }

  _parseDataBinding(element, attrValue)
    => new DataBindingDescriptor(element, attrValue);

  _parseDataAction(element, attrValue)
    => new DataActionDescriptor(element, attrValue);
}