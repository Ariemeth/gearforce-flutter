import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/factions/faction_rule.dart';
import 'package:gearforce/models/mods/factionUpgrades/peace_river.dart';
import 'package:gearforce/models/mods/veteranUpgrades/veteran_modification.dart';
import 'package:gearforce/models/rules/options/combat_group_options.dart';
import 'package:gearforce/models/rules/peace_river/peace_river.dart';
import 'package:gearforce/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/models/unit/role.dart';

const String _baseRuleId = 'rule::poc';
const String _ruleMercContractName = 'Mercenary Contract';
const String _ruleMercContractID = '$_baseRuleId::mercenaryContract';

/*
POC - Peace Officer Corps
The POC maintains order and security across the vast Peace River Protectorate. Many
a citizen, Riverans and Badlanders alike, view answering calls to assist the POC with
honor. Stories of being deputized by a POC officer are usually told with pride. In the
Badlands, the POC represents freedom from chaos and horror. POC officers are often
treated with great respect and dignity. Their meals, lodging fees and many other things
are frequently, on the house.
* Special Issue: Greyhounds may be placed in GP, SK, FS, RC or SO units.
* ECM Specialist: One gear or strider per combat group may improve its ECM to
ECM+ for 1 TV each.
* Ol’ Trusty: Pit Bulls and Mustangs may increase their GU skill by one for 1 TV each.
* Peace Officers: Gears from one combat group may swap their rocket packs for
the Shield trait. If a gear does not have a rocket pack, then it may instead gain the
Shield trait for 1 TV.
* G-SWAT Sniper: One gear with a rifle, per combat group, may purchase the
Improved Gunnery upgrade for 1 TV each, without being a veteran.
* Mercenary Contract: One combat group may be made with models from North,
South, Peace River, and NuCoal (may include a mix from all four factions) that have
an armor of 8 or lower.
*/
class POC extends PeaceRiver {
  POC(super.data)
      : super(
          name: 'Peace Officer Corps',
          subFactionRules: [
            ruleSpecialIssue,
            ruleECMSpecialist,
            rulePOCOlTrusty,
            rulePeaceOfficer,
            ruleGSwatSniper,
            ruleMercenaryContract,
          ],
        );
}

const filterMercContract = const SpecialUnitFilter(
  text: _ruleMercContractName,
  id: _ruleMercContractID,
  filters: const [
    const UnitFilter(FactionType.North, matcher: matchArmor8),
    const UnitFilter(FactionType.South, matcher: matchArmor8),
    const UnitFilter(FactionType.PeaceRiver, matcher: matchArmor8),
    const UnitFilter(FactionType.NuCoal, matcher: matchArmor8),
  ],
);

final ruleSpecialIssue = FactionRule(
  name: 'Special Issue',
  id: '$_baseRuleId::specialIssue',
  hasGroupRole: (unit, target, group) {
    if (unit.core.frame == 'Greyhound' &&
        (target == RoleType.GP ||
            target == RoleType.SK ||
            target == RoleType.FS ||
            target == RoleType.RC ||
            target == RoleType.SO)) {
      return true;
    }
    return null;
  },
  description: 'Greyhounds may be placed in GP, SK, FS, RC or SO units.',
);

final ruleECMSpecialist = FactionRule(
    name: 'ECM Specialist',
    id: '$_baseRuleId::ecmSpecialist',
    factionMod: (ur, cg, u) => PeaceRiverFactionMods.ecmSpecialist(),
    description:
        'One gear or strider per combat group may improve its ECM to ECM+ for 1 TV each.');

final rulePOCOlTrusty = FactionRule(
  name: 'Ol\' Trusty',
  id: '$_baseRuleId::oltrusty',
  factionMod: (ur, cg, u) => PeaceRiverFactionMods.olTrustyPOC(),
  description:
      'Pit Bulls and Mustangs may increase their GU skill by one for 1 TV each.',
);

final rulePeaceOfficer = FactionRule(
    name: 'Peace Officer',
    id: '$_baseRuleId::peaceOfficer',
    factionMod: (ur, cg, u) => PeaceRiverFactionMods.peaceOfficers(u),
    description:
        'Gears from one combat group may swap their rocket packs for the Shield trait. If a gear does not have a rocket pack, then it may instead gain the Shield trait for 1 TV.');

final ruleGSwatSniper = FactionRule(
    name: 'G-Swat Sniper',
    id: '$_baseRuleId::gswatSniper',
    veteranModCheck: (u, cg, {required modID}) {
      if (modID == improvedGunneryID && u.hasMod(gSWATSniperID)) {
        return true;
      }
      return null;
    },
    modCostOverride: (baseCost, modID, u) {
      if (modID == improvedGunneryID && u.hasMod(gSWATSniperID)) {
        return 1;
      }
      return baseCost;
    },
    factionMod: (ur, cg, u) => PeaceRiverFactionMods.gSWATSniper(),
    description:
        'One gear with a rifle, per combat group, may purchase the Improved Gunnery upgrade for 1 TV each, without being a veteran.');

final FactionRule ruleMercenaryContract = FactionRule(
    name: _ruleMercContractName,
    id: _ruleMercContractID,
    cgCheck: onlyOneCG(_ruleMercContractID),
    canBeAddedToGroup: (unit, group, cg) {
      return unit.armor == null || (unit.armor != null && unit.armor! <= 8);
    },
    combatGroupOption: () {
      return ruleMercenaryContract.buidCombatGroupOption();
    },
    unitFilter: () => filterMercContract,
    description:
        'One combat group may be made with models from North, South, Peace River, and NuCoal (may include a mix from all four factions) that have an armor of 8 or lower.');
