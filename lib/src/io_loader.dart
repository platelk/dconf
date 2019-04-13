import 'dart:io';
import 'package:dconf/src/config.dart';

import './loader.dart';

class IOLoader extends Loader {
  List<String> _paths = ["."];
  
  @override
  Config load() {
    return _loadFromFiles();
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
