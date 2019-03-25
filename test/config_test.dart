import 'package:dconf/dconf.dart';
import 'package:test/test.dart';

void main() {
	group('test resolve()', () {
		test('simple resolve', () {
		});
	});
	group('test Config.get', () {
		test('simple get', () {
			var conf = new Config();
			conf["test"] = true;
			expect(conf["test"], isTrue);
		});
		test('case insensitive get', () {
			var conf = new Config();
			conf["test"] = true;
			expect(conf["Test"], isTrue);
		});
	});
	group('test Config.alias', () {
		test('Register alias', () {
			var conf = new Config();
			conf.alias("loud", "verbose");
			conf["loud"] = true;
			expect(conf["verbose"], isTrue);
		});
	});
}
