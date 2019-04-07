/// [Config] will hold the configuration
class Config {
  Map<String, dynamic> _conf = {};
  Map<String, String> _alias = {};

  Config();

  Config.fromMap(Map<String, dynamic> values) {
  	this._conf = values;
  }
  
  /// [alias] will allow to give a specific key an alias name.
  void alias(String from, String to) {
    _alias[from.toLowerCase()] = to.toLowerCase();
  }

  // _resolveAlias will return the final name of a given key
  // after resolving all its aliases.
  String _resolveAlias(String from) {
    while (_alias.containsKey(from)) {
      from = _alias[from];
    }
    return from;
  }
  
  /// Return the value under [key] in the configuration
  dynamic operator [](String key) {
    return _resolve(key);
  }
  
  operator[]=(String key, dynamic val) {
    _apply(key, val);
  }

  /// [resolve] will return the value after resolving the graph
  /// each layer is separated by a '.'
  dynamic _resolve(String key, {String sep = '.'}) {
  	key = key.toLowerCase();
	  var keys = key.split(sep);
	  var val = _conf;
	  for (var i = 0; i < (keys.length-1); i++) {
	  	var k = _resolveAlias(keys[i]);
		  val = val != null ? val[k] : null;
	  }
	  return val != null ? val[_resolveAlias(keys.last)] : null;
  }

  /// [apply] will return the value after resolving the graph
  /// each layer is separated by a '.'
  void _apply(String key, dynamic value, {String sep = '.'}) {
  	key = key.toLowerCase();
	  var keys = key.split(sep);
	  var val = _conf;
	  for (var i = 0; i < (keys.length-1); i++) {
	  	var k = _resolveAlias(keys[i]);
		  if (!val.containsKey(k)) {
		  	val[k] = <String, dynamic>{};
		  }
		  val = val[k];
	  }
	  val ??= <String, dynamic>{};
	  val[_resolveAlias(keys.last)] = value;
  }
}
