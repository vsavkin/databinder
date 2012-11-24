part of databinder_impl;

class Reflector {
  PropertyHandle createPropertyHandle(BoundObjects objects, String pathExpression) {
    var object = objects.match(pathExpression);
    var exp = new PathExpression(pathExpression);
    var getter = getter(object, exp);
    var setter = setter(object, exp);
    return new PropertyHandle(getter, setter);
  }

  createCallback(BoundObjects objects, String pathExpression) {
    var object = objects.match(pathExpression);
    var exp = new PathExpression(pathExpression);
    return methodCall(object, exp);
  }

  readProperty(object, String pathExpression) {
    var exp = new PathExpression(pathExpression);
    return read(object, exp);
  }

  methodCall(object, exp) {
    return (e) {
      wrapExceptions(exp, () {
        var receiver = extractReceiver(object, exp);
        var mirror = reflect(receiver);
        mirror.invoke(exp.propertyPart, [reflect(e)]).value;
      });
    };
  }

  read(object, exp) {
    return wrapExceptions(exp, () {
      var receiver = extractReceiver(object, exp);
      return prop(receiver, exp.propertyPart);
    });
  }

  getter(object, exp) {
    return () {
      return wrapExceptions(exp, () {
        var receiver = extractReceiver(object, exp);
        return prop(receiver, exp.propertyPart);
      });
    };
  }

  setter(object, exp) {
    return (newValue) {
      wrapExceptions(exp, () {
        var receiver = extractReceiver(object, exp);
        var mirror = reflect(receiver);
        mirror.setField(exp.propertyPart, newValue).value;
      });
    };
  }

  extractReceiver(object, exp)
    => exp.receiverParts.reduce(object, (prev, receiverPart) => prop(prev, receiverPart));

  prop(object, prop)
    => reflect(object).getField(prop).value.reflectee;

  wrapExceptions(exp, function) {
    try {
      return function();
    } on FutureUnhandledException catch(e) {
      throw new DataBinderException("${exp.fullExpression}  =>  ${e.source.message}", e);
    }
  }
}

typedef PropertyGetter();
typedef PropertySetter(newValue);

class PropertyHandle {
  PropertyGetter getter;
  PropertySetter setter;

  PropertyHandle(this.getter, this.setter);
}

class PathExpression {
  String fullExpression;

  PathExpression(this.fullExpression);

  List<String> get receiverParts => parts.getRange(0, parts.length - 1);

  String get propertyPart => parts.last;

  List<String> get parts => fullExpression.split(".");
}