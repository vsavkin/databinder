part of databinder_impl;

class BoundObjects {
  Map<String, Object> objects = {};

  BoundObjects.fromMap(this.objects);

  BoundObjects.root(Object obj){
    objects[""] = obj;
  }

  register(String name, Object obj)
    => objects[name] = obj;

  BoundObjectMatch match(String selector){
    var index = selector.indexOf(".");
    if(index == -1) return new BoundObjectMatch(objects[""], selector);

    var objectName = selector.substring(0, index);

    if(objects.containsKey(objectName)){
      var methodSelector = selector.substring(index + 1);
      return new BoundObjectMatch(objects[objectName], methodSelector);
    } else {
      return new BoundObjectMatch(objects[""], selector);
    }
  }

  get length
    => objects.length;

  copy(){
    var copy = new Map.from(objects);
    return new BoundObjects.fromMap(copy);
  }
}

class BoundObjectMatch {
  String methodSelector;
  Object object;

  BoundObjectMatch(this.object, this.methodSelector);
}