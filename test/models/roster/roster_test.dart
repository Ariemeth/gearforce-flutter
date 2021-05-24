import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/unit/movement.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:test/test.dart';

void main() {
  test('create default CombatGroup', () {
    final roster = UnitRoster();
    expect(roster.getCGs().length, equals(1),
        reason: 'check cg length to ensure proper construction');
  });

  test('get default cg', () {
    final roster = UnitRoster();
    final cg = roster.getCG('CG 1');
    expect(cg!.name, equals('CG 1'), reason: 'check cg default name');
    expect(cg.primary.allUnits().length, equals(0),
        reason: 'should be no primary units');
    expect(cg.secondary.allUnits().length, equals(0),
        reason: 'should be no secondary units');
  });

  test('add new cg', () {
    final roster = UnitRoster();
    final cg = CombatGroup('test1');
    cg.primary.addUnit(createDefaultUnit());
    cg.secondary.addUnit(createDefaultUnit());
    roster.addCG(cg);
    expect(roster.totalTV(), equals(10),
        reason: 'check total tv equals both default units');
    expect(roster.getCG('test1'), isNotNull,
        reason: 'check retrieving the cg from the roster is valid');
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
