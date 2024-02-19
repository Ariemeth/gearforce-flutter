import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/mods/modification_option.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/mods/veteranUpgrades/veteran_modification.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/nucoal/hcsa.dart' as hcsa;
import 'package:gearforce/models/rules/nucoal/nsdf.dart' as nsdf;
import 'package:gearforce/models/rules/nucoal/pak.dart' as pak;
import 'package:gearforce/models/rules/nucoal/th.dart' as th;
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/command.dart';
import 'package:gearforce/models/unit/model_type.dart';
import 'package:gearforce/models/unit/movement.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';

const _baseFactionModId = 'mod::faction::nucoal';
const highSpeedLowDragId = '$_baseFactionModId::10';
const hoverTankCommanderId = '$_baseFactionModId::20';
const tankJockeysId = '$_baseFactionModId::30';
const somethingToProveId = '$_baseFactionModId::40';
const jannitePilotsId = '$_baseFactionModId::50';
const fastCavalryId = '$_baseFactionModId::60';
const ePexId = '$_baseFactionModId::70';
const highOctaneId = '$_baseFactionModId::80';
const personalEquipment1Id = '$_baseFactionModId::90';
const personalEquipment2Id = '$_baseFactionModId::100';

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
    Veteran gears may purchase the Agile trait for 1 TV each. Models with
    the Lumbering trait may not purchase this upgrade.
  */
  factory NuCoalFactionMods.highSpeedLowDrag() {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      if (u.type != ModelType.Gear) {
        return false;
      }

      if (rs == null || !rs.isRuleEnabled(nsdf.ruleHighSpeedLowDrag.id)) {
        return false;
      }

      if (u.traits.any((t) => t.isSameType(Trait.Lumbering()))) {
        return false;
      }

      return u.isVeteran;
    };

    final fm = NuCoalFactionMods(
      name: 'High Speed, Low Drag',
      requirementCheck: reqCheck,
      id: highSpeedLowDragId,
    );
    fm.addMod<int>(UnitAttribute.tv, createSimpleIntMod(1),
        description: 'TV: +1');

    fm.addMod<List<Trait>>(
      UnitAttribute.traits,
      createAddTraitToList(Trait.Agile()),
      description: 'Veteran gears may purchase the Agile trait for 1 TV each.' +
          ' Models with the Lumbering trait may not purchase this upgrade.',
    );

    return fm;
  }

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
  factory NuCoalFactionMods.somethingToProve({
    String name = 'Something To Prove',
    String? ruleId,
  }) {
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

      if (rs == null ||
          !rs.isRuleEnabled(ruleId ?? pak.ruleSomethingToProve.id)) {
        return false;
      }

      return true;
    };

    final fm = NuCoalFactionMods(
      name: name,
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

      if (rs == null || !rs.isRuleEnabled(hcsa.ruleFastCavalry.id)) {
        return false;
      }

      if (!cg!.isOptionEnabled(hcsa.ruleFortNeil.id)) {
        return false;
      }

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

  /*
    E-pex: One model in this combat group may improve its EW skill by one
    for 1 TV.
  */
  factory NuCoalFactionMods.e_pex() {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      if (rs == null || !rs.isRuleEnabled(hcsa.ruleEPex.id)) {
        return false;
      }

      if (!cg!.isOptionEnabled(hcsa.rulePrinceGable.id)) {
        return false;
      }

      return cg.modCount(ePexId) == 0 ||
          (cg.modCount(ePexId) == 1 && u.hasMod(ePexId));
    };
    return NuCoalFactionMods(
      name: 'E-pex',
      requirementCheck: reqCheck,
      id: ePexId,
    )
      ..addMod<int>(UnitAttribute.tv, createSimpleIntMod(1),
          description: 'TV: +1')
      ..addMod<int>(UnitAttribute.ew, createSimpleIntMod(-1),
          description: 'One model in this combat group may improve its EW' +
              ' skill by one for 1 TV.');
  }

  /*
    Add +1 to the MR of any veteran gears in this combat group for 1 TV each.
  */
  factory NuCoalFactionMods.highOctane() {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      if (rs == null || !rs.isRuleEnabled(hcsa.ruleHighOctane.id)) {
        return false;
      }

      if (!cg!.isOptionEnabled(hcsa.ruleErechAndNineveh.id)) {
        return false;
      }

      if (u.type != ModelType.Gear) {
        return false;
      }

      return u.isVeteran;
    };
    return NuCoalFactionMods(
      name: 'High Octane',
      requirementCheck: reqCheck,
      id: highOctaneId,
    )
      ..addMod<int>(UnitAttribute.tv, createSimpleIntMod(1),
          description: 'TV: +1')
      ..addMod<Movement>(UnitAttribute.movement, (currentMove) {
        final newMove =
            Movement(type: currentMove.type, rate: currentMove.rate + 1);
        return newMove;
      }, description: 'Add +1 to the MR of any veteran gears.');
  }

  /*
    Personal Equipment: Two models in this combat group may purchase two veteran upgrades
    each without being veterans.
    NOTE: The rulebook just lists this as a rule not an upgrade.  Making it a 
    faction mod to make it easier to check requirements
  */
  factory NuCoalFactionMods.personalEquipment(PersonalEquipment pe,
      {String? ruleId, String? optionId}) {
    final RequirementCheck reqCheck = (
      RuleSet? rs,
      UnitRoster? ur,
      CombatGroup? cg,
      Unit u,
    ) {
      assert(cg != null);
      assert(rs != null);
      if (rs == null ||
          !rs.isRuleEnabled(ruleId ?? hcsa.rulePersonalEquipment.id)) {
        return false;
      }

      if (optionId == null &&
          !cg!.isOptionEnabled(optionId ?? hcsa.ruleErechAndNineveh.id)) {
        return false;
      }

      if (cg == null) {
        return false;
      }
      final unitsWithMod = cg.units.where((unit) =>
          (unit.hasMod(personalEquipment1Id) ||
              unit.hasMod(personalEquipment2Id)) &&
          (unit != u));

      if (unitsWithMod.length < 2) {
        return true;
      }
      return false;
    };

    final modOptions = ModificationOption(
      'Personal Equipment',
      subOptions: VeteranModification.getAllVetModNames()
          .map((n) => ModificationOption(n))
          .toList(),
      description:
          'Select a Veteran upgrade that can be purchased even if this model isn\'t a veteran.',
    );

    final fm = NuCoalFactionMods(
      name: 'Personal Equipment',
      requirementCheck: reqCheck,
      options: modOptions,
      id: pe == PersonalEquipment.One
          ? personalEquipment1Id
          : personalEquipment2Id,
    );
    fm.addMod<int>(
      UnitAttribute.tv,
      createSimpleIntMod(0),
      description: 'Two models in this combat group may purchase two veteran' +
          ' upgrades each without being veterans.',
    );

    return fm;
  }
}

enum PersonalEquipment { One, Two }
