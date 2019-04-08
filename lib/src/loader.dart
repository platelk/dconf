import 'dart:convert';
import 'package:yaml/yaml.dart';

import './config.dart';

/// [Loader] is an abstract class which will contains the retrieve of the configuration
/// from the defined sources, apply it on specific order to have a resolved configuration
abstract class Loader {
	String _configName;
	String _defaultConfigType;
	Map<String, dynamic Function(String)> _parsers = {};
	
	Loader() {
		this._parsers["yaml"] = loadYaml;
		this._parsers["json"] = json.decode;
	}
	
	Config load();
	Config loadFrom(String content) {
		return new Config.fromMap(_parsers[_defaultConfigType](content));
	}
	set configType(String name) => _defaultConfigType = name.toLowerCase();
	set configName(String name) => _configName = name;
}
