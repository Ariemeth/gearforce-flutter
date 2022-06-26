import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/mods/factionUpgrades/peace_river.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_core.dart';

class PeaceRiver extends RuleSet {
  const PeaceRiver(super.data, {super.specialRules});

  @override
  List<UnitCore> availableUnits({
    List<RoleType?>? role,
    List<String>? filters,
  }) {
    return data.unitList(FactionType.PeaceRiver, role: role, filters: filters);
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
    // Peace river duelist can be in a strider Rule: Architects
    if (!(u.type == 'Gear' || u.type == 'Strider')) {
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
Z Ol’ Trusty: Warriors, Jackals and Spartans may increase their GU skill by one for 1
TV each. This does not include Warrior IVs.
Z Thunder from the Sky: Airstrike counters may increase their GU skill to 3+ instead
of 4+ for 1 TV each.
Z High Tech: Models with weapons that have the Advanced or Guided traits have
unlimited availability for all primary units.
Z The Best Men and Women for the Job: One model in each combat group may be
selected from the Black Talon model list.
Z Elite Elements: One SK unit may change their role to SO.
Z Ghost Strike: Models in one combat group using special operations deployment
may start the game with hidden tokens if all the models within the combat group
are placed in cover relative to at least one enemy model.
*/
const PRDFSpecialRule1 =
    'Ghost Strike: Models in one combat group using special operations ' +
        'deployment may start the game with hidden tokens if all the models ' +
        'within the combat group are placed in cover relative to at least ' +
        'one enemy model.';

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
  bool canBeAddedToGroup(
    UnitCore uc,
    Group group, {
    RoleType? roleTypeOverride,
  }) {
    /*
      High Tech: Models with weapons that have the Advanced or Guided traits
      have unlimited availability for all primary units.
    */

    return super.canBeAddedToGroup(uc, group);
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
Z Special Issue: Greyhounds may be placed in GP, SK, FS, RC or SO units.
Z ECM Specialist: One gear or strider per combat group may improve its ECM to
ECM+ for 1 TV each.
Z Ol’ Trusty: Pit Bulls and Mustangs may increase their GU skill by one for 1 TV each.
Z Peace Officers: Gears from one combat group may swap their rocket packs for
the Shield trait. If a gear does not have a rocket pack, then it may instead gain the
Shield trait for 1 TV.
Z G-SWAT Sniper: One gear with a rifle, per combat group, may purchase the
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
    return super.availableFactionMods(ur, cg, u);
  }
}

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
