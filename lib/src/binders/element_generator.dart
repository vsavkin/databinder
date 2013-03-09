part of databinder_impl;

class ElementGenerator {
  h.Element template;
  h.Element marker;
  List<h.Element> current = [];

  ElementGenerator(h.Element templateEl, h.Element place){
    template = createTemplateElement(templateEl);
    marker = createMarkerElement();

    place.replaceWith(marker);
    current = [marker];
  }

  clear()
    => generateElements(0);

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
    var nonEmptyNodes = e.nodes.where((n) => !emptyTextNode(n));

    if (nonEmptyNodes.length == 1 && nonEmptyNodes[0] is h.Element) {
      return nonEmptyNodes[0].clone(true);
    } else {
      var elTemplate = new h.Element.html("<div>");
      elTemplate.nodes = e.nodes;
      return elTemplate.clone(true);
    }
  }

  emptyTextNode(n) => n is h.Text && n.text.trim() == "";

  createMarkerElement() => new h.Element.html("<span style='display:none'></span>");
}