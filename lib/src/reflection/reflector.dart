part of databinder_impl;

typedef PropertyGetter();
typedef PropertySetter(newValue);

class PropertyHandle {
  PropertyGetter getter;
  PropertySetter setter;

  PropertyHandle(this.getter, this.setter);
}

class Reflector {
  PropertyHandle createPropertyHandle(object, String prop) {
    var mirror = reflect(object);
    var getter = getter(mirror, object, prop);
    var setter = setter(mirror, object, prop);
    return new PropertyHandle(getter, setter);
  }

  createCallback(object, String method){
    var mirror = reflect(object);
    return methodCall(mirror, object, method);
  }

  readProperty(object, String prop){
    var mirror = reflect(object);
    return read(mirror, object, prop);
  }


  methodCall(mirror, object, method)
    => (e){
      try{
        mirror.invoke(method, [reflect(e)]).value;
      } on MirroredCompilationError catch(e){
        throw new DataBinderException("Method ${method} cannot be called on ${object}", e);
      } on FutureUnhandledException catch(e){
        throw new DataBinderException("Object ${object} cannot be bound to ${method}", e);
      }
    };


  read(mirror, object, prop) {
    try {
      return mirror.getField(prop).value.reflectee;
    } on MirroredCompilationError catch(e){
      throw new DataBinderException("Object ${object} cannot be bound to ${prop}", e);
    } on FutureUnhandledException catch(e){
      throw new DataBinderException("Object ${object} cannot be bound to ${prop}", e);
    }
  }

  getter(mirror, object, prop)
    => (){
      try{
        return mirror.getField(prop).value.reflectee;
      } on MirroredCompilationError catch(e){
        throw new DataBinderException("Object ${object} cannot be bound to ${prop}", e);
      } on FutureUnhandledException catch(e){
        throw new DataBinderException("Object ${object} cannot be bound to ${prop}", e);
      }
    };

  setter(mirror, object, prop)
    => (newValue){
      try{
        mirror.setField(prop, newValue).value;
      } on MirroredCompilationError catch(e){
        throw new DataBinderException("Object ${object} cannot be bound to ${prop}", e);
      } on FutureUnhandledException catch(e){
        throw new DataBinderException("Object ${object} cannot be bound to ${prop}", e);
      }
    };
}
