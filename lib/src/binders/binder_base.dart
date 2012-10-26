part of databinder_impl;

abstract class BinderBase {
  Reflector reflector = new Reflector();
  ModelObservers modelObservers = new ModelObservers();
  DomObservers domObservers = new DomObservers();

  var sourceObject;

  BinderBase(this.sourceObject);

  bind(NodeDescriptor n)
    => n.visit(this);

  unbind(){
    modelObservers.removeAll();
    domObservers.removeAll();
  }

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