import 'dart:convert';

import 'package:yaml/yaml.dart';

import './config.dart';

/// [Loader] is an abstract class which will contains the retrieve of the configuration
/// from the defined sources, apply it on specific order to have a resolved configuration
abstract class Loader {
  String configName = "config";
  String _defaultConfigType = "yaml";
  Map<String, dynamic Function(String)> parsers = {};

  Loader() {
    this.parsers["yaml"] = _ymlParser;
    this.parsers["yml"] = _ymlParser;
    this.parsers["json"] = json.decode;
  }

  Config load();
  void loadIn(Config conf) {
    conf.merge(load());
  }

  Config loadFrom(String content, {String extension}) {
    extension ??= _defaultConfigType;
    extension = extension.isEmpty ? _defaultConfigType : extension;
    return new Config.fromMap(parsers[extension](content));
  }

  set configType(String name) => _defaultConfigType = name.toLowerCase();
}

dynamic _ymlParser(String content) {
  var v = loadYaml(content);
  return json.decode(json.encode(v));
}
