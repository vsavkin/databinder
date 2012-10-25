part of databinder;

class _TwoWayDataBinder extends _BinderBase{
  List watchers = [];
  List listeners = [];

  _TwoWayDataBinder(object) : super(object);

  unbind(){
    watchers.forEach((_) => _());
    listeners.forEach((_) => _.deattach());
  }

  visitDataBinding(DataBindingNode d){
    var handle = _createHandle(d);
    _setupModelToViewListener(d, handle);
    _setupViewToModelListener(d, handle);
  }

  _createHandle(desc){
    var name = desc.propName.substring(6);
    return reflector.createPropertyHandle(object, name);
  }

  _setupModelToViewListener(desc, handle){
    var updateElement = (event) => desc.value = event.newValue;
    watchers.add(watch(handle, updateElement));
    updateElement(new WatchEvent(null, handle.value));
  }

  _setupViewToModelListener(desc, handle){
    var callback = (_) => handle.value = desc.value;

    var listener = new _AttachedListener(desc.element.on.change, callback);
    listeners.add(listener);

//    listener = new _AttachedListener(desc.element.on.keyUp, callback);
//    listeners.add(listener);

    listener.attach();
  }
}