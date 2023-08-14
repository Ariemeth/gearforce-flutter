import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/mods/modification_option.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/mods/veteranUpgrades/veteran_modification.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/eden/aef.dart';
import 'package:gearforce/models/rules/eden/eden.dart';
import 'package:gearforce/models/rules/eden/eif.dart';
import 'package:gearforce/models/rules/eden/enh.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/command.dart';
import 'package:gearforce/models/unit/model_type.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/weapons/range.dart';
import 'package:gearforce/models/weapons/weapon.dart';
import 'package:gearforce/models/weapons/weapon_modes.dart';
import 'package:gearforce/models/weapons/weapons.dart';

const _baseFactionModId = 'mod::faction::eden';
const lancersId = '$_baseFactionModId::10';
const wellSupportedId = '$_baseFactionModId::20';
const isharaId = '$_baseFactionModId::30';
const expertMarksmenId = '$_baseFactionModId::40';
const waterBornId = '$_baseFactionModId::50';
const freebladeId = '$_baseFactionModId::60';

class EdenMods extends FactionModification {
  EdenMods({
    required super.name,
    required super.id,
    required super.requirementCheck,
    super.options,
    super.onAdd,
    super.onRemove,
  }) : super();

  /*
    Golems may have their melee weapon upgraded to a lance for +2 TV each. The
    lance is an MSG (React, Reach:2). Models with a lance gain the Brawl:2
     trait or add +2 to their existing Brawl:X trait if they have it.
  */
  factory EdenMods.lancers(Unit unit) {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      if (rs == null || !rs.isRuleEnabled(ruleLancers.id)) {
        return false;
      }

      if (!(u.faction == FactionType.Eden && u.type == ModelType.Gear)) {
        return false;
      }

      if (u.weapons.any((w) => w.modes.any((m) => m == weaponModes.Melee))) {
        return true;
      }

      return false;
    };

    final fm = EdenMods(
      name: 'Lancers',
      requirementCheck: reqCheck,
      id: lancersId,
    );

    fm.addMod<int>(
      UnitAttribute.tv,
      createSimpleIntMod(2),
      description: 'TV: +2',
    );

    final msg = buildWeapon('MSG', hasReact: true);
    assert(msg != null);
    final lance = Weapon.fromWeapon(
      msg!,
      name: 'Lance',
      addTraits: [Trait.Reach(2)],
    );

    fm.addMod<List<Weapon>>(
      UnitAttribute.weapons,
      (value) {
        var newList = new List<Weapon>.from(value);

        var index = newList
            .indexWhere((w) => w.modes.any((m) => m == weaponModes.Melee));

        if (index < 0) {
          print(
              'melee weapon was not found in list of weapons ${value.toString()}');
          return value;
        }

        newList.removeAt(index);

        if (!newList.any((w) => w == lance)) {
          newList.add(lance);
        }

        return newList;
      },
      description: '+Lance - MSG (React, Reach:2)',
    );

    final existingBrawls = unit
        .attribute<List<Trait>>(UnitAttribute.traits, modIDToSkip: lancersId)
        .where((t) => Trait.Brawl(1).isSameType(t))
        .toList();

    if (existingBrawls.isEmpty) {
      fm.addMod<List<Trait>>(
        UnitAttribute.traits,
        createAddTraitToList(Trait.Brawl(2)),
        description: '+Brawl:2',
      );
    } else {
      final existingBrawl = existingBrawls.first;
      final newBrawl =
          Trait.fromTrait(existingBrawl, level: existingBrawl.level! + 2);
      fm.addMod<List<Trait>>(
        UnitAttribute.traits,
        createReplaceTraitInList(oldValue: existingBrawl, newValue: newBrawl),
        description: '-Brawl:${existingBrawl.level}+Brawl:${newBrawl.level}',
      );
    }

    return fm;
  }

  /*
    Well Supported: One model per combat group may select one veteran upgrade
    without being a veteran.
    NOTE: The rulebook just list this as a rule not an upgrade.  Making it a 
    faction mod to make it easier to check requirements
  */
  factory EdenMods.wellSupported() {
    final RequirementCheck reqCheck = (
      RuleSet? rs,
      UnitRoster? ur,
      CombatGroup? cg,
      Unit u,
    ) {
      assert(cg != null);
      assert(rs != null);
      if (rs == null || !rs.isRuleEnabled(ruleWellSupported.id)) {
        return false;
      }

      final unitsWithMod =
          cg?.unitsWithMod(wellSupportedId).where((unit) => unit != u);
      if (unitsWithMod == null || unitsWithMod.isEmpty) {
        return true;
      }
      return false;
    };

    final modOptions = ModificationOption(
      'Well Supported',
      subOptions: VeteranModification.getAllVetModNames()
          .map((n) => ModificationOption(n))
          .toList(),
      description: 'Select a Veteran upgrade that can be purchased even if' +
          ' this model isn\'t a veteran.',
    );

    final fm = EdenMods(
      name: 'Well Supported',
      requirementCheck: reqCheck,
      options: modOptions,
      id: wellSupportedId,
    );
    fm.addMod<int>(
      UnitAttribute.tv,
      createSimpleIntMod(0),
      description: 'Model can purchase 1 vet upgrade without being a vet',
    );

    return fm;
  }

  /*
    Golems may have their melee weapon upgraded to a halberd for +1 TV each.
    The halberd is a MVB (React, Reach:1). Models with a halberd gain the
    Brawl:1 trait or add +1 to their existing Brawl:X trait if they have it.
  */
  factory EdenMods.ishara(Unit unit) {
    final RequirementCheck reqCheck = (
      RuleSet? rs,
      UnitRoster? ur,
      CombatGroup? cg,
      Unit u,
    ) {
      assert(cg != null);
      assert(rs != null);

      if (rs == null || !rs.isRuleEnabled(ruleIshara.id)) {
        return false;
      }

      if (u.type == ModelType.Gear && u.faction == FactionType.Eden) {
        return true;
      }

      return false;
    };
    final mvb = buildWeapon('MVB', hasReact: true);
    assert(mvb != null);
    final halberd = Weapon.fromWeapon(mvb!,
        name: 'Halberd',
        addTraits: [Trait.Reach(2)],
        range: Range(0, 2, null, hasReach: true));

    final fm = EdenMods(
      name: 'Ishara',
      requirementCheck: reqCheck,
      id: isharaId,
    );

    fm.addMod<int>(UnitAttribute.tv, createSimpleIntMod(1),
        description: 'TV: +1');

    fm.addMod<List<Weapon>>(UnitAttribute.weapons, (value) {
      var newList = new List<Weapon>.from(value);

      var index =
          newList.indexWhere((w) => w.modes.any((m) => m == weaponModes.Melee));
      if (index >= 0) {
        newList.removeAt(index);
      }
      if (!newList.contains(halberd)) {
        newList.insert(index >= 0 ? index : 0, halberd);
      }

      return newList;
    });

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
        description: 'Golems may have their melee weapon upgraded to a' +
            ' halberd (MVB with React, Reach:2). Add Brawl:1 trait, or' +
            ' increase existing Brawl by 1');

    return fm;
  }

  /*
    Each golem with a rifle may increase their GU skill by one for 1 TV.
  */
  factory EdenMods.expertMarksmen() {
    final RequirementCheck reqCheck = (
      RuleSet? rs,
      UnitRoster? ur,
      CombatGroup? cg,
      Unit u,
    ) {
      assert(cg != null);
      assert(rs != null);
      if (rs == null || !rs.isRuleEnabled(ruleExpertMarksmen.id)) {
        return false;
      }

      if (u.faction != FactionType.Eden || u.type != ModelType.Gear) {
        return false;
      }

      if (u.weapons.any((w) => w.code == 'RF')) {
        return true;
      }

      return false;
    };

    final fm = EdenMods(
      name: 'Expert Marksmen',
      requirementCheck: reqCheck,
      id: expertMarksmenId,
    );
    fm.addMod<int>(
      UnitAttribute.tv,
      createSimpleIntMod(1),
      description: 'TV: +1',
    );

    fm.addMod<int>(
      UnitAttribute.gunnery,
      createSimpleIntMod(-1),
      description: 'Each golem with a rifle may increase their GU skill by one',
    );

    return fm;
  }

  /*
    Constable and Man at Arm Golems may take the Conscript trait for -1 TV.
    Commanders, veterans and duelists may not take this upgrade.
  */
  factory EdenMods.freeblade() {
    final RequirementCheck reqCheck = (
      RuleSet? rs,
      UnitRoster? ur,
      CombatGroup? cg,
      Unit u,
    ) {
      assert(cg != null);
      assert(rs != null);
      if (rs == null || !rs.isRuleEnabled(ruleFreeblade.id)) {
        return false;
      }

      if (u.type != ModelType.Gear) {
        return false;
      }

      if (!(u.core.frame == 'Constable' || u.core.frame == 'Man at Arms')) {
        return false;
      }

      if (u.commandLevel != CommandLevel.none) {
        return false;
      }

      if (u.isVeteran || u.isDuelist) {
        return false;
      }

      return true;
    };

    final fm = EdenMods(
      name: 'Freeblade',
      requirementCheck: reqCheck,
      id: freebladeId,
    );
    fm.addMod<int>(
      UnitAttribute.tv,
      createSimpleIntMod(-1),
      description: 'TV: -1',
    );

    fm.addMod<List<Trait>>(
      UnitAttribute.traits,
      createAddTraitToList(Trait.Conscript()),
      description: '+Conscript',
    );

    return fm;
  }

  /*
    Infantry that receive the Frogmen upgrade also receive a GU of 3+.
  */
  factory EdenMods.waterBorn() {
    final RequirementCheck reqCheck = (
      RuleSet? rs,
      UnitRoster? ur,
      CombatGroup? cg,
      Unit u,
    ) {
      assert(cg != null);
      assert(rs != null);
      if (rs == null || !rs.isRuleEnabled(ruleWaterBorn.id)) {
        return false;
      }

      if (u.type != ModelType.Infantry) {
        return false;
      }

      return true;
    };

    final fm = EdenMods(
      name: 'Water-Born',
      requirementCheck: reqCheck,
      id: waterBornId,
    );

    fm.addMod<int>(
      UnitAttribute.gunnery,
      createSetIntMod(3),
    );

    return fm;
  }
}
