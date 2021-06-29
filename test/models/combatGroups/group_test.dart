import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit_core.dart';
import 'package:test/test.dart';

void main() {
  test('create default Group', () {
    var g = Group();
    expect(g.role(), equals(RoleType.GP), reason: 'check group name');
    expect(g.totalTV(), equals(0), reason: 'check default total tv');
  });

  test('create Group with role', () {
    var g = Group(role: RoleType.GP);
    expect(g.role(), equals(RoleType.GP), reason: 'check group name');
    expect(g.totalTV(), equals(0), reason: 'check default total tv');
  });

  test('set role on default Group', () {
    var g = Group();
    expect(g.role(), equals(RoleType.GP), reason: 'role');
    g.changeRole(RoleType.AS);
    expect(g.role(), equals(RoleType.AS), reason: 'check group name');
  });

  test('change Group role', () {
    var g = Group(role: RoleType.GP);
    expect(g.role(), RoleType.GP, reason: 'initial role');
    g.changeRole(RoleType.AS);
    expect(g.role(), RoleType.AS, reason: 'updated role');
  });

  test('create Group with role and units being reset', () {
    var g = Group(role: RoleType.GP)..addUnit(UnitCore.test());
    expect(g.role(), isNotNull, reason: 'check role');
    expect(g.role(), equals(RoleType.GP), reason: 'check group name');
    expect(g.allUnits().length, equals(1), reason: 'should be 1 unit');
    expect(g.totalTV(), equals(5), reason: 'check default total tv');

    g.reset();
    expect(g.role(), isNotNull, reason: 'check role after reset');
    expect(g.role(), equals(RoleType.GP),
        reason: 'check group name after reset');
    expect(g.allUnits().length, equals(0),
        reason: 'should be 0 units after reset');
    expect(g.totalTV(), equals(0),
        reason: 'check default total tv after reset');
  });

  test('test totalActions with new group', () {
    var g = Group();
    expect(g.totalActions(), equals(0), reason: 'check default total actions');
  });

  test('test totalActions with added unit', () {
    var g = Group()..addUnit(UnitCore.test());
    expect(g.totalActions(), equals(1), reason: 'check total actions');
  });

  test('test totalActions with 2 added units', () {
    var g = Group()..addUnit(UnitCore.test())..addUnit(UnitCore.test());
    expect(g.totalActions(), equals(2), reason: 'check total actions');
  });
}
