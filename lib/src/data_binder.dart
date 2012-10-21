part of databinder;

class DataBinder {
  Parser parser = new Parser();
  Reflector reflector = new Reflector();

  Element element;
  Object object;
  List _watchers = [];

  DataBinder(this.element, this.object);

  void bind() {
    _processNode(parser.parse(element));
  }

  void disposeWatchers(){
    _watchers.forEach((_) => _());
  }

  _processNode(NodeDescriptor n){
    _processBoundNames(n);
    _processChildren(n);
  }

  _processBoundNames(NodeDescriptor n){
    for(var name in n.boundNames){
      _processBoundName(n, name);
    }
  }

  _processBoundName(NodeDescriptor n, name){
    var handle = reflector.createHandle(object, name);

    var callback = (event) {
      n.update(name, event.newValue);
    };

    _watchers.add(watch(handle, callback));

    n.update(name, handle.value);
  }

  _processChildren(NodeDescriptor n) {
    for (var child in n.children) {
      _processNode(child);
    }
  }
}
