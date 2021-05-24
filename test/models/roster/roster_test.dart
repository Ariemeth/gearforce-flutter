import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/roster/roster.dart';
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
    cg.primary.addUnit(Unit.test());
    cg.secondary.addUnit(Unit.test());
    roster.addCG(cg);
    expect(roster.totalTV(), equals(10),
        reason: 'check total tv equals both default units');
    expect(roster.getCG('test1'), isNotNull,
        reason: 'check retrieving the cg from the roster is valid');
  });
}

