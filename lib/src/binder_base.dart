part of databinder;

abstract class _BinderBase {
  Reflector reflector = new Reflector();
  var object;

  _BinderBase(this.object);

  visitElement(ElementNode e){
    for (var child in e.children) {
      child.visit(this);
    }
  }

  visitText(TextNode t){
  }

  visitAttribute(AttributeNode a){
  }

  visitDataBinding(DataBindingNode d){
  }

  visitDataAction(DataActionNode d){
  }

  visitTemplate(TemplateNode t){
  }

  bind(NodeDescriptor n)
    => n.visit(this);
}