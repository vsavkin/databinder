part of databinder;

abstract class _BinderBase {
  Reflector reflector = new Reflector();
  Object object;

  _BinderBase(this.object);

  visitElement(ElementNodeDescriptor e){
  }

  visitText(TextNodeDescriptor t){
  }

  visitAttribute(AttributeDescriptor a){
  }

  visitDataBinding(DataBindingDescriptor d){
  }

  bind(NodeDescriptor n)
    => n.visit(this);
}