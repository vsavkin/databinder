part of databinder_impl;

class BoundObjects {
  Map<String, Object> objects = {};

  BoundObjects.fromMap(this.objects);

  BoundObjects.root(Object obj){
    objects[""] = obj;
  }

  register(String name, Object obj)
    => objects[name] = obj;

  match(String selector)
    => objects[""];

  get length
    => objects.length;

  copy(){
    var copy = new Map.from(objects);
    return new BoundObjects.fromMap(copy);
  }
}