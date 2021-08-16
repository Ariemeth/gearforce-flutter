import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/movement.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit_core.dart';
import 'package:test/test.dart';

void main() {
  test('create default CombatGroup', () {
    const cgName = 'test1';
    var g = CombatGroup(cgName);
    expect(g.name, equals(cgName), reason: 'check cg name');
    expect(g.totalTV(), equals(0), reason: 'check default total tv');
  });

  test('test totalTV() with primary group only', () {
    const cgName = 'test1';
    var g = CombatGroup(cgName)..primary.addUnit(createDefaultUnit());
    expect(g.name, equals(cgName), reason: 'check cg name');
    expect(g.totalTV(), equals(5), reason: 'check default total tv');
  });

  test('test totalTV() with secondary group only', () {
    const cgName = 'test1';
    var g = CombatGroup(cgName)..secondary.addUnit(createDefaultUnit());
    expect(g.name, equals(cgName), reason: 'check cg name');
    expect(g.totalTV(), equals(5), reason: 'check default total tv');
  });

  test('test totalTV() with primary and secondary group', () {
    const cgName = 'test1';
    var g = CombatGroup(cgName)
      ..primary.addUnit(createDefaultUnit())
      ..secondary.addUnit(createDefaultUnit());
    expect(g.name, equals(cgName), reason: 'check cg name');
    expect(g.totalTV(), equals(10), reason: 'check default total tv');
  });

  test('test clear() with primary and secondary group', () {
    const cgName = 'test1';
    var g = CombatGroup(cgName)
      ..primary.addUnit(createDefaultUnit())
      ..secondary.addUnit(createDefaultUnit());
    expect(g.name, equals(cgName), reason: 'ensure cg name');
    expect(g.totalTV(), equals(10), reason: 'ensure default total tv');

    g.clear();
    expect(g.totalTV(), equals(0), reason: 'check no tv after clear');
  });
}

UnitCore createDefaultUnit() {
  return UnitCore(
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
      traits: [Trait(name: 'hands')],
      type: 'test',
      height: '1.5');
}
