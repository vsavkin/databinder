part of databinder;

class Reflector {
  Handle createHandle(Dynamic object, String prop) {
    var mirror = reflect(object);
    prop = new String.fromCharCodes(prop.charCodes());

    var getter = _getter(mirror, object, prop);
    var setter = _setter(mirror, object, prop);
    return new Handle(getter, setter);
  }

  _getter(mirror, object, prop) =>
    (){
      try{
        return mirror.getField(prop).value.reflectee.toString();
      } on MirroredCompilationError {
        throw new DataBinderException("Object ${object} cannot be bound to ${prop}");
      }
    };

  _setter(mirror, object, prop) =>
    (newValue){
      try{
        mirror.setField(prop, newValue);
      } on MirroredCompilationError {
        throw new DataBinderException("Object ${object} cannot be bound to ${prop}");
      }
    };
}