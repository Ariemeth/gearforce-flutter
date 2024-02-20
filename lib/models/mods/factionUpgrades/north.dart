import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/mods/modification_option.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/mods/veteranUpgrades/veteran_modification.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/north/nlc.dart';
import 'package:gearforce/models/rules/north/north.dart';
import 'package:gearforce/models/rules/north/umf.dart';
import 'package:gearforce/models/rules/north/wfp.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/command.dart';
import 'package:gearforce/models/unit/model_type.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/weapons/range.dart';
import 'package:gearforce/models/weapons/weapon.dart';
import 'package:gearforce/models/weapons/weapons.dart';

const _baseFactionModId = 'mod::faction::northern';
const taskBuiltID = '$_baseFactionModId::10';
const hammersOfTheNorthID = '$_baseFactionModId::20';
const olTrustyWFPID = '$_baseFactionModId::30';
const wellFundedID = '$_baseFactionModId::40';
const chaplainID = '$_baseFactionModId::50';
const warriorMonksID = '$_baseFactionModId::60';

class NorthernFactionMods extends FactionModification {
  NorthernFactionMods({
    required super.name,
    required super.id,
    required super.requirementCheck,
    super.options,
    super.onAdd,
    super.onRemove,
  }) : super();

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

      final isOtherAcceptable = u.core.frame == 'Bricklayer' ||
          u.core.frame == 'Engineering Grizzly' ||
          u.core.frame == 'Camel Truck' ||
          u.core.frame == 'Stinger';

      if (!(isNorthernGear || isOtherAcceptable)) {
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

      if (!ruleHammersOfTheNorth.isEnabled) {
        return false;
      }
      final snubCannons = u.weapons.where((w) => w.code == 'SC');
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

  /*
    Well Funded: Two models in each combat group may purchase one veteran
    upgrade without making them veterans.
    NOTE: The rulebook just list this as a rule not an upgrade.  Making it a 
    faction mod to make it easier to check requirements
  */
  factory NorthernFactionMods.wellFunded() {
    final RequirementCheck reqCheck = (
      RuleSet? rs,
      UnitRoster? ur,
      CombatGroup? cg,
      Unit u,
    ) {
      assert(cg != null);
      assert(rs != null);
      if (rs == null || !rs.isRuleEnabled(ruleWellFunded.id)) {
        return false;
      }

      final unitsWithMod =
          cg?.unitsWithMod(wellFundedID).where((unit) => unit != u);
      if (unitsWithMod == null || unitsWithMod.length < 2) {
        return true;
      }
      return false;
    };

    final modOptions = ModificationOption(
      'Well Funded',
      subOptions: VeteranModification.getAllVetModNames()
          .map((n) => ModificationOption(n))
          .toList(),
      description:
          'Select a Veteran upgrade that can be purchased even if this model isn\'t a veteran.',
    );

    final fm = NorthernFactionMods(
      name: 'Well Funded',
      requirementCheck: reqCheck,
      options: modOptions,
      id: wellFundedID,
    );
    fm.addMod<int>(
      UnitAttribute.tv,
      createSimpleIntMod(0),
      description: 'Model can purchase 1 vet upgrade without being a vet',
    );

    return fm;
  }

  /*
    You may select one non-commander gear to be a Battle Chaplain
    (BC) for 2 TV. The BC becomes an officer and can take the place as a third
    commander within a combat group. The BC comes with 1 CP and can use it to
    give orders to any model or combat group in the force. BCs will only be used
    to roll for initiative if there are no other commanders in the force. When
    there are no other commanders in the force, the BC will roll with a 5+ 
    initiative skill.
  */
  factory NorthernFactionMods.chaplain() {
    final RequirementCheck reqCheck = (
      RuleSet? rs,
      UnitRoster? ur,
      CombatGroup? cg,
      Unit u,
    ) {
      assert(cg != null);
      assert(rs != null);

      if (u.type != ModelType.Gear) {
        return false;
      }

      if (rs == null || !rs.isRuleEnabled(ruleChaplain.id)) {
        return false;
      }

      if (!(u.commandLevel == CommandLevel.none ||
          u.commandLevel == CommandLevel.bc)) {
        return false;
      }

      if (ur == null) {
        return false;
      }

      final otherUnitsWithMod =
          ur.unitsWithMod(chaplainID).where((unit) => unit != u);

      return otherUnitsWithMod.isEmpty;
    };

    final fm = NorthernFactionMods(
      name: 'Chaplain',
      requirementCheck: reqCheck,
      id: chaplainID,
      onAdd: (u) {
        if (u == null) {
          return;
        }
        u.commandLevel = CommandLevel.bc;
      },
      onRemove: (u) {
        if (u == null) {
          return;
        }
        u.commandLevel = CommandLevel.none;
      },
    );

    fm.addMod<int>(UnitAttribute.tv, createSimpleIntMod(2),
        description: 'TV: +2');
    // Not adding a cp here as all commanders get a cp automatically
    fm.addMod(UnitAttribute.cp, createSimpleIntMod(0),
        description: 'CP +1, Chaplains become third in command leaders');

    return fm;
  }

  /*
    Commanders and veterans, with the Hands trait, may purchase
    a fighting staff upgrade for 1 TV each. If a model takes this upgrade, then 
    it will also receive the Brawl:1 trait or increase its Brawl:X trait by one.
    A fighting staff is a MVB that has the React and Reach:2 traits.
  */
  factory NorthernFactionMods.warriorMonks(Unit unit) {
    final RequirementCheck reqCheck = (
      RuleSet? rs,
      UnitRoster? ur,
      CombatGroup? cg,
      Unit u,
    ) {
      assert(cg != null);
      assert(rs != null);

      if (rs == null || !rs.isRuleEnabled(ruleWarriorMonks.id)) {
        return false;
      }

      if (u.commandLevel == CommandLevel.none && !u.isVeteran) {
        return false;
      }
      if (!u.traits.contains(Trait.Hands())) {
        return false;
      }

      return true;
    };
    final mvb = buildWeapon('MVB', hasReact: true);
    assert(mvb != null);
    final fightingStaff = Weapon.fromWeapon(mvb!,
        name: 'Fighting Staff',
        addTraits: [Trait.Reach(2)],
        range: Range(0, 2, null, hasReach: true));

    final fm = NorthernFactionMods(
      name: 'Warrior Monks',
      requirementCheck: reqCheck,
      id: warriorMonksID,
    );

    fm.addMod<int>(UnitAttribute.tv, createSimpleIntMod(1),
        description: 'TV: +1');
    fm.addMod<List<Weapon>>(
        UnitAttribute.weapons, createAddWeaponToList(fightingStaff));
    fm.addMod<List<Trait>>(UnitAttribute.traits, (value) {
      var newList = new List<Trait>.from(value);

      var newBrawl = Trait.Brawl(1);
      if (newList.any((t) => newBrawl.name == t.name)) {
        final existingBrawl =
            newList.firstWhere((t) => newBrawl.name == t.name);
        newBrawl = Trait.fromTrait(existingBrawl,
            level: existingBrawl.level! + newBrawl.level!);
        newList.remove(existingBrawl);
      }

      newList.add(newBrawl);

      return newList;
    },
        description: 'Add Brawl:1 trait, or increase existing Brawl by 1 and' +
            ' add a fighting staff (MVB with React, Reach:2)');

    return fm;
  }
}
