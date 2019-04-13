import 'dart:io';
import 'package:dconf/src/config.dart';

import './loader.dart';

class IOLoader extends Loader {
  List<String> _paths = ["."];
  String envPrefix = "dconf";
  String Function(String) envReplacer = rewriteEnvKey;
  
  @override
  Config load() {
    var conf = new Config();
    conf.merge(_loadFromEnv());
    conf.merge(_loadFromFiles());
    return conf;
  }
  
  Config _loadFromFiles() {
    var conf = new Config();
    for (var path in _paths) {
      for (var ext in this.parsers.keys) {
        conf.merge(loadFromPath("${path}/${configName}.${ext}"));
      }
    }
    return conf;
  }
  
  Config _loadFromEnv() {
    var conf = new Config();
    Platform.environment.forEach((key, value) {
      var resolvedKey = envReplacer(key);
      if (resolvedKey.startsWith(envPrefix.toLowerCase())) {
        conf[resolvedKey.substring(envPrefix.length+1)] = value;
      }
    });
    return conf;
  }
  
  void addPath(String path) => _paths.add(path);
  
  Config loadFromPath(String path) {
    var f = new File(path);
    if (!f.existsSync()) {
      return null;
    }
    var content = f.readAsStringSync();
    return this.loadFrom(content);
  }
}

String rewriteEnvKey(String envKey) {
  return envKey.splitMapJoin("_", onMatch: (m) => ".", onNonMatch: (m) => m.toLowerCase());
}
