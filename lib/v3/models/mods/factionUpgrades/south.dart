import 'package:gearforce/v3/models/combatGroups/combat_group.dart';
import 'package:gearforce/v3/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/v3/models/mods/modification_option.dart';
import 'package:gearforce/v3/models/mods/mods.dart';
import 'package:gearforce/v3/models/roster/roster.dart';
import 'package:gearforce/v3/models/rules/rule_types.dart';
import 'package:gearforce/v3/models/rules/rulesets/rule_set.dart';
import 'package:gearforce/v3/models/rules/rulesets/south/md.dart' as md;
import 'package:gearforce/v3/models/rules/rulesets/south/milicia.dart'
    as milicia;
import 'package:gearforce/v3/models/rules/rulesets/south/south.dart';
import 'package:gearforce/v3/models/rules/rulesets/south/sra.dart' as sra;
import 'package:gearforce/v3/models/traits/trait.dart';
import 'package:gearforce/v3/models/unit/command.dart';
import 'package:gearforce/v3/models/unit/unit.dart';
import 'package:gearforce/v3/models/unit/unit_attribute.dart';
import 'package:gearforce/v3/models/weapons/weapon.dart';
import 'package:gearforce/v3/models/weapons/weapons.dart';

const _baseFactionModId = 'mod::faction::southern';
const prideOfTheSouthId = '$_baseFactionModId::10';
const politicalOfficerId = '$_baseFactionModId::20';
const conscriptionId = '$_baseFactionModId::30';
const samuraiSpiritId = '$_baseFactionModId::40';
const metsukeId = '$_baseFactionModId::50';
const lionHuntersId = '$_baseFactionModId::60';

class SouthernFactionMods extends FactionModification {
  SouthernFactionMods({
    required super.name,
    required super.id,
    required super.requirementCheck,
    super.options,
    super.onAdd,
    super.onRemove,
    super.ruleType = RuleType.standard,
  }) : super();

  /*
  Pride of the South: Commanders and veterans, with the Hands trait, may
  purchase the vibro-rapier upgrade for 1 TV each. If a model takes this upgrade,
  it will also receive the Brawl:1 trait or increase its Brawl:X trait by one. A vibrorapier
  is a LVB (React, Precise).
  */
  factory SouthernFactionMods.prideOfTheSouth(Unit unit) {
    reqCheck(
      RuleSet? rs,
      UnitRoster? ur,
      CombatGroup? cg,
      Unit u,
    ) {
      assert(cg != null);
      assert(rs != null);

      if (rs == null || !rs.isRuleEnabled(sra.rulePrideOfTheSouth.id)) {
        return false;
      }

      if (u.commandLevel == CommandLevel.none && !u.isVeteran) {
        return false;
      }
      if (!u.traits.contains(Trait.hands())) {
        return false;
      }

      return true;
    }

    final lvb = buildWeapon('LVB', hasReact: true);
    assert(lvb != null);
    final vibroRapier = Weapon.fromWeapon(
      lvb!,
      name: 'Vibro Rapier',
      addTraits: [Trait.precise()],
    );

    final fm = SouthernFactionMods(
      name: 'Pride of the South',
      requirementCheck: reqCheck,
      id: prideOfTheSouthId,
    );

    fm.addMod<int>(UnitAttribute.tv, createSimpleIntMod(1),
        description: 'TV: +1');
    fm.addMod<List<Weapon>>(
        UnitAttribute.weapons, createAddWeaponToList(vibroRapier));
    fm.addMod<List<Trait>>(UnitAttribute.traits, (value) {
      var newList = List<Trait>.from(value);

      var newBrawl = Trait.brawl(1);
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
            ' add a vibro-rapier (LVB with React, Precise)');

    return fm;
  }

/*
  Political Officer: You may select one non-commander to be a Political Officer
  (PO) for 2 TV. The PO becomes an officer and can take the place as a third
  commander within a combat group. The PO comes with 1 CP and can use it to
  give orders to any model or combat group in the force. POs will only be used
  to roll for initiative if there are no other commanders in the force. When there
  are no other commanders in the force, the PO will roll with a 5+ initiative skill.
  */
  factory SouthernFactionMods.politicalOfficer() {
    reqCheck(
      RuleSet? rs,
      UnitRoster? ur,
      CombatGroup? cg,
      Unit u,
    ) {
      assert(cg != null);
      assert(rs != null);

      if (rs == null || !rs.isRuleEnabled(sra.rulePoliticalOfficer.id)) {
        return false;
      }

      if (!(u.commandLevel == CommandLevel.none ||
          u.commandLevel == CommandLevel.po)) {
        return false;
      }

      if (ur == null) {
        return false;
      }

      final otherUnitsWithMod =
          ur.unitsWithMod(politicalOfficerId).where((unit) => unit != u);

      return otherUnitsWithMod.isEmpty;
    }

    final fm = SouthernFactionMods(
      name: 'Political Officer',
      requirementCheck: reqCheck,
      id: politicalOfficerId,
      onAdd: (u) {
        if (u == null) {
          return;
        }
        u.commandLevel = CommandLevel.po;
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
        description:
            'CP +1, Political Officers become third in command leaders');

    return fm;
  }
/*
  Conscription: You may add the Conscript trait to any non-commander,
  non-veteran and non-duelist in the force if they do not already possess the trait.
  Reduce the TV of these models by 1 TV per action.
*/
  factory SouthernFactionMods.conscription(Unit unit) {
    reqCheck(
      RuleSet? rs,
      UnitRoster? ur,
      CombatGroup? cg,
      Unit u,
    ) {
      assert(cg != null);
      assert(rs != null);

      if (rs == null || !rs.isRuleEnabled(milicia.ruleConscription.id)) {
        return false;
      }

      if (u.isDuelist || u.isVeteran || u.commandLevel != CommandLevel.none) {
        return false;
      }

      if ((u.traits.any((t) => t.name == Trait.conscript().name)) &&
          !u.hasMod(conscriptionId)) {
        return false;
      }

      return true;
    }

    final fm = SouthernFactionMods(
      name: 'Conscription',
      requirementCheck: reqCheck,
      id: conscriptionId,
    );

    final int cost = -1 *
        unit.attribute(
          UnitAttribute.actions,
          modIDToSkip: conscriptionId,
        );

    fm.addMod<int>(UnitAttribute.tv, createSimpleIntMod(cost),
        description: 'TV: $cost');
    fm.addMod<List<Trait>>(
        UnitAttribute.traits, createAddTraitToList(Trait.conscript()),
        description: 'Adds the Conscript Trait');

    return fm;
  }

/*
  Samurai Spirit: Commanders and veterans, with the Hands trait, may purchase
  the vibro-katana upgrade for 1 TV each. If a model takes this upgrade, it will also
  receive the Brawl:1 trait or increase its Brawl:X trait by one. A vibro-katana is a
  LVB (React, Precise).
  */
  factory SouthernFactionMods.samuraiSpirit(Unit unit) {
    reqCheck(
      RuleSet? rs,
      UnitRoster? ur,
      CombatGroup? cg,
      Unit u,
    ) {
      assert(cg != null);
      assert(rs != null);

      if (rs == null || !rs.isRuleEnabled(md.ruleSamuraiSpirit.id)) {
        return false;
      }

      if (u.commandLevel == CommandLevel.none && !u.isVeteran) {
        return false;
      }
      if (!u.traits.contains(Trait.hands())) {
        return false;
      }

      return true;
    }

    final lvb = buildWeapon('LVB', hasReact: true);
    assert(lvb != null);
    final vibroKatana = Weapon.fromWeapon(
      lvb!,
      name: 'Vibro Katana',
      addTraits: [Trait.precise()],
    );

    final fm = SouthernFactionMods(
      name: 'Samurai Spirit',
      requirementCheck: reqCheck,
      id: samuraiSpiritId,
    );

    fm.addMod<int>(UnitAttribute.tv, createSimpleIntMod(1),
        description: 'TV: +1');
    fm.addMod<List<Weapon>>(
        UnitAttribute.weapons, createAddWeaponToList(vibroKatana));
    fm.addMod<List<Trait>>(UnitAttribute.traits, (value) {
      var newList = List<Trait>.from(value);

      var newBrawl = Trait.brawl(1);
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
            ' add a vibro-katana (LVB with React, Precise)');

    return fm;
  }

  /*
  MP models within one combat group may purchase the Shield+ trait
  for 1 TV each. The Shield+ trait works just like a Shield trait but also adds +1D6
  to defensive rolls from attacks originating from the front arc. The Shield+ trait
  may not be stacked with cover modifiers.
*/
  factory SouthernFactionMods.metsuke(Unit unit) {
    reqCheck(
      RuleSet? rs,
      UnitRoster? ur,
      CombatGroup? cg,
      Unit u,
    ) {
      assert(cg != null);
      assert(rs != null);

      if (rs == null || !rs.isRuleEnabled(md.ruleMetsuke.id)) {
        return false;
      }

      if (ur == null) {
        return false;
      }

      if (!u.core.frame.contains('MP')) {
        return false;
      }

      final unitsWithMod = ur
          .unitsWithMod(metsukeId)
          .where((unit) => unit.group?.combatGroup != cg);
      if (unitsWithMod.isEmpty) {
        return true;
      }

      return false;
    }

    final fm = SouthernFactionMods(
      name: 'Metsuke',
      requirementCheck: reqCheck,
      id: metsukeId,
    );

    fm.addMod<int>(UnitAttribute.tv, createSimpleIntMod(1),
        description: 'TV: +1');
    fm.addMod<List<Trait>>(
        UnitAttribute.traits,
        createAddTraitToList(
          Trait.shieldPlus(),
        ),
        description: 'Adds the Shield+ Trait');
    if (unit.traits.any((t) => t.name == Trait.shield().name)) {
      final traitToRemove =
          unit.traits.firstWhere((t) => t.name == Trait.shield().name);
      fm.addMod<List<Trait>>(
        UnitAttribute.traits,
        createRemoveTraitFromList(traitToRemove),
      );
    }
    return fm;
  }

  /*
     Lion Hunters: Bazookas may be given the Precise+ trait for +1 TV each.
  */
  factory SouthernFactionMods.lionHunters(Unit unit) {
    reqCheck(
      RuleSet rs,
      UnitRoster? ur,
      CombatGroup? cg,
      Unit u,
    ) {
      assert(cg != null);

      if (!rs.settings.isAlphaBetaAllowed) {
        return false;
      }

      if (!ruleLionHunters.isEnabled) {
        return false;
      }

      final bazookas = u.weapons.where((w) => w.code == 'BZ');
      if (bazookas.isEmpty) {
        return false;
      }

      return true;
    }

    final modOptions = ModificationOption(
      'Lion Hunters',
      subOptions: unit.weapons
          .where((w) => w.code == 'BZ')
          .map((w) => ModificationOption(w.abbreviation))
          .toList(),
      description: 'Select a Bazooka to have the Precise+ trait.',
    );

    final fm = SouthernFactionMods(
      name: 'Lion Hunters',
      requirementCheck: reqCheck,
      options: modOptions,
      id: lionHuntersId,
      ruleType: RuleType.alphaBeta,
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
      newList.add(
          Weapon.fromWeapon(weaponToRemove, addTraits: [Trait.precisePlus()]));
      return newList;
    }, description: 'Add Precise+ to a Bazooka');

    return fm;
  }
}
