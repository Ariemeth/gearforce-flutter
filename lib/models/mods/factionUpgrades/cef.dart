import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/mods/modification_option.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/rulesets/cef/cef.dart';
import 'package:gearforce/models/rules/rulesets/cef/cefff.dart';
import 'package:gearforce/models/rules/rulesets/rule_set.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/model_type.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/weapons/weapon.dart';

const _baseFactionModId = 'mod::faction::cef';
const minveraId = '$_baseFactionModId::10';
const advancedInterfaceNetworkId = '$_baseFactionModId::20';
const valkyriesId = '$_baseFactionModId::30';
const dualLasersId = '$_baseFactionModId::40';
const ewDuelistsId = '$_baseFactionModId::50';

class CEFMods extends FactionModification {
  CEFMods({
    required super.name,
    required super.id,
    required super.requirementCheck,
    super.options,
    super.onAdd,
    super.onRemove,
  }) : super();

  /*
    CEF frames may choose to have a Minerva class GREL as a pilot for 1 TV each.
    This will improve the PI skill of that frame by one.
  */
  factory CEFMods.minerva() {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      if (cg == null) {
        return false;
      }
      final modOverride = rs?.modCheck(u, cg, modID: minveraId);
      if (modOverride != null) {
        return modOverride;
      }

      if (rs == null || !rs.isRuleEnabled(ruleMinerva.id)) {
        return false;
      }

      if (u.faction == FactionType.CEF && u.type == ModelType.Gear) {
        return true;
      }

      return false;
    };

    final fm = CEFMods(
      name: 'Minerva',
      requirementCheck: reqCheck,
      id: minveraId,
    );

    fm.addMod<int>(
      UnitAttribute.tv,
      createSimpleIntMod(1),
      description: 'TV: +1',
    );

    fm.addMod<int>(
      UnitAttribute.piloting,
      createSimpleIntMod(-1),
      description:
          'Improve PI skill by 1 by adding a Minerva class' + ' GREL pilot',
    );

    return fm;
  }

  ///  Each veteran [faction] frame may improve their GU skill by one for 1 TV times the
  ///  number of Actions that the model has.
  factory CEFMods.advancedInterfaceNetwork(Unit unit, FactionType faction) {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      if (cg == null) {
        return false;
      }
      final modOverride =
          rs?.modCheck(u, cg, modID: advancedInterfaceNetworkId);
      if (modOverride != null) {
        return modOverride;
      }

      if (rs == null || !rs.isRuleEnabled(ruleAdvancedInterfaceNetwork.id)) {
        return false;
      }

      // All frames are gears, cef has no striders, however caprice mounts are both
      // gears and striders.  If CEF gets a strider that isn't a frame or caprice
      // gets a strider or gear that isn't a mount then this will need to be updated.
      if (u.faction == faction &&
          (u.type == ModelType.Gear || u.type == ModelType.Strider) &&
          u.isVeteran) {
        return true;
      }

      return false;
    };

    final fm = CEFMods(
      name: 'Advanced Interface Network',
      requirementCheck: reqCheck,
      id: advancedInterfaceNetworkId,
    );

    final modCost = unit.actions ?? 0;

    fm.addMod<int>(
      UnitAttribute.tv,
      createSimpleIntMod(modCost),
      description: 'TV: +$modCost',
    );

    fm.addMod<int>(
      UnitAttribute.gunnery,
      createSimpleIntMod(-1),
      description: 'Improve GU skill by 1',
    );

    return fm;
  }

  /*
    Veteran frames in this force with 1 action may upgrade to 2 actions
    for +2 TV each.
  */
  factory CEFMods.valkyries() {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      if (rs == null || !rs.isRuleEnabled(ruleValkyries.id)) {
        return false;
      }

      if (u.type == ModelType.Gear &&
          u.isVeteran &&
          u.attribute<int>(UnitAttribute.actions, modIDToSkip: valkyriesId) ==
              1) {
        return true;
      }

      return false;
    };

    final fm = CEFMods(
      name: 'Valkyries',
      requirementCheck: reqCheck,
      id: valkyriesId,
    );

    fm.addMod<int>(
      UnitAttribute.tv,
      createSimpleIntMod(2),
      description: 'TV: +2',
    );

    fm.addMod<int>(
      UnitAttribute.actions,
      createSimpleIntMod(1),
      description: 'Actions: +1',
    );

    return fm;
  }

  /*
    Each duelist frame may purchase the ECM trait and the Sensors:36
    trait for 1 TV total.
  */
  factory CEFMods.ewDuelists() {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      if (rs == null || !rs.isRuleEnabled(ruleEWDuelists.id)) {
        return false;
      }

      if (u.isDuelist) {
        return true;
      }

      return false;
    };

    final fm = CEFMods(
      name: 'EW Duelists',
      requirementCheck: reqCheck,
      id: ewDuelistsId,
    );

    fm.addMod<int>(
      UnitAttribute.tv,
      createSimpleIntMod(1),
      description: 'TV: +1',
    );

    fm.addMod<List<Trait>>(
      UnitAttribute.traits,
      (value) {
        final newValue = Trait.ECM();
        var newList = new List<Trait>.from(value);

        if (!newList.any(
            (t) => t.isSameType(newValue) || t.isSameType(Trait.ECMPlus()))) {
          newList.add(newValue);
        }

        return newList;
      },
      description: '+ECM',
    );

    fm.addMod<List<Trait>>(
      UnitAttribute.traits,
      createAddOrReplaceSameTraitInList(Trait.Sensors(36)),
      description: '+Sensors:36',
    );

    return fm;
  }

  /*
      Dual Lasers: Duelist frames may select the Dual Guns veteran upgrade for
      laser cannons. Remove any TD or Shield traits when this upgrade is chosen.
  */
  factory CEFMods.dualLasers(Unit unit) {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      if (rs == null || !rs.isRuleEnabled(ruleDualLasers.id)) {
        return false;
      }

      if (!u.isDuelist) {
        return false;
      }

      if (u.reactWeapons.any((w) => !w.isCombo && w.code == 'LC')) {
        return true;
      }

      return false;
    };

    final List<ModificationOption> _options = [];

    final availableWeapons =
        unit.reactWeapons.where((w) => !w.isCombo && w.code == 'LC');

    availableWeapons.forEach((w) {
      _options.add(ModificationOption(w.toString()));
    });

    final modOptions = ModificationOption(
      'Dual Lasers',
      subOptions: _options,
      description: 'Add the Link Trait to one Laser Cannon',
    );

    final fm = CEFMods(
      name: 'Dual Lasers',
      requirementCheck: reqCheck,
      options: modOptions,
      id: dualLasersId,
    );

    fm.addMod<int>(
      UnitAttribute.tv,
      createSimpleIntMod(1),
      description: 'TV: +1',
    );

    fm.addMod<List<Weapon>>(UnitAttribute.weapons, (value) {
      final newList = value;

      if (modOptions.selectedOption != null &&
          newList.any((weapon) =>
              weapon.toString() == modOptions.selectedOption?.text)) {
        var existingWeapon = newList.firstWhere(
            (weapon) => weapon.toString() == modOptions.selectedOption?.text);
        existingWeapon.bonusTraits.add(Trait.Link());
      }
      return newList;
    }, description: 'Add the Link Trait to one Laser Cannon');

    final tds = unit.traits.where((t) => Trait.TD().isSameType(t)).toList();
    tds.forEach((t) {
      fm.addMod<List<Trait>>(
        UnitAttribute.traits,
        createRemoveTraitFromList(t),
      );
    });
    final shields =
        unit.traits.where((t) => Trait.Shield().isSameType(t)).toList();
    shields.forEach((t) {
      fm.addMod<List<Trait>>(
        UnitAttribute.traits,
        createRemoveTraitFromList(t),
      );
    });

    return fm;
  }
}
