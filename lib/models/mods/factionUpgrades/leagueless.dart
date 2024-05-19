import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/rulesets/leagueless/leagueless.dart';
import 'package:gearforce/models/rules/rulesets/rule_set.dart';
import 'package:gearforce/models/unit/model_type.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/weapons/weapon.dart';
import 'package:gearforce/models/weapons/weapons.dart';

const _baseFactionModId = 'mod::faction::leagueless';
const olRustyId = '$_baseFactionModId::10';
const discountsId = '$_baseFactionModId::20';
const localHeroId = '$_baseFactionModId::30';

class LeaguelessFactionMods extends FactionModification {
  LeaguelessFactionMods({
    required super.name,
    required super.id,
    required super.requirementCheck,
    super.options,
    super.onAdd,
    super.onRemove,
  }) : super();

  /*
    Reduce the cost of any gear or strider in one combat group by -1 TV each 
    (to a minimum of 2 TV). But their Hull (H) is reduced by -1 and their 
    Structure (S) is increased by +1. I.e., a H/S of 4/2 will become a 3/3.
  */
  factory LeaguelessFactionMods.olRusty() {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      if (u.type != ModelType.Gear && u.type != ModelType.Strider) {
        return false;
      }

      if (!ruleOlRusty.isEnabled) {
        return false;
      }

      final othersWithMod = ur
          ?.unitsWithMod(olRustyId)
          .where((unit) => cg != null && unit.combatGroup != cg);

      if (othersWithMod == null || othersWithMod.isEmpty) {
        return true;
      }
      return false;
    };

    final fm = LeaguelessFactionMods(
      name: 'Ol’ Rusty',
      requirementCheck: reqCheck,
      id: olRustyId,
    );

    fm.addMod<int>(
      UnitAttribute.tv,
      createSimpleIntMod(-1, minValue: 2),
      description: 'TV: -1',
    );
    fm.addMod<int>(
      UnitAttribute.hull,
      createSimpleIntMod(-1),
      description: 'S:-1',
    );
    fm.addMod<int>(
      UnitAttribute.structure,
      createSimpleIntMod(1),
      description: 'H:+1',
    );

    return fm;
  }

  /*
    Vehicles with an LLC may replace the LLC with a HAC for -1 TV each.
  */
  factory LeaguelessFactionMods.discounts(Unit unit) {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      if (u.type != ModelType.Vehicle) {
        return false;
      }

      if (!ruleDiscounts.isEnabled) {
        return false;
      }

      if (!u
          .attribute<List<Weapon>>(UnitAttribute.weapons,
              modIDToSkip: discountsId)
          .any((w) => w.abbreviation == 'LLC')) {
        return false;
      }

      return true;
    };

    final fm = LeaguelessFactionMods(
      name: 'Discounts',
      requirementCheck: reqCheck,
      id: discountsId,
    );

    if (!unit.weapons.any((w) => w.abbreviation == 'LLC')) {
      return fm;
    }
    final modelsLLC = unit.weapons.firstWhere((w) => w.abbreviation == 'LLC');
    final baseHAC = buildWeapon('HAC', hasReact: modelsLLC.hasReact);
    assert(baseHAC != null);
    if (baseHAC == null) {
      return fm;
    }
    final newHAC = Weapon.fromWeapon(baseHAC, addTraits: modelsLLC.bonusTraits);

    fm.addMod<int>(
      UnitAttribute.tv,
      createSimpleIntMod(-1),
      description: 'TV: -1',
    );
    fm.addMod<List<Weapon>>(
        UnitAttribute.weapons, createRemoveWeaponFromList(modelsLLC),
        description: '-${modelsLLC.abbreviation},');
    fm.addMod<List<Weapon>>(
        UnitAttribute.weapons, createAddWeaponToList(newHAC),
        description: '+${newHAC.abbreviation},');

    return fm;
  }

  /*
    For 1 TV, upgrade one infantry, cavalry or gear with the following ability: 
    Models with the Conscript trait that are in formation with this model are 
    considered to be in formation with a commander. This model also uses the
    Lead by Example duelist rule without being a duelist.
  */
  factory LeaguelessFactionMods.localHero() {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      if (!ruleLocalHero.isEnabled) {
        return false;
      }

      if (u.type != ModelType.Infantry &&
          u.type != ModelType.Cavalry &&
          u.type != ModelType.Gear) {
        return false;
      }

      if (ur == null) {
        return false;
      }

      if (ur.unitsWithMod(localHeroId).where((unit) => unit != u).isEmpty) {
        return true;
      }

      return false;
    };

    final fm = LeaguelessFactionMods(
      name: 'Local Hero',
      requirementCheck: reqCheck,
      id: localHeroId,
    );

    fm.addMod<int>(
      UnitAttribute.tv,
      createSimpleIntMod(1),
      description: 'TV: +1, Models with the Conscript trait that are in' +
          ' formation with this model are considered to be in formation with' +
          ' a commander. This model also uses the Lead by Example duelist' +
          ' rule without being a duelist.\n' +
          '> Once per round, whenever this unit damages an' +
          ' enemy model, give one SP to one model in formation with the' +
          ' Local Hero. \n' +
          '> This SP does not convert to a CP. If not used, this SP is' +
          ' removed during cleanup.',
    );

    return fm;
  }
}
