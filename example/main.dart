

import 'package:dconf/dconf.dart';

void main() {
	var load = new IOLoader();
	load.addPath("./example");
	var conf = load.load();
	print(conf);
}
