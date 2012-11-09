part of databinder_impl;

abstract class Transformation<T> {
  String modelToView(T value);
  T viewToModel(String value);
}

class StringTransformation implements Transformation<String>{
  String modelToView(String value) => value;
  String viewToModel(String value) => value;
}

class IntTransformation implements Transformation<int>{
  String modelToView(int value) => value.toString();
  int viewToModel(String value) => int.parse(value);
}

class BoolTransformation implements Transformation<bool>{
  String modelToView(bool value) => value.toString();
  bool viewToModel(String value) => value == "true";
}

class Transformations {
  final Map<String, Transformation> transformations = {};

  Transformations(){}

  Transformations.standard(){
    transformations["value"] = new StringTransformation();
    transformations["string"] = new StringTransformation();
    transformations["int"] = new IntTransformation();
    transformations["bool"] = new BoolTransformation();
  }

  register(String type, Transformation t)
    => transformations[type] = t;

  find(String type){
    if(! transformations.containsKey(type))
      throw new DataBinderException("No transformation defined for ${type}");
    return transformations[type];
  }
}