import 'package:gearforce/models/mods/unitUpgrades/unit_modification.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/unit/unit_core.dart';
import 'package:test/test.dart';

void main() {
  test('check default modification constructor', () {
    final m = UnitModification(
      name: 'test',
    );
    const testCDore = UnitCore.test();

    expect(m.name, equals('test'), reason: 'check name');
    expect(m.requirementCheck(Unit(core: testCDore)), equals(true),
        reason: 'default requirement check');
  });

  test('check requirement check should be false', () {
    final m = UnitModification(
      name: 'test',
      requirementCheck: (Unit u) => false,
    );
    const testCDore = UnitCore.test();

    expect(m.requirementCheck(Unit(core: testCDore)), equals(false),
        reason: 'requirement check should report false');
  });

  test('test mod to increase ew by 1, from 5 to 4', () {
    final m = UnitModification(
      name: 'increase ew by 1',
      requirementCheck: (Unit uc) => false,
    );
    m.addMod(UnitAttribute.ew, (dynamic value) => (value as int) - 1);
    const testCore = UnitCore.test();

    final attType = UnitAttribute.ew;
    expect(m.applyMods(attType, testCore.attribute(attType)), equals(4),
        reason: 'apply mod');
  });

  test('test applyMod with no stored mod', () {
    final m = UnitModification(
      name: 'empty mod',
      requirementCheck: (Unit u) => false,
    );
    const testCore = UnitCore.test();

    expect(m.applyMods(UnitAttribute.ew, testCore.attribute(UnitAttribute.ew)),
        equals(testCore.ew),
        reason: 'apply mod');
  });
}
