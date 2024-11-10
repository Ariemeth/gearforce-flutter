import 'package:gearforce/v3/models/combatGroups/group.dart';
import 'package:gearforce/v3/models/mods/unitUpgrades/north.dart';
import 'package:gearforce/v3/models/unit/model_type.dart';
import 'package:gearforce/v3/models/unit/role.dart';
import 'package:gearforce/v3/models/unit/unit.dart';
import 'package:gearforce/v3/models/unit/unit_core.dart';
import 'package:test/test.dart';

void main() {
  test('create default Group', () {
    var g = Group(GroupType.primary);
    expect(g.role(), equals(RoleType.gp), reason: 'check group name');
    expect(g.totalTV(), equals(0), reason: 'check default total tv');
  });

  test('create Group with role', () {
    var g = Group(GroupType.primary, role: RoleType.gp);
    expect(g.role(), equals(RoleType.gp), reason: 'check group name');
    expect(g.totalTV(), equals(0), reason: 'check default total tv');
  });

  test('create Group with role and units being reset', () {
    var g = Group(GroupType.primary, role: RoleType.gp)
      ..addUnit(Unit(core: const UnitCore.test()));
    expect(g.role(), isNotNull, reason: 'check role');
    expect(g.role(), equals(RoleType.gp), reason: 'check group name');
    expect(g.allUnits().length, equals(1), reason: 'should be 1 unit');
    expect(g.totalTV(), equals(5), reason: 'check default total tv');

    g.reset();
    expect(g.role(), isNotNull, reason: 'check role after reset');
    expect(g.role(), equals(RoleType.gp),
        reason: 'check group name after reset');
    expect(g.allUnits().length, equals(0),
        reason: 'should be 0 units after reset');
    expect(g.totalTV(), equals(0),
        reason: 'check default total tv after reset');
  });

  test('test totalActions with new group', () {
    var g = Group(GroupType.primary);
    expect(g.totalActions, equals(0), reason: 'check default total actions');
  });

  test('test totalActions with added unit', () {
    var g = Group(GroupType.primary)
      ..addUnit(Unit(core: const UnitCore.test()));
    expect(g.totalActions, equals(1), reason: 'check total actions');
  });

  test('test totalActions with 2 added units', () {
    var g = Group(GroupType.primary)
      ..addUnit(Unit(core: const UnitCore.test()))
      ..addUnit(Unit(core: const UnitCore.test()));
    expect(g.totalActions, equals(2), reason: 'check total actions');
  });

  test('test totalActions with 2 added units plus a drone', () {
    var g = Group(GroupType.primary)
      ..addUnit(Unit(core: const UnitCore.test()))
      ..addUnit(Unit(core: const UnitCore.test()))
      ..addUnit(Unit(core: const UnitCore.test(type: ModelType.drone)));
    expect(g.totalActions, equals(3), reason: 'check total actions');
  });

  test('test modCount with 0 mods', () {
    var g = Group(GroupType.primary)
      ..addUnit(Unit(core: const UnitCore.test()));
    expect(g.modCount('noid'), equals(0), reason: 'no mods');
  });

  test('test modCount with 1 mod but wrong id', () {
    var g = Group(GroupType.primary)
      ..addUnit(Unit(core: const UnitCore.test()));
    g.allUnits()[0].addUnitMod(headHunter);
    expect(g.modCount('noid'), equals(0), reason: 'no mods');
  });

  test('test modCount with 1 mod', () {
    var g = Group(GroupType.primary)
      ..addUnit(Unit(core: const UnitCore.test()));
    g.allUnits()[0].addUnitMod(headHunter);
    expect(g.modCount(headHunter.id), equals(1), reason: 'should find 1 mod');
  });
}
