# Dconf
Dart package inspired by [viper](https://github.com/spf13/viper) in golang to manage configuration

## Why Dconf ?

When building a modern application, you don’t want to worry about configuration file formats; you want to focus on building awesome software

Dconf provide :

* Find, load, and unmarshal a configuration file in JSON or YAML formats.
* Provide an alias system to easily rename parameters without breaking existing code.
* Automatic binding from environment variable

## Putting values

You can put values in the configuration by simply create a configuration holder object

```dart
import 'package:dconf/dconf.dart';

void main() {
	var conf = new Config();
	conf["http.address"] = "localhost";
	conf["http.port"] = "8080";
}
```

## Reading Config Files
Dconf requires minimal configuration so it knows where to look for config files. Dconf can search multiple paths, but currently a single Dconf instance only supports a single configuration file. Dconf does not default to any configuration search paths leaving defaults decision to an application.

Here is an example of how to use Dconf to search for and read a configuration file. None of the specific paths are required, but at least one path should be provided where a configuration file is expected.

```dart
import 'package:dconf/dconf.dart';

void main() {
	var load = new IOLoader();
	load.addPath("./conf"); // Add lookup path
    load.addPath(".");
	var conf = load.load();
}
```

## Register alias

Aliases permit a single value to be referenced by multiple keys

```dart
import 'package:dconf/dconf.dart';

void main() {
	var conf = new Config();
	conf["http.address"] = "localhost";
	conf["http.port"] = "8080";
	conf.alias("server", "http");
	print(conf["server.port"]); // "8080"
}
```
