import 'package:flutter_test/flutter_test.dart';
import 'package:gearforce/v3/data/data.dart';
import 'package:gearforce/v3/models/combatGroups/combat_group.dart';
import 'package:gearforce/v3/models/roster/roster.dart';
import 'package:gearforce/v3/models/unit/command.dart';
import 'package:gearforce/v3/models/unit/unit.dart';
import 'package:gearforce/v3/models/unit/unit_core.dart';
import 'package:gearforce/widgets/settings.dart';

void main() {
  setUpAll(() async {
    // Data class uses the rootBundle, therefore the the flutterbindings need to
    // be initialized before testing.
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  test('create default CombatGroup', () {
    final settings = Settings();
    final data = DataV3()..load(settings);
    final roster = UnitRoster(data, settings);
    expect(roster.getCGs().length, equals(1),
        reason: 'check cg length to ensure proper construction');
  });

  test('get default cg', () {
    final settings = Settings();
    final data = DataV3()..load(settings);
    final roster = UnitRoster(data, settings);
    final cg = roster.getCG('CG 1');
    expect(cg!.name, equals('CG 1'), reason: 'check cg default name');
    expect(cg.primary.allUnits().length, equals(0),
        reason: 'should be no primary units');
    expect(cg.secondary.allUnits().length, equals(0),
        reason: 'should be no secondary units');
  });

  test('add new cg', () {
    final settings = Settings();
    final data = DataV3()..load(settings);
    final roster = UnitRoster(data, settings);
    final cg = CombatGroup('test1');
    cg.primary.addUnit(Unit(core: UnitCore.test()));
    cg.secondary.addUnit(Unit(core: UnitCore.test()));
    roster.addCG(cg);
    expect(roster.totalTV(), equals(10),
        reason: 'check total tv equals both default units');
    expect(roster.getCG('test1'), isNotNull,
        reason: 'check retrieving the cg from the roster is valid');
  });

  test('check default active cg', () {
    final settings = Settings();
    final data = DataV3()..load(settings);
    final roster = UnitRoster(data, settings);
    expect(roster.activeCG(), isNotNull,
        reason: 'active cg should not be null');
    expect(roster.activeCG()!.name, equals('CG 1'),
        reason: 'active cg should not be null');
  });

  test('Single CGL picked up as only available leader', () async {
    final settings = Settings();
    final data = await DataV3()
      ..load(settings);
    final roster = UnitRoster(data, settings);
    expect(roster.getLeaders(null).length, 0);

    final unit = Unit(
        core: UnitCore.test(faction: roster.factionNotifier.value.factionType));

    roster.getCGs().firstOrNull?.primary.addUnit(unit);
    unit.commandLevel = CommandLevel.cgl;

    expect(roster.getLeaders(null).length, 1);
  });

  test('CO picked up as only available force leader with 2 leaders in roster',
      () async {
    final settings = Settings();
    final data = await DataV3()
      ..load(settings);
    final roster = UnitRoster(data, settings);
    expect(roster.getLeaders(null).length, 0);

    final unit = Unit(
        core: UnitCore.test(faction: roster.factionNotifier.value.factionType));
    final unit2 = Unit(
        core: UnitCore.test(faction: roster.factionNotifier.value.factionType));

    final cg = roster.getCGs().firstOrNull;
    expect(cg, isNotNull, reason: 'CG should not be null');

    cg!.primary.addUnit(unit);
    cg.primary.addUnit(unit2);

    unit.commandLevel = CommandLevel.co;
    unit2.commandLevel = CommandLevel.secic;

    expect(roster.getLeaders(null).length, 2, reason: 'Should be 2 leaders');
    expect(roster.availableForceLeaders().length, 1,
        reason: 'Should only be 1 available Force Leader');
    expect(roster.availableForceLeaders().first, equals(unit),
        reason: 'Should be the first unit');
    expect(roster.availableForceLeaders().first.commandLevel,
        equals(CommandLevel.co),
        reason: 'Force Leader should be the co');
  });
}
