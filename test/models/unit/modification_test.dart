import 'package:gearforce/models/unit/modification.dart';
import 'package:gearforce/models/unit/unit_core.dart';
import 'package:test/test.dart';

void main() {
  test('check default modification constructor', () {
    final m = Modification(name: 'test', changes: Map());
    const testCDore = UnitCore.test();

    expect(m.name, equals('test'), reason: 'check name');
    expect(m.requirementCheck(testCDore), equals(true),
        reason: 'default requirement check');
  });

  test('check requirement check should be false', () {
    final m = Modification(
      name: 'test',
      requirementCheck: (UnitCore u) => false,
      changes: Map(),
    );
    const testCDore = UnitCore.test();

    expect(m.requirementCheck(testCDore), equals(false),
        reason: 'requirement check should report false');
  });
}
