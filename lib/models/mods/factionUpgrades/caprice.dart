import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/caprice/caprice.dart';
import 'package:gearforce/models/rules/caprice/cid.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/model_type.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';

const _baseFactionModId = 'mod::faction::caprice';
const cyberneticUpgradesId = '$_baseFactionModId::10';
const meleeSpecialistsId = '$_baseFactionModId::20';

class CapriceMods extends FactionModification {
  CapriceMods({
    required super.name,
    required super.id,
    required super.requirementCheck,
    super.options,
    super.onAdd,
    super.onRemove,
  }) : super();

  /*
    Each veteran universal infantry may add the following bonuses for 1 TV total;
    +1 Armor, +1 GU and the Climber trait.
  */
  factory CapriceMods.cyberneticUpgrades() {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      if (rs == null || !rs.isRuleEnabled(ruleCyberneticUpgrades.id)) {
        return false;
      }

      if ((u.faction == FactionType.Universal ||
              u.faction == FactionType.Universal_TerraNova ||
              u.faction == FactionType.Universal_Non_TerraNova) &&
          u.type == ModelType.Infantry) {
        return u.isVeteran;
      }

      return false;
    };

    final fm = CapriceMods(
      name: 'Cybernetic Upgrades',
      requirementCheck: reqCheck,
      id: cyberneticUpgradesId,
    );

    fm.addMod<int>(
      UnitAttribute.tv,
      createSimpleIntMod(1),
      description: 'TV: +1',
    );

    fm.addMod<int>(
      UnitAttribute.armor,
      createSimpleIntMod(1),
      description: '+1 Armor',
    );

    fm.addMod<int>(
      UnitAttribute.gunnery,
      createSimpleIntMod(-1),
      description: 'Improve Gu skill by 1',
    );

    fm.addMod<List<Trait>>(
      UnitAttribute.traits,
      createAddTraitToList(Trait.Climber()),
      description: '+Climber',
    );

    return fm;
  }

  /*
    Up to two models per combat group may take this upgrade if they have
    the Brawl:1 trait. Upgrade their Brawl:1 trait to Brawl:2 for 1 TV each.
  */
  factory CapriceMods.meleeSpecialists(Unit unit) {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      if (rs == null || !rs.isRuleEnabled(ruleMeleeSpecialists.id)) {
        return false;
      }

      final unitsWithMod =
          cg?.unitsWithMod(meleeSpecialistsId).where((unit) => unit != u);

      if (unitsWithMod != null && unitsWithMod.length > 1) {
        return false;
      }

      final hasBrawl1 = u.traits.any((t) => Trait.Brawl(1).isSame(t));
      if (hasBrawl1) {
        return true;
      }

      if (u.hasMod(meleeSpecialistsId)) {
        return true;
      }

      return false;
    };

    final fm = CapriceMods(
      name: 'Melee Specialists',
      requirementCheck: reqCheck,
      id: meleeSpecialistsId,
    );

    fm.addMod<int>(
      UnitAttribute.tv,
      createSimpleIntMod(1),
      description: 'TV: +1',
    );

    final brawl2 = Trait.Brawl(2);

    fm.addMod<List<Trait>>(UnitAttribute.traits, (value) {
      var newList = new List<Trait>.from(value);

      newList.removeWhere((t) => Trait.Brawl(1).isSame(t));

      if (!newList.any((t) => brawl2.isSame(t))) {
        newList.add(brawl2);
      }

      return newList;
    }, description: '-Brawl:1, +Brawl:2');

    return fm;
  }
}
