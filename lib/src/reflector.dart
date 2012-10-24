part of databinder;

class Reflector {
  Handle createPropertyHandle(object, String prop) {
    var mirror = reflect(object);
    prop = _sanitizeString(prop);

    var getter = _getter(mirror, object, prop);
    var setter = _setter(mirror, object, prop);
    return new Handle(getter, setter);
  }

  createCallback(object, String method){
    var mirror = reflect(object);
    method = _sanitizeString(method);
    return _methodCall(mirror, object, method);
  }

  readProperty(object, String prop){
    var mirror = reflect(object);
    prop = _sanitizeString(prop);
    return _read(mirror, object, prop);
  }

  _methodCall(mirror, object, method)
    => (e){
      try{
        mirror.invoke(method, [reflect(e)]).value;
      } on MirroredCompilationError catch(e){
        throw new DataBinderException("Method ${method} cannot be called on ${object}", e);
      }
    };

  _read(mirror, object, prop) {
    try {
      return mirror.getField(prop).value.reflectee;
    } on MirroredCompilationError catch(e){
      throw new DataBinderException("Object ${object} cannot be bound to ${prop}", e);
    }
  }

  _getter(mirror, object, prop)
    => (){
      try{
        return mirror.getField(prop).value.reflectee.toString();
      } on MirroredCompilationError catch(e){
        throw new DataBinderException("Object ${object} cannot be bound to ${prop}", e);
      }
    };

  _setter(mirror, object, prop)
    => (newValue){
      try{
        mirror.setField(prop, _sanitizeString(newValue)).value;
      } on MirroredCompilationError catch(e){
        throw new DataBinderException("Object ${object} cannot be bound to ${prop}", e);
      }
    };

  _sanitizeString(str)
    => new String.fromCharCodes(str.charCodes());
}
