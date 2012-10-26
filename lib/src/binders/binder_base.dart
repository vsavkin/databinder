part of databinder_impl;

abstract class BinderBase {
  Reflector reflector = new Reflector();
  ModelObservers modelObservers;
  DomObservers domObservers;

  var sourceObject;

  BinderBase(this.sourceObject){
    modelObservers = new ModelObservers();
    domObservers = new DomObservers(this);
  }

  bind(NodeDescriptor n)
    => n.visit(this);

  unbind(){
    modelObservers.removeAll();
    domObservers.removeAll();
  }

  notify()
    => modelObservers.notify();

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