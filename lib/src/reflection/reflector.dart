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
    prop = sanitizeString(prop);

    var getter = getter(mirror, object, prop);
    var setter = setter(mirror, object, prop);
    return new PropertyHandle(getter, setter);
  }

  createCallback(object, String method){
    var mirror = reflect(object);
    method = sanitizeString(method);
    return methodCall(mirror, object, method);
  }

  readProperty(object, String prop){
    var mirror = reflect(object);
    prop = sanitizeString(prop);
    return read(mirror, object, prop);
  }


  methodCall(mirror, object, method)
    => (e){
      try{
        mirror.invoke(method, [reflect(e)]).value;
      } on MirroredCompilationError catch(e){
        throw new DataBinderException("Method ${method} cannot be called on ${object}", e);
      }
    };

  read(mirror, object, prop) {
    try {
      return mirror.getField(prop).value.reflectee;
    } on MirroredCompilationError catch(e){
      throw new DataBinderException("Object ${object} cannot be bound to ${prop}", e);
    }
  }

  getter(mirror, object, prop)
    => (){
      try{
        return mirror.getField(prop).value.reflectee.toString();
      } on MirroredCompilationError catch(e){
        throw new DataBinderException("Object ${object} cannot be bound to ${prop}", e);
      }
    };

  setter(mirror, object, prop)
    => (newValue){
      try{
        mirror.setField(prop, sanitizeString(newValue)).value;
      } on MirroredCompilationError catch(e){
        throw new DataBinderException("Object ${object} cannot be bound to ${prop}", e);
      }
    };

  sanitizeString(str)
    => new String.fromCharCodes(str.charCodes());
}
