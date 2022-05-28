import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/duelist/duelist_modification.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/unit/unit.dart';

List<DuelistModification> getDuelistMods(
  Unit u,
  CombatGroup cg,
  UnitRoster roster,
) {
  return [
    DuelistModification.makeDuelist(u, roster),
    DuelistModification.independentOperator(u, cg),
    DuelistModification.leadByExample(u, roster),
    DuelistModification.advancedControlSystem(u),
    DuelistModification.stable(u),
    DuelistModification.precise(u),
    DuelistModification.auto(u),
    DuelistModification.dualMeleeWeapons(u),
    DuelistModification.agile(u),
    DuelistModification.shield(u),
    DuelistModification.meleeUpgrade(u),
  ];
}

DuelistModification? buildDuelistUpgrade(
    String id, Unit u, CombatGroup cg, UnitRoster roster) {
  switch (id) {
    case duelistId:
      return DuelistModification.makeDuelist(u, roster);
    case independentOperatorId:
      return DuelistModification.independentOperator(u, cg);
    case leadByExampleId:
      return DuelistModification.leadByExample(u, roster);
      break;
    case advancedControlSystemId:
      return DuelistModification.advancedControlSystem(u);
    case stableId:
      return DuelistModification.stable(u); // Stable
    // requires tweaks for cost
    case preciseId:
      return DuelistModification.precise(u); // Precise
    case autoId:
      return DuelistModification.auto(u); // Auto
    case aceGunnerId:
      // TODO add ace gunner
      break;
    case trickShotId:
      // TODO add trick shot
      break;
    case dualMeleeWeaponsId:
      return DuelistModification.dualMeleeWeapons(u); // dual melee weapons
    case agileId:
      return DuelistModification.agile(u); // agile
    case shieldId:
      return DuelistModification.shield(u); // shield
    case meleeUpgradeId:
      return DuelistModification.meleeUpgrade(u); // duelist melee upgrade
    case ecmId:
      // TODO add ecm upgrade
      break;
  }

  return null;
}
