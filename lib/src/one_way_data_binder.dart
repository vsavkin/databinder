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
    _setupBinding(t);
  }

  visitAttribute(AttributeDescriptor a){
    _setupBinding(a);
  }

  _setupBinding(node){
    var handles = _buildHandles(node.boundNames);
    var dynamicValue = _buildDynamicValue(node.value, handles);
    _setupWatchers(node, handles, dynamicValue);
  }

  _setupWatchers(node, handles, dynamicValue){
    for(var handle in handles.getValues()){
      _setupWatcher(node, handle, dynamicValue);
    }
  }

  _setupWatcher(node, handle, dynamicValue){
    var callback = (_) => node.value = dynamicValue();
    watchers.add(watch(handle, callback));
    callback(new WatchEvent(null, handle.value));
  }

  _buildHandles(boundNames) =>
    boundNames.reduce({}, (memo, curr){
      memo[curr] = reflector.createHandle(object, curr);
      return memo;
    });

  _buildDynamicValue(str, handles) =>
    new _DynamicValueBuilder(str, handles).build();
}

class _DynamicValueBuilder{
  final String str;
  final Map handles;
  final BinderConfiguration config = new BinderConfiguration();

  _DynamicValueBuilder(this.str, this.handles);

  build() =>
    buildFunction(buildParts());

  buildParts(){
    var matches = config.oneWayBindingRegex.allMatches(str);

    var parts = [];
    var lastEnd = 0;

    for(var i in matches){
      parts.add(str.substring(lastEnd, i.start()));
      parts.add(new _BoundName(i.group(1)));
      lastEnd = i.end();
    }
    parts.add(str.substring(lastEnd, str.length));

    return parts;
  }

  buildFunction(parts){
    return (){
      var res = new StringBuffer();
      for(var p in parts){
        if(p is String){
          res.add(p);
        } else {
          res.add(handles[p.name].value);
        }
      }
      return res.toString();
    };
  }
}

class _BoundName {
  final String name;
  _BoundName(this.name);
}
