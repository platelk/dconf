import 'dart:io';

import 'package:dconf/src/config.dart';
import 'package:path/path.dart' as p;

import './loader.dart';

class IOLoader extends Loader {
  List<String> _paths = [];
  String envPrefix = "dconf";
  String Function(String) envReplacer = rewriteEnvKey;

  @override
  Config load() {
    var conf = new Config();
    conf.merge(_loadFromEnv());
    conf.merge(_loadFromFiles());
    return conf;
  }

  void addPath(String path) => _paths.add(path);

  Config loadFromPath(String path) {
    var f = new File(path);
    if (!f.existsSync()) {
      return null;
    }
    return loadFromFile(f);
  }

  Config loadFromFile(File f) {
    var content = f.readAsStringSync();
    var ext = p.extension(f.path);
    ext = ext.isNotEmpty ? ext.substring(1, ext.length) : null;
    return this.loadFrom(content, extension: ext);
  }

  Config _loadFromFiles() {
    var conf = new Config();
    for (var path in _paths) {
      for (var ext in this.parsers.keys) {
        conf.merge(loadFromPath(p.join(path, "${configName}.${ext}")));
      }
    }
    return conf;
  }

  Config _loadFromEnv() {
    var conf = new Config();
    Platform.environment.forEach((key, value) {
      var resolvedKey = envReplacer(key);
      if (resolvedKey.startsWith(envPrefix.toLowerCase())) {
        conf[resolvedKey.substring(envPrefix.length + 1)] = value;
      }
    });
    return conf;
  }
}

String rewriteEnvKey(String envKey) {
  return envKey.splitMapJoin("_", onMatch: (m) => ".", onNonMatch: (m) => m.toLowerCase());
}
