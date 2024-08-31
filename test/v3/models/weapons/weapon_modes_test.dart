import 'package:gearforce/v3/models/weapons/weapon_modes.dart';
import 'package:test/test.dart';

void main() {
  test('test converting weaponMode to string for Direct', () {
    expect(weaponModes.Direct.name, equals('Direct'));
  });

  test('test converting weaponMode to string for Indirect', () {
    expect(weaponModes.Indirect.name, equals('Indirect'));
  });

  test('test converting weaponMode to string for Melee', () {
    expect(weaponModes.Melee.name, equals('Melee'));
  });
}
