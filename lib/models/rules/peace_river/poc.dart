import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/mods/factionUpgrades/peace_river.dart';
import 'package:gearforce/models/mods/veteranUpgrades/veteran_modification.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/peace_river/peace_river.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/rules/special_unit_filter.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit.dart';

/*
  Mercenary Contract: One combat group may be made with models from 
  North, South, Peace River, and NuCoal (may include a mix from all 
  four factions) that have an armor of 8 or lower.
*/
const POCMercContractSpecialFilter = SpecialUnitFilter(
  text: 'Mercenary Contract',
  filters: [
    const UnitFilter(FactionType.North, matcher: matchArmor8),
    const UnitFilter(FactionType.South, matcher: matchArmor8),
    const UnitFilter(FactionType.PeaceRiver, matcher: matchArmor8),
    const UnitFilter(FactionType.NuCoal, matcher: matchArmor8),
  ],
);

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
Z Mercenary Contract: One combat group may be made with models from North,
South, Peace River, and NuCoal (may include a mix from all four factions) that have
an armor of 8 or lower.
*/
class POC extends PeaceRiver {
  POC(super.data);

  @override
  List<FactionModification> availableFactionMods(
      UnitRoster ur, CombatGroup cg, Unit u) {
    return super.availableFactionMods(ur, cg, u)
      ..addAll([
        PeaceRiverFactionMods.ecmSpecialist(),
        PeaceRiverFactionMods.olTrustyPOC(),
        PeaceRiverFactionMods.peaceOfficers(u),
        PeaceRiverFactionMods.gSWATSniper(),
      ]);
  }

  @override
  bool canBeAddedToGroup(Unit unit, Group group, CombatGroup cg) {
    // check if the unit is a core unit and is being added to a core only cg
    // this is the common and simple case.
    if (unit.hasTag(tagCore) &&
        cg.unitsWithTag(tagCore).length == cg.numberOfUnits()) {
      return super.canBeAddedToGroup(unit, group, cg);
    }

    /// The unit is not a sipmle core unit or the cg is not all core
    /// Need to check if this cg already has any [POCMercContractSpecialFilter]

    // Mercenary Contract special units can only be in a single Combat group
    if (unit.hasTag(POCMercContractSpecialFilter.text) &&
        !unit.hasTag(tagCore)) {
      if (cg.numberOfUnits() !=
          cg.units
              .where((u) => u.hasTag(POCMercContractSpecialFilter.text))
              .length) {
        return false;
      } else if (cg.numberOfUnits() !=
          cg.roster?.numberUnitsWithTag(POCMercContractSpecialFilter.text)) {
        return false;
      }
    } else if (cg.unitHasTag(POCMercContractSpecialFilter.text)) {
      return false;
    }

    return super.canBeAddedToGroup(unit, group, cg);
  }

  @override
  bool hasGroupRole(Unit unit, RoleType target) {
    if (super.hasGroupRole(unit, target)) {
      return true;
    }

    /*
    Special Issue: Greyhounds may be placed in GP, SK, FS, RC or SO units.
    */
    if (unit.core.frame == 'Greyhound' &&
        (target == RoleType.GP ||
            target == RoleType.SK ||
            target == RoleType.FS ||
            target == RoleType.RC ||
            target == RoleType.SO)) {
      return true;
    }
    return false;
  }

  @override
  bool veteranModCheck(
    Unit u, {
    String? modID,
  }) {
    /*
      G-SWAT Sniper: One gear with a rifle, per combat group, may purchase the
      Improved Gunnery upgrade for 1 TV each, without being a veteran.
    */
    if (modID != null &&
        modID == improvedGunneryID &&
        u.hasMod(gSWATSniperID)) {
      return true;
    }

    return super.veteranModCheck(u);
  }

  @override
  int modCostOverride(int baseCost, String modID, Unit u) {
    /*
      G-SWAT Sniper: One gear with a rifle, per combat group, may purchase the
      Improved Gunnery upgrade for 1 TV each, without being a veteran.
    */
    if (modID == improvedGunneryID && u.hasMod(gSWATSniperID)) {
      return 1;
    }
    return baseCost;
  }

  @override
  List<SpecialUnitFilter> availableSpecialFilters() {
    return super.availableSpecialFilters()
      ..addAll(
        [
          POCMercContractSpecialFilter,
        ],
      );
  }
}
