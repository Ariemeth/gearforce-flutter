import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/unit/movement.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit.dart';
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
    var g = Group(role: RoleType.GP)..units.add(createDefaultUnit());
    expect(g.role, isNotNull, reason: 'role notifer');
    expect(g.role.value, equals(RoleType.GP), reason: 'check group name');
    expect(g.units.length, equals(1), reason: 'should be 1 unit');
    expect(g.totalTV(), equals(5), reason: 'check default total tv');

    g.reset();
    expect(g.role, isNotNull, reason: 'role notifer');
    expect(g.role.value, equals(null), reason: 'check group name');
    expect(g.units.length, equals(0), reason: 'should be 0 units');
    expect(g.totalTV(), equals(0), reason: 'check default total tv');
  });
}

Unit createDefaultUnit() {
  return Unit(
      name: 'test',
      tv: 5,
      role: Roles(roles: [Role(name: RoleType.GP)]),
      movement: Movement(type: 'G', rate: 6),
      armor: 7,
      hull: 4,
      structure: 3,
      actions: 1,
      gunnery: 5,
      piloting: 6,
      ew: 2,
      reactWeapons: [],
      mountedWeapons: [],
      traits: ['hands'],
      type: 'test',
      height: '1.5');
}
