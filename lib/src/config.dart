class Config {
  Map<String, dynamic> _conf = {};
  Map<String, String> _alias = {};

  Config();

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
    return resolve(key);
  }
  
  operator[]=(String key, dynamic val) {
    apply(key, val);
  }

  /// [resolve] will return the value after resolving the graph
  /// each layer is separated by a '.'
  dynamic resolve(String key, {String sep = '.'}) {
  	key = key.toLowerCase();
	  var keys = key.split(sep);
	  for (var i = 0; i < (keys.length-1); i++) {
	  	var k = _resolveAlias(keys[i]);
		  _conf = _conf != null ? _conf[k] : null;
	  }
	  return _conf != null ? _conf[_resolveAlias(keys.last)] : null;
  }

  /// [apply] will return the value after resolving the graph
  /// each layer is separated by a '.'
  void apply(String key, dynamic value, {String sep = '.'}) {
  	key = key.toLowerCase();
	  var keys = key.split(sep);
	  for (var i = 0; i < (keys.length-1); i++) {
	  	var k = _resolveAlias(keys[i]);
		  if (_conf.containsKey(k)) {
		  	_conf[k] = new Config();
		  }
		  _conf = _conf[k];
	  }
	  _conf ??= <String, dynamic>{};
	  _conf[_resolveAlias(keys.last)] = value;
  }
}
