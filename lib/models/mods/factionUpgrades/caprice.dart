import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/caprice/caprice.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/model_type.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';

const _baseFactionModId = 'mod::faction::caprice';
const cyberneticUpgradesId = '$_baseFactionModId::10';

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
}
