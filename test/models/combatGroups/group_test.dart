import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit_core.dart';
import 'package:test/test.dart';

void main() {
  test('create default Group', () {
    var g = Group();
    expect(g.role, isNotNull, reason: 'role notifer');
    expect(g.role.value, equals(null), reason: 'check group name');
    expect(g.totalTV(), equals(0), reason: 'check default total tv');
  });

  test('create Group with role', () {
    var g = Group(role: RoleType.GP);
    expect(g.role, isNotNull, reason: 'role notifer');
    expect(g.role.value, equals(RoleType.GP), reason: 'check group name');
    expect(g.totalTV(), equals(0), reason: 'check default total tv');
  });

  test('create Group with role and units being reset', () {
    var g = Group(role: RoleType.GP)..addUnit(UnitCore.test());
    expect(g.role, isNotNull, reason: 'role notifer');
    expect(g.role.value, equals(RoleType.GP), reason: 'check group name');
    expect(g.allUnits().length, equals(1), reason: 'should be 1 unit');
    expect(g.totalTV(), equals(5), reason: 'check default total tv');

    g.reset();
    expect(g.role, isNotNull, reason: 'role notifer');
    expect(g.role.value, equals(null), reason: 'check group name');
    expect(g.allUnits().length, equals(0), reason: 'should be 0 units');
    expect(g.totalTV(), equals(0), reason: 'check default total tv');
  });

  test('test totalActions with new group', () {
    var g = Group(role: null);
    expect(g.totalActions(), equals(0), reason: 'check default total actions');
  });

  test('test totalActions with added unit', () {
    var g = Group(role: null)..addUnit(UnitCore.test());
    expect(g.totalActions(), equals(1), reason: 'check total actions');
  });

  test('test totalActions with 2 added units', () {
    var g = Group(role: null)
      ..addUnit(UnitCore.test())
      ..addUnit(UnitCore.test());
    expect(g.totalActions(), equals(2), reason: 'check total actions');
  });
}
