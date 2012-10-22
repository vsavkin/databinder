part of databinder;

class _OneWayDataBinder {
  Reflector reflector = new Reflector();
  Object object;
  List watchers = [];

  _OneWayDataBinder(this.object);

  visitElement(ElementNodeDescriptor e){
    for (var child in e.children) {
      child.visit(this);
    }
  }

  visitText(TextNodeDescriptor t){
    for(var name in t.boundNames){
      var handle = reflector.createHandle(object, name);
      var callback = (event) {
        var newText = t.node.text.replaceAll("{{${name}}}", event.newValue);
        t.node.replaceWholeText(newText);
      };

      watchers.add(watch(handle, callback));
      callback(new WatchEvent(null, handle.value));
    }
  }

  visitAttribute(AttributeDescriptor a){
    for(var name in a.boundNames){
      var handle = reflector.createHandle(object, name);
      var callback = (event) {
        var newText = a.element.attributes[a.attrName].replaceAll("{{${name}}}", event.newValue);
        a.element.attributes[a.attrName] = newText;
      };
      watchers.add(watch(handle, callback));
      callback(new WatchEvent(null, handle.value));
    }
  }
}


//  createCallback(Map<String, Handle> handles){
//    var regex = const RegExp(r'{{(\w*)}}');
//    var matches = regex.allMatches(node.innerHTML);
//    node.innerHTML
//  }

//hello {{name}} is {{age}}
//node.innerHTML = "hello " + handles["name"].value + " is " handles["age"].value;