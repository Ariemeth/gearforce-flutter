import 'package:gearforce/models/weapons/weapon.dart';
import 'package:test/test.dart';
import 'dart:convert';

void main() {
  test('test creating a valid weapon', () {
    const weaponCode = 'AC';
    const weaponName = 'Autocannon';

    const w = Weapon(code: weaponCode, name: weaponName);
    expect(w.code, equals(weaponCode), reason: 'check weapon code');
    expect(w.name, equals(weaponName), reason: 'check weapon name');
  });

  test('test fromJson', () {
    const weaponCode = 'AC';
    const weaponName = 'Autocannon';
    final decodedJSON =
        json.decode('{"code":"$weaponCode","name":"$weaponName"}');
    final w = Weapon.fromJson(decodedJSON);
    expect(w.code, equals(weaponCode), reason: 'check weapon code');
    expect(w.name, equals(weaponName), reason: 'check weapon name');
  });

  test('test toJson', () {
    const weaponCode = 'AC';
    const weaponName = 'Autocannon';
    final decodedJSON =
        json.decode('{"code":"$weaponCode","name":"$weaponName"}');
    const w = Weapon(code: weaponCode, name: weaponName);
    expect(w.toJson(), equals(decodedJSON));
  });
}
