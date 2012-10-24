part of databinder;

abstract class _BinderBase {
  Reflector reflector = new Reflector();
  var object;

  _BinderBase(this.object);

  visitElement(ElementDescriptor e){
    for (var child in e.children) {
      child.visit(this);
    }
  }

  visitText(TextDescriptor t){
  }

  visitAttribute(AttributeDescriptor a){
  }

  visitDataBinding(DataBindingDescriptor d){
  }

  visitDataAction(DataActionDescriptor d){
  }

  visitTemplate(TemplateDescriptor t){
  }

  bind(NodeDescriptor n)
    => n.visit(this);
}