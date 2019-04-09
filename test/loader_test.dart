import 'package:dconf/dconf.dart' as conf;
import 'package:test/test.dart';

void main() {
	group('loader loadFrom', () {
		test('parse yaml', () {
			var loader = new conf.IOLoader();
			loader.configType = "yaml";
			var c = loader.loadFrom("""
---
debug: true
user:
  firstname: "john"
  lastname: "doe"
""");
			expect(c["debug"], isTrue);
			expect(c["user.firstname"], equals("john"));
		});
		test('parse json', () {
			var loader = new conf.IOLoader();
			loader.configType = "json";
			var c = loader.loadFrom("""
{
	"debug": true,
	"user": {
		"firstname": "john",
		"lastname": "doe"
	}
}
""");
			expect(c["debug"], isTrue);
			expect(c["user.firstname"], equals("john"));
		});
	});
}
