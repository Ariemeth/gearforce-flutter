import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/mods/factionUpgrades/peace_river.dart';
import 'package:gearforce/models/mods/veteranUpgrades/veteran_modification.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/rules/special_unit_filter.dart';
import 'package:gearforce/models/unit/model_type.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_core.dart';

/*
  All the models in the Peace River Model List can be used in any of the sub-lists below. There are also models in the
  Universal Model List that may be selected as well.
  All Peace River forces have the following rule:
  * E-pex: One Peace River model within each combat group may increase its EW skill by one for 1 TV each.
  * Warrior Elite: Any Warrior IV may be upgraded to a Warrior Elite for 1 TV each. This upgrade gives the Warrior IV a
  H/S of 4/2, an EW skill of 4+, and the Agile trait.
  * Crisis Responders: Any Crusader IV that has been upgraded to a Crusader V may swap their HAC, MSC, MBZ or LFG
  for a MPA (React) and a Shield for 1 TV. This Crisis Responder variant is unlimited for this force.
  * Laser Tech: Veteran universal infantry and veteran Spitz Monowheels may upgrade their IW, IR or IS for 1 TV each.
  These weapons receive the Advanced trait.
  * Architects: The duelist for this force may use a Peace River strider.
*/
class PeaceRiver extends RuleSet {
  PeaceRiver(super.data, {super.specialRules});

  Map<UnitCore, String> _unit_cache = {};

  @override
  List<UnitCore> availableUnits({
    List<RoleType>? role,
    List<String>? characterFilters,
    SpecialUnitFilter? specialUnitFilter,
  }) {
    final coreUnits = getCoreUnits(
      role,
      characterFilters,
      specialUnitFilter,
    );
    final specialUnits = <UnitCore>[];

    if (specialUnitFilter != null) {
      final units = data.getUnitsByFilter(filters: specialUnitFilter.filters);
      specialUnits.addAll(units);
      // cache the unit names mapped to the specials name they are apart to
      // allow identification of special units for the add to group checks.
      units.forEach((uc) {
        _unit_cache[uc] = specialUnitFilter.text;
      });
    }

    return coreUnits..addAll(specialUnits);
  }

  List<UnitCore> getCoreUnits(
    List<RoleType>? role,
    List<String>? characterFilters,
    SpecialUnitFilter? specialUnitFilter,
  ) {
    const unitFilters = [
      const UnitFilter(FactionType.PeaceRiver),
      const UnitFilter(FactionType.Airstrike),
      const UnitFilter(FactionType.Universal),
      const UnitFilter(FactionType.Universal_TerraNova),
      const UnitFilter(FactionType.Terrain),
    ];

    return data.getUnitsByFilter(
      filters: unitFilters,
      roleFilter: role,
      characterFilters: characterFilters,
    );
  }

  @override
  List<FactionModification> availableFactionMods(
      UnitRoster, CombatGroup cg, Unit u) {
    return [
      PeaceRiverFactionMods.e_pex(),
      PeaceRiverFactionMods.warriorElite(),
      PeaceRiverFactionMods.crisisResponders(u),
      PeaceRiverFactionMods.laserTech(u),
    ];
  }

  @override
  bool duelistCheck(UnitRoster roster, Unit u) {
    /*
    Architects: The duelist for this force may use a Peace River strider.
    */
    if (!(u.type == ModelType.Gear || u.type == ModelType.Strider)) {
      return false;
    }

    // only 1 duelist is allowed.
    return !roster.hasDuelist();
  }
}

/*
PRDF - Peace River Defense Force
To be a soldier in the PRDF is to know a deep and abiding hatred of Earth. CEF agents
were responsible for the destruction of Peace River City and countless lives. When this
information came to light, a sleeping beast awoke. PRDF recruitment has never been
better. With the full might of the manufacturing giant of Paxton Arms behind them, the
PRDF is a powerful force to face on the battlefield.
* Ol’ Trusty: Warriors, Jackals and Spartans may increase their GU skill by one for 1
TV each. This does not include Warrior IVs.
* Thunder from the Sky: Airstrike counters may increase their GU skill to 3+ instead
of 4+ for 1 TV each.
* High Tech: Models with weapons that have the Advanced or Guided traits have
unlimited availability for all primary units.
* The Best Men and Women for the Job: One model in each combat group may be
selected from the Black Talon model list.
* Elite Elements: One SK unit may change their role to SO.
* Ghost Strike: Models in one combat group using special operations deployment
may start the game with hidden tokens if all the models within the combat group
are placed in cover relative to at least one enemy model.
*/
const PRDFSpecialRule1 =
    'Ghost Strike: Models in one combat group using special operations ' +
        'deployment may start the game with hidden tokens if all the models ' +
        'within the combat group are placed in cover relative to at least ' +
        'one enemy model.';

const PRDFBestMenAndWomenSpecial = 'The Best Men and Women for the Job';

class PRDF extends PeaceRiver {
  PRDF(super.data) : super(specialRules: const [PRDFSpecialRule1]);

  @override
  List<FactionModification> availableFactionMods(
      UnitRoster ur, CombatGroup cg, Unit u) {
    return super.availableFactionMods(ur, cg, u)
      ..addAll([
        PeaceRiverFactionMods.olTrusty(),
        PeaceRiverFactionMods.thunderFromTheSky(),
        PeaceRiverFactionMods.eliteElements(ur),
      ]);
  }

  @override
  List<SpecialUnitFilter> availableSpecials() {
    return super.availableSpecials()
      ..addAll(
        [
          const SpecialUnitFilter(
            text: PRDFBestMenAndWomenSpecial,
            filters: [
              const UnitFilter(FactionType.BlackTalon),
            ],
          ),
        ],
      );
  }

  @override
  bool isUnitCountWithinLimits(CombatGroup cg, Group group, UnitCore uc) {
    switch (_unit_cache[uc]) {
      case PRDFBestMenAndWomenSpecial:
        /*
        The Best Men and Women for the Job: One model in each combat group may
        be selected from the Black Talon model list.
      */
        return cg.units.where((u) => u.core == uc).length == 0;
    }
    return super.isUnitCountWithinLimits(cg, group, uc);
  }

  @override
  bool isRoleTypeUnlimited(UnitCore uc, RoleType target, Group group) {
    if (super.isRoleTypeUnlimited(uc, target, group)) {
      return true;
    }

    /*
      High Tech: Models with weapons that have the Advanced or Guided traits
      have unlimited availability for all primary units.
    */
    return group.groupType == GroupType.Primary &&
        (uc.reactWeapons.any((w) => w.traits
                .any((t) => t.name == 'Advanced' || t.name == 'Guided')) ||
            uc.mountedWeapons.any((w) => w.traits
                .any((t) => t.name == 'Advanced' || t.name == 'Guided')));
  }
}

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
  List<UnitCore> getCoreUnits(
    List<RoleType>? role,
    List<String>? characterFilters,
    SpecialUnitFilter? specialUnitFilter,
  ) {
    if (specialUnitFilter?.text == POCMercContractSpecialFilter.text) {
      return [];
    }
    return super.getCoreUnits(role, characterFilters, specialUnitFilter);
  }

  @override
  bool canBeAddedToGroup(UnitCore uc, Group group, CombatGroup cg) {
    // TODO handle mercenary contract special
    /*  switch (_unit_cache[uc]) {
      case PRDFBestMenAndWomenSpecial:
      
        return cg.units.where((u) => u.core == uc).length == 0;
    }*/
    // return true;
    return super.canBeAddedToGroup(uc, group, cg);
  }

  @override
  bool hasGroupRole(UnitCore uc, RoleType target) {
    if (super.hasGroupRole(uc, target)) {
      return true;
    }

    /*
    Special Issue: Greyhounds may be placed in GP, SK, FS, RC or SO units.
    */
    if (uc.frame == 'Greyhound' &&
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
  List<SpecialUnitFilter> availableSpecials() {
    return super.availableSpecials()
      ..addAll(
        [
          POCMercContractSpecialFilter,
        ],
      );
  }
}

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
PPS - Paxton Private Securities
The Paxton Private Securities LLC offers private contractors at a good rate. After all, if
you can’t afford your own army made with the best of Paxton’s offerings, maybe you
can rent their forces at competitive rates instead. While held in reserve for the highest
bidder, discounts are available during times of peace to ensure they stay well practiced.
Z Ex-PRDF: Choose any one upgrade option from the PRDF.
Z Ex-POC: Choose any one upgrade option from the POC.
Z Badland’s Soup: One combat group may purchase the following veteran upgrades
for their models without being veterans; Improved Gunnery, Dual Guns, Brawler,
Veteran Melee upgrade, or ECCM.
Z Sub-Contractors: One combat group may be made with models from North,
South, Peace River, and NuCoal (may include a mix from all four factions) that
have an armor of 8 or lower.
*/
class PPS extends PeaceRiver {
  PPS(super.data);

  @override
  List<FactionModification> availableFactionMods(
      UnitRoster ur, CombatGroup cg, Unit u) {
    return super.availableFactionMods(ur, cg, u);
  }
}
