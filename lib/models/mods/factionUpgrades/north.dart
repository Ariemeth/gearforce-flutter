import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/mods/modification_option.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/north/north.dart';
import 'package:gearforce/models/rules/north/wfp.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/model_type.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/weapons/weapon.dart';
import 'package:gearforce/models/weapons/weapons.dart';

const _northernIDBase = 'mod::faction::northern';
// TODO remove exampleID when finished with all northern factions
const exampleID = '000';
const taskBuiltID = '$_northernIDBase::10';
const hammersOfTheNorthID = '$_northernIDBase::20';
const olTrustyWFPID = '$_northernIDBase::30';

class NorthernFactionMods extends FactionModification {
  NorthernFactionMods({
    required String name,
    required RequirementCheck requirementCheck,
    ModificationOption? options,
    required String id,
  }) : super(
          name: name,
          requirementCheck: requirementCheck,
          options: options,
          id: id,
        );

  /*
    Example faction mod
    TODO Remove when finished with all northern factions
  */
  factory NorthernFactionMods.example(Unit unit) {
    final RequirementCheck reqCheck = (
      RuleSet? rs,
      UnitRoster? ur,
      CombatGroup? cg,
      Unit u,
    ) {
      assert(cg != null);
      assert(rs != null);

      return true;
    };

    final fm = NorthernFactionMods(
      name: 'Example',
      requirementCheck: reqCheck,
      id: exampleID,
    );

    return fm;
  }

  /*
    Task Built: Each Northern gear may swap its rocket pack for a Heavy 
    Machinegun (HMG) for 0 TV. Each Northern gear without a rocket pack may add
    an HMG for 1 TV. Each Bricklayer, Engineering Grizzly, Camel Truck and 
    Stinger may also add an HMG for 1 TV.
  */
  factory NorthernFactionMods.taskBuilt(Unit unit) {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      final isNorthernGear =
          u.faction == FactionType.North && u.type == ModelType.Gear;

      if (!(isNorthernGear ||
          u.core.name == 'Bricklayer' ||
          u.core.name == 'Engineering Grizzly' ||
          u.core.name == 'Camel Truck*' ||
          u.core.name == 'Stinger')) {
        return false;
      }

      if (rs == null || !rs.isRuleEnabled(ruleTaskBuilt.id)) {
        return false;
      }

      return true;
    };

    final swapHMG = unit.weapons.any((w) => w.code == 'RP');
    final cost = swapHMG ? 0 : 1;
    var hmg = buildWeapon('HMG');
    assert(hmg != null);

    final fm = NorthernFactionMods(
      name: 'Task Built',
      requirementCheck: reqCheck,
      id: taskBuiltID,
    );
    fm.addMod<int>(
      UnitAttribute.tv,
      createSimpleIntMod(cost),
      description: 'TV: +$cost',
    );

    if (swapHMG) {
      final modOptions = ModificationOption(
        'Task Built',
        subOptions: unit.weapons
            .where((w) => w.code == 'RP')
            .map((w) => ModificationOption(w.abbreviation))
            .toList(),
        description: 'Swap a RP for a HMG',
      );
      fm.options = modOptions;
      fm.addMod<List<Weapon>>(UnitAttribute.weapons, (value) {
        final newList =
            value.map((weapon) => Weapon.fromWeapon(weapon)).toList();

        // check if an option has been selected
        if (modOptions.selectedOption == null) {
          return newList;
        }

        // make sure the selected weapon is in the list
        final isInList = newList
            .any((w) => w.abbreviation == modOptions.selectedOption?.text);

        if (!isInList) {
          return newList;
        }

        final weaponToRemove = newList.firstWhere(
          (w) => w.abbreviation == modOptions.selectedOption?.text,
        );

        if (weaponToRemove.hasReact != hmg!.hasReact) {
          hmg = Weapon.fromWeapon(hmg!, hasReact: weaponToRemove.hasReact);
        }

        newList.remove(weaponToRemove);
        newList.add(hmg!);
        return newList;
      }, description: 'Swap a RP for a HMG');
    } else {
      fm.addMod<List<Weapon>>(
        UnitAttribute.weapons,
        createAddWeaponToList(hmg!),
        description: 'Add a HMG',
      );
    }

    return fm;
  }

  /*
    Hammers of the North: Snub cannons may be given the Precise trait for +1 TV each.
  */
  factory NorthernFactionMods.hammerOfTheNorth(Unit unit) {
    final RequirementCheck reqCheck = (
      RuleSet? rs,
      UnitRoster? ur,
      CombatGroup? cg,
      Unit u,
    ) {
      assert(cg != null);
      assert(rs != null);

      final snubCannons = u.weapons.where(
          (w) => w.code == 'SC' && !w.traits.any((t) => t.name == 'Precise'));
      if (snubCannons.isEmpty) {
        return false;
      }

      return true;
    };

    final modOptions = ModificationOption(
      'Hammers of the North',
      subOptions: unit.weapons
          .where((w) => w.code == 'SC')
          .map((w) => ModificationOption(w.abbreviation))
          .toList(),
      description: 'Select a Snub Cannon to have the Precise trait.',
    );

    final fm = NorthernFactionMods(
      name: 'Hammers of the North',
      requirementCheck: reqCheck,
      options: modOptions,
      id: hammersOfTheNorthID,
    );
    fm.addMod<int>(
      UnitAttribute.tv,
      createSimpleIntMod(1),
      description: 'TV: +1',
    );
    fm.addMod<List<Weapon>>(UnitAttribute.weapons, (value) {
      final newList = value.map((weapon) => Weapon.fromWeapon(weapon)).toList();

      // check if an option has been selected
      if (modOptions.selectedOption == null) {
        return newList;
      }

      // make sure the selected weapon is in the list
      final isInList =
          newList.any((w) => w.abbreviation == modOptions.selectedOption?.text);

      if (!isInList) {
        return newList;
      }

      final weaponToRemove = newList.firstWhere(
        (w) => w.abbreviation == modOptions.selectedOption?.text,
      );

      newList.remove(weaponToRemove);
      newList.add(Weapon.fromWeapon(weaponToRemove,
          addTraits: [Trait(name: 'Precise')]));
      return newList;
    }, description: 'Add Precise to a Snub Cannon');

    return fm;
  }

  /*
    Ol’ Trusty: Hunters, Ferrets, Weasels, Wildcats and Bobcats may improve their
    GU skill by one for 1 TV each. This does not include Hunter XMGs.
  */
  factory NorthernFactionMods.olTrustyWFP() {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(rs != null);

      if (rs == null || !rs.isRuleEnabled(ruleOlTrustyWFP.id)) {
        return false;
      }
      final frameName = u.core.frame;
      return (frameName.toLowerCase().contains('hunter') &&
              !frameName.contains('XMG')) ||
          frameName == 'Ferret' ||
          frameName == 'Weasel' ||
          frameName == 'Wildcat' ||
          frameName == 'Bobcat';
    };
    return NorthernFactionMods(
      name: 'Ol’ Trusty',
      requirementCheck: reqCheck,
      id: olTrustyWFPID,
    )
      ..addMod<int>(UnitAttribute.tv, createSimpleIntMod(1),
          description: 'TV: +1')
      ..addMod<int>(
        UnitAttribute.gunnery,
        createSimpleIntMod(-1),
        description: 'Hunters, Ferrets, Weasels, Wildcats and Bobcats may' +
            ' improve their GU skill by one for 1 TV each. This does not' +
            ' include Hunter XMGs.',
      );
  }
}
