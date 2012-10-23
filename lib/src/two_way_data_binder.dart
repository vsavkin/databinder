part of databinder;

class _TwoWayDataBinder extends _BinderBase{
  List watchers = [];
  List listeners = [];

  _TwoWayDataBinder(object) : super(object);

  unbind(){
    watchers.forEach((_) => _());
    listeners.forEach((_) => _.deattach());
  }

  visitElement(ElementNodeDescriptor e){
    for (var child in e.children) {
      child.visit(this);
    }
  }

  visitDataBinding(DataBindingDescriptor d){
    var handle = _createHandle(d);
    _setupModelToViewListener(d, handle);
    _setupViewToModelListener(d, handle);
  }

  _createHandle(desc){
    var name = desc.propName.substring(6);
    return reflector.createHandle(object, name);
  }

  _setupModelToViewListener(desc, handle){
    var updateElement = (event) => desc.value = event.newValue;
    watchers.add(watch(handle, updateElement));
    updateElement(new WatchEvent(null, handle.value));
  }

  _setupViewToModelListener(desc, handle){
    var listener = new _AttachedListener(desc.element.on.change, (_) => handle.value = desc.value);
    listeners.add(listener);
    listener.attach();
  }
}

class _AttachedListener {
  EventListenerList list;
  EventListener listener;

  _AttachedListener(this.list, this.listener);

  deattach(){
    list.remove(listener);
  }

  attach(){
    list.add(listener);
  }
}