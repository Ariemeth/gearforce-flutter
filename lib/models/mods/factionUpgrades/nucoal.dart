import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/nucoal/pak.dart' as pak;
import 'package:gearforce/models/rules/nucoal/th.dart' as th;
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/command.dart';
import 'package:gearforce/models/unit/model_type.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';

const _factionModIdBase = 'mod::faction::nucoal';
const hoverTankCommanderId = '$_factionModIdBase::10';
const tankJockeysId = '$_factionModIdBase::20';
const somethingToProveId = '$_factionModIdBase::30';
const jannitePilotsId = '$_factionModIdBase::40';
const fastCavalryId = '$_factionModIdBase::50';

class NuCoalFactionMods extends FactionModification {
  NuCoalFactionMods({
    required super.name,
    required super.id,
    required super.requirementCheck,
    super.options,
    super.onAdd,
    super.onRemove,
  }) : super();

  /*
    Hover Tank Commander: Any commander that is in a vehicle type model may
    improve its EW skill by one, to a maximum of 3+, for 1 TV each.
  */
  factory NuCoalFactionMods.hoverTankCommander() {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      if (u.commandLevel == CommandLevel.none) {
        return false;
      }

      if (u.type != ModelType.Vehicle) {
        return false;
      }

      if (rs == null || !rs.isRuleEnabled(pak.ruleHoverTankCommander.id)) {
        return false;
      }

      return true;
    };

    final fm = NuCoalFactionMods(
      name: 'Hover Tank Commander',
      requirementCheck: reqCheck,
      id: hoverTankCommanderId,
    );
    fm.addMod<int>(UnitAttribute.tv, createSimpleIntMod(1),
        description: 'TV: +1');
    fm.addMod<int>(UnitAttribute.ew, createSimpleIntMod(-1, minValue: 3),
        description: 'Hover Tank Commander: Any commander that is in a' +
            ' vehicle type model may improve its EW skill by one, to a' +
            ' maximum of 3+, for 1 TV each.');

    return fm;
  }

  /*
    Tank Jockeys: Vehicles with the Agile trait may purchase the following 
    ability for 1 TV each: Ignore the movement penalty for traveling through
    difficult terrain.
  */
  factory NuCoalFactionMods.tankJockeys() {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      if (u.type != ModelType.Vehicle) {
        return false;
      }

      if (!u.traits.any((t) => t.name == Trait.Agile().name)) {
        return false;
      }

      if (rs == null || !rs.isRuleEnabled(pak.ruleTankJockeys.id)) {
        return false;
      }

      return true;
    };

    final fm = NuCoalFactionMods(
      name: 'Tank Jockeys',
      requirementCheck: reqCheck,
      id: tankJockeysId,
    );
    fm.addMod<int>(UnitAttribute.tv, createSimpleIntMod(1),
        description: 'TV: +1');

    const tankJockeyBenefit =
        'Ignore the movement penalty for traveling through difficult terrain.';
    fm.addMod<List<String>>(
        UnitAttribute.special, createAddStringToList(tankJockeyBenefit),
        description: 'Vehicles with the Agile trait may' +
            ' purchase the following ability for 1 TV each: Ignore the' +
            ' movement penalty for traveling through difficult terrain.');

    return fm;
  }

  /*
    Something to Prove: GREL infantry may increase their GU skill by one for 1
     TV each.
  */
  factory NuCoalFactionMods.somethingToProve() {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      if (u.type != ModelType.Infantry) {
        return false;
      }

      if (!u.core.frame.contains('GREL')) {
        return false;
      }

      if (rs == null || !rs.isRuleEnabled(pak.ruleSomethingToProve.id)) {
        return false;
      }

      return true;
    };

    final fm = NuCoalFactionMods(
      name: 'Something To Prove',
      requirementCheck: reqCheck,
      id: somethingToProveId,
    );
    fm.addMod<int>(UnitAttribute.tv, createSimpleIntMod(1),
        description: 'TV: +1');

    fm.addMod<int>(UnitAttribute.gunnery, createSimpleIntMod(-1),
        description: 'GREL infantry may increase their GU skill by one');

    return fm;
  }

  /*
    Veteran gears in this force with one action may upgrade to having two actions
    for +2 TV each.
  */
  factory NuCoalFactionMods.jannitePilots() {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      if (!u.isVeteran) {
        return false;
      }

      if (rs == null || !rs.isRuleEnabled(th.ruleJannitePilots.id)) {
        return false;
      }

      final currentActions =
          u.attribute<int>(UnitAttribute.actions, modIDToSkip: jannitePilotsId);

      return currentActions == 1;
    };

    final fm = NuCoalFactionMods(
      name: 'Jannite Pilots',
      requirementCheck: reqCheck,
      id: jannitePilotsId,
    );
    fm.addMod<int>(UnitAttribute.tv, createSimpleIntMod(2),
        description: 'TV: +2');

    fm.addMod<int>(
      UnitAttribute.actions,
      createSimpleIntMod(1),
      description: 'Veteran gears in this force with one action may upgrade' +
          ' to having two act',
    );

    return fm;
  }

  /*
    Sampsons in this combat group may purchase the Agile trait for 1 TV each.
  */
  factory NuCoalFactionMods.fastCavalry() {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      return u.core.frame == 'Sampson';
    };

    final fm = NuCoalFactionMods(
      name: 'Fast Cavalry',
      requirementCheck: reqCheck,
      id: fastCavalryId,
    );
    fm.addMod<int>(UnitAttribute.tv, createSimpleIntMod(1),
        description: 'TV: +1');

    fm.addMod<List<Trait>>(
      UnitAttribute.traits,
      createAddTraitToList(Trait.Agile()),
      description: 'Sampsons in this combat group may purchase the Agile' +
          ' trait for 1 TV each.',
    );

    return fm;
  }
}
