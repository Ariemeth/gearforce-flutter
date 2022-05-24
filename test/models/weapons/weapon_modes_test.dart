import 'package:gearforce/models/weapons/weapon_modes.dart';
import 'package:test/test.dart';

void main() {
  test('test converting weaponMode to string for Direct', () {
    expect(getWeaponModeName(weaponModes.Direct), equals('Direct'));
  });

  test('test converting weaponMode to string for Indirect', () {
    expect(getWeaponModeName(weaponModes.Indirect), equals('Indirect'));
  });

  test('test converting weaponMode to string for Melee', () {
    expect(getWeaponModeName(weaponModes.Melee), equals('Melee'));
  });
}
