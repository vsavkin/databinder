part of databinder_impl;

class OneWayDataBinder extends BinderBase{
  OneWayDataBinder(sourceObject) : super(sourceObject);

  visitText(TextNode t)
    => setupBinding(t);

  visitAttribute(AttributeNode a)
    => setupBinding(a);

  setupBinding(node){
    var propHandles = buildPropertyHandles(node.boundNames);
    var dynamicValue = buildDynamicValue(node.value, propHandles);
    var updateViewCallback = (_) => node.value = dynamicValue();
    setupWatchers(propHandles, updateViewCallback);
  }

  buildPropertyHandles(boundNames)
    => boundNames.reduce({}, (memo, curr){
      memo[curr] = reflector.createPropertyHandle(sourceObject, curr);
      return memo;
    });

  buildDynamicValue(str, handles)
    => new DynamicValueBuilder(str, handles).build();

  setupWatchers(propHandles, updateViewCallback){
    for(var propHandle in propHandles.values){
      modelObservers.register(propHandle.getter, updateViewCallback);
    }
  }
}

class DynamicValueBuilder{
  final String str;
  final Map handles;
  final BinderConfiguration config = new BinderConfiguration();

  DynamicValueBuilder(this.str, this.handles);

  build() =>
    buildFunction(buildParts());

  buildParts(){
    var matches = config.oneWayBindingRegex.allMatches(str);

    var parts = [];
    var lastEnd = 0;

    for(var i in matches){
      parts.add(str.substring(lastEnd, i.start));
      parts.add(new _BoundName(i.group(1)));
      lastEnd = i.end;
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
          res.add(handles[p.name].getter());
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
