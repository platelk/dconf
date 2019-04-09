import 'dart:convert';
import 'package:yaml/yaml.dart';

import './config.dart';

/// [Loader] is an abstract class which will contains the retrieve of the configuration
/// from the defined sources, apply it on specific order to have a resolved configuration
abstract class Loader {
	String _configName = "config";
	String _defaultConfigType = "yaml";
	Map<String, dynamic Function(String)> parsers = {};
	
	Loader() {
		this.parsers["yaml"] = (String content) {
			var v = loadYaml(content);
			return json.decode(json.encode(v));
		};
			this.parsers["json"] = json.decode;
	}
	
	Config load();
	Config loadFrom(String content) {
		return new Config.fromMap(parsers[_defaultConfigType](content));
	}
	set configType(String name) => _defaultConfigType = name.toLowerCase();
	set configName(String name) => _configName = name;
}
