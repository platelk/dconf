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
    key = _resolveAlias(key.toLowerCase());
    return this._conf[key];
  }
  
  operator[]=(String key, dynamic val) {
    this._conf[_resolveAlias(key.toLowerCase())] = val;
  }
}

/// [resolve] will return the value
dynamic resolve(String key, Map<String, dynamic> values, {String sep = '.'}) {
  var keys = key.split(sep);
  for (var i = 0; i < (keys.length-2); i++) {
    values = values != null ? values[keys[i]] : null;
  }
  return values != null ? values[keys.last] : null;
}
