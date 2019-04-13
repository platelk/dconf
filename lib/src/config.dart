import 'dart:convert';
import 'package:collection/collection.dart';

/// [Config] will hold the configuration after the load.
/// It will allow to retrieve or to override configurations
/// It can use dot notation to resolve deepest configuration key
/// like ```conf["key1.subkey1"]```
class Config {
  Map<String, dynamic> _conf = {};
  Map<String, String> _alias = {};

  Config();

  Config.fromMap(Map<String, dynamic> values) {
  	this._conf = values ?? <String, dynamic>{};
  }
  
  void merge(Config conf) {
  	if (conf == null) {
  		return;
	  }
  	this._conf = mergeMaps(this._conf, conf._conf, value: _combValues);
  	this._alias = mergeMaps<String, String>(this._alias, conf._alias);
  }
  
  /// [alias] will allow to give a specific key an alias name.
  void alias(String from, String to) {
    _alias[from.toLowerCase()] = to.toLowerCase();
  }

  T get<T>(String key) {
  	return _resolve(key) as T;
  }
  
  /// Return the value under [key] in the configuration
  
  dynamic operator [](String key) {
    return _resolve(key);
  }
  operator[]=(String key, dynamic val) {
    _apply(key, val);
  }
  
  String toString() {
  	return json.encode(_conf);
  }
  
  // _resolveAlias will return the final name of a given key
  // after resolving all its aliases.
  String _resolveAlias(String from) {
    while (_alias.containsKey(from)) {
      from = _alias[from];
    }
    return from;
  }

  /// [_resolve] will return the value after resolving the graph
  /// each layer is separated by a '.'
  dynamic _resolve(String key, {String sep = '.'}) {
	  var keys = key.toLowerCase().split(sep);
	  var val = _conf;
	  for (var i = 0; i < (keys.length-1); i++) {
		  val = val != null ? val[_resolveAlias(keys[i])] : null;
	  }
	  return val != null ? val[_resolveAlias(keys.last)] : null;
  }

  /// [_apply] will return the value after resolving the graph
  /// each layer is separated by a '.'
  void _apply(String key, dynamic value, {String sep = '.'}) {
	  var keys = key.toLowerCase().split(sep);
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

dynamic _combValues(dynamic v1, dynamic v2) {
	if (v1 is Map && v2 is Map && v1 != null && v2 != null) {
		return mergeMaps(v1, v2, value: _combValues);
	}
	return v2;
}
