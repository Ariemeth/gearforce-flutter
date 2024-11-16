import 'package:gearforce/v3/models/weapons/weapon_modes.dart';
import 'package:test/test.dart';

void main() {
  test('test converting weaponMode to string for Direct', () {
    expect(WeaponModes.direct.name, equals('Direct'));
  });

  test('test converting weaponMode to string for Indirect', () {
    expect(WeaponModes.indirect.name, equals('Indirect'));
  });

  test('test converting weaponMode to string for Melee', () {
    expect(WeaponModes.melee.name, equals('Melee'));
  });
}
