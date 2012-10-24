part of databinder;

abstract class _BinderBase {
  Reflector reflector = new Reflector();
  Object object;

  _BinderBase(this.object);

  visitElement(ElementNodeDescriptor e){
    for (var child in e.children) {
      child.visit(this);
    }
  }

  visitText(TextNodeDescriptor t){
  }

  visitAttribute(AttributeDescriptor a){
  }

  visitDataBinding(DataBindingDescriptor d){
  }

  visitDataAction(DataActionDescriptor d){
  }

  bind(NodeDescriptor n)
    => n.visit(this);
}