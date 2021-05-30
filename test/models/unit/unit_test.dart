import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_core.dart';
import 'package:test/test.dart';

void main() {
  test('test creating a unit with a test unit', () {
    const testCore = UnitCore.test();
    final testUnit = Unit(core: testCore);

    expect(testUnit.name(), equals(testCore.name), reason: 'compare name');
    expect(testUnit.ew(), equals(testCore.ew), reason: 'compare ew');
  });
}
