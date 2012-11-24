part of databinder_impl;

abstract class BinderBase {
  Reflector reflector = new Reflector();
  Transformations transformations;
  Scope scope;

  BinderBase(this.scope, this.transformations);

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