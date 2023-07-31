import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/rules/south/sra.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/command.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/weapons/weapon.dart';
import 'package:gearforce/models/weapons/weapons.dart';

const _southernIDBase = 'mod::faction::southern';
const prideOfTheSouthId = '$_southernIDBase::10';
const politicalOfficerId = '$_southernIDBase::20';

class SouthernFactionMods extends FactionModification {
  SouthernFactionMods({
    required super.name,
    required super.id,
    required super.requirementCheck,
    super.options,
    super.onAdd,
    super.onRemove,
  }) : super();

  /*
  Pride of the South: Commanders and veterans, with the Hands trait, may
  purchase the vibro-rapier upgrade for 1 TV each. If a model takes this upgrade,
  it will also receive the Brawl:1 trait or increase its Brawl:X trait by one. A vibrorapier
  is a LVB (React, Precise).
  */
  factory SouthernFactionMods.prideOfTheSouth(Unit unit) {
    final RequirementCheck reqCheck = (
      RuleSet? rs,
      UnitRoster? ur,
      CombatGroup? cg,
      Unit u,
    ) {
      assert(cg != null);
      assert(rs != null);

      if (rs == null || !rs.isRuleEnabled(rulePrideOfTheSouth.id)) {
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

    final mvb = buildWeapon('LVB', hasReact: true);
    assert(mvb != null);
    final vibroRapier = Weapon.fromWeapon(
      mvb!,
      name: 'Vibro Rapier',
      addTraits: [Trait.Precise()],
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
    final RequirementCheck reqCheck = (
      RuleSet? rs,
      UnitRoster? ur,
      CombatGroup? cg,
      Unit u,
    ) {
      assert(cg != null);
      assert(rs != null);

      if (rs == null || !rs.isRuleEnabled(rulePoliticalOfficer.id)) {
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
    };

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
    fm.addMod(UnitAttribute.cp, createSimpleIntMod(1),
        description:
            'CP +1, Political Officers become third in command leaders');

    return fm;
  }
}
