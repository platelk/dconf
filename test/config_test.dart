import 'package:dconf/dconf.dart' as conf;
import 'package:test/test.dart';

void main() {
  test('multiple key get', () {
    var c = new conf.Config();
    c["first"] = <String, dynamic>{"second": true};
    var res = c["first.second"];
    expect(res, isTrue);
  });
  test('consecutive get', () {
    var c = new conf.Config();
    c["first.second"] = true;
    expect(c["first"]["second"], isTrue);
  });
  group('test Config.get', () {
    test('simple get', () {
      var c = new conf.Config();
      c["test"] = true;
      expect(c["test"], isTrue);
    });
    test('case insensitive get', () {
      var c = new conf.Config();
      c["test"] = true;
      expect(c["Test"], isTrue);
    });
  });
  group('test Config.alias', () {
    test('Register alias', () {
      var c = new conf.Config();
      c.alias("loud", "verbose");
      c["loud"] = true;
      expect(c["verbose"], isTrue);
    });
    test('Register alias on one part of the key', () {
      var c = new conf.Config();
      c["http.port"] = "8080";
      c.alias("server", "http");
      expect(c["server.port"], equals("8080"));
    });
  });
}
