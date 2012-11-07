part of databinder_impl;

abstract class BinderBase {
  Reflector reflector = new Reflector();
  Scope scope;

  var sourceObject;

  BinderBase(this.sourceObject, this.scope);

  bind(node)
    => node.visit(this);

  visitElement(ElementNode e)
    => e.children.forEach((_) => _.visit(this));

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
}