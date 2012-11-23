part of databinder_impl;

class Parser {
  final config = new BinderConfiguration();

  parse(h.Element element) {
    var res = parseElement(element);
    return res != null ? res : new ElementNode.empty(element);
  }

  parseElement(element)
    => (element.tagName == "TEMPLATE") ?
      parseTemplate(element) :
      parseSimpleElement(element);

  parseTemplate(element)
    => new TemplateNode(element);

  parseSimpleElement(element) {
    var nodes = parseChildrenNodes(element);
    nodes.addAll(parseAttributes(element));
    return (!nodes.isEmpty) ? new ElementNode(element, nodes) : null;
  }

  parseChildrenNodes(element)
    => element
      .nodes
      .map((_) => parseNode(_))
      .filter((_) => _ != null);

  parseNode(node)
    => (node is h.Text) ?
      parseTextNode(node) :
      parseElement(node);

  parseTextNode(textNode) {
    var matches = config.oneWayBindingRegex.allMatches(textNode.text);
    if (matches == null) return null;

    var attrNames = matches.map((Match m) => m.group(1));
    return new TextNode(textNode, attrNames);
  }

  parseAttributes(element){
    var res = [];
    element.attributes.forEach((k,v){
      res.add(parseAttribute(element, k, v));
    });
    return res.filter((_) => _ != null);
  }

  parseAttribute(element, attrName, attrValue){
    switch(attrName){
      case "data-bind":
        return parseDataBinding(element, attrValue);
      case "data-action":
        return parseDataAction(element, attrValue);
      default:
        return parseSimpleAttribute(element, attrName, attrValue);
    }
  }

  parseSimpleAttribute(element, attrName, attrValue) {
    var matches = config.oneWayBindingRegex.allMatches(attrValue);
    if (matches == null) return null;

    var attrNames = matches.map((Match m) => m.group(1));
    return new AttributeNode(element, attrName, attrNames);
  }

  parseDataBinding(element, attrValue)
    => new DataBindingNode(element, attrValue);

  parseDataAction(element, attrValue)
    => new DataActionNode(element, attrValue);
}