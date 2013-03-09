part of databinder_impl;

class Reflector {
  PropertyHandle createPropertyHandle(BoundObjects objects, String pathExpression) {
    var match = objects.match(pathExpression);

    var exp = new PathExpression(match.methodSelector);
    var getter = getter(match.object, exp);
    var setter = setter(match.object, exp);

    return new PropertyHandle(getter, setter);
  }

  createCallback(BoundObjects objects, String pathExpression) {
    var match = objects.match(pathExpression);
    var exp = new PathExpression(match.methodSelector);
    return methodCall(match.object, exp);
  }

  methodCall(object, exp) {
    return (e) {
      var receiver = extractReceiver(object, exp);
      var mirror = reflect(receiver);

      var future = mirror.invoke(exp.propertyPart, [reflect(e)]);
      get_value(exp, future);
    };
  }

  getter(object, exp) {
    return () {
      var receiver = extractReceiver(object, exp);
      return prop(exp, receiver, exp.propertyPart);
    };
  }

  setter(object, exp) {
    return (newValue) {
      var receiver = extractReceiver(object, exp);
      var mirror = reflect(receiver);
      get_value(exp, mirror.setField(exp.propertyPart, newValue));
    };
  }

  extractReceiver(object, exp)
    => exp.receiverParts.reduce(object, (prev, receiverPart) => prop(exp, prev, receiverPart));

  prop(exp, object, prop)
    => get_value(exp, reflect(object).getField(prop)).reflectee;

  get_value(exp, future) {
    var v = deprecatedFutureValue(future);
    if (v is AsyncError) {
      throw new DataBinderException("${exp.fullExpression}  =>  ${v.error.message}", v.error);
    }
    return v;
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