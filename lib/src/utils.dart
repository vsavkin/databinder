part of databinder_impl;

zip(List a, List b){
  if(a.length != b.length) throw new RuntimeError("Zipped collections must be the same size");
  var res = [];
  for(var i = 0; i < a.length; ++i){
    res.add([a[i], b[i]]);
  }
  return res;
}