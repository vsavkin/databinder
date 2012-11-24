part of databinder_impl;

class OneWayDataBinder extends BinderBase{
  OneWayDataBinder(scope, transformations) : super(scope, transformations);

  visitText(TextNode t)
    => setupBinding(t);

  visitAttribute(AttributeNode a)
    => setupBinding(a);

  setupBinding(node){
    var propHandles = buildPropertyHandles(node.pathExpressions);
    var dynamicValue = buildDynamicValue(node.value, propHandles);
    var updateViewCallback = (_) => node.value = dynamicValue();
    setupWatchers(propHandles, updateViewCallback);
  }

  buildPropertyHandles(boundNames)
    => boundNames.reduce({}, (memo, curr){
      memo[curr] = reflector.createPropertyHandle(scope.boundObjects, curr);
      return memo;
    });

  buildDynamicValue(str, handles)
    => new DynamicValueBuilder(str, handles).build();

  setupWatchers(propHandles, updateViewCallback){
    for(var propHandle in propHandles.values){
      scope.registerModelObserver(propHandle.getter, updateViewCallback);
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
      parts.add(new _BoundExpression(i.group(1)));
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
          res.add(handles[p.exp].getter());
        }
      }
      return res.toString();
    };
  }
}

class _BoundExpression {
  final String exp;
  _BoundExpression(this.exp);
}
