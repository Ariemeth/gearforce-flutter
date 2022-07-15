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
    DuelistModification.aceGunner(u),
    DuelistModification.trickShot(u),
    DuelistModification.dualMeleeWeapons(u),
    DuelistModification.agile(),
    DuelistModification.shield(u),
    DuelistModification.meleeUpgrade(u),
    DuelistModification.ecm(),
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
    case advancedControlSystemId:
      return DuelistModification.advancedControlSystem(u);
    case stableId:
      return DuelistModification.stable(u);
    case preciseId:
      return DuelistModification.precise(u);
    case autoId:
      return DuelistModification.auto(u);
    case aceGunnerId:
      return DuelistModification.aceGunner(u);
    case trickShotId:
      return DuelistModification.trickShot(u);
    case dualMeleeWeaponsId:
      return DuelistModification.dualMeleeWeapons(u);
    case agileId:
      return DuelistModification.agile();
    case shieldId:
      return DuelistModification.shield(u);
    case meleeUpgradeId:
      return DuelistModification.meleeUpgrade(u);
    case ecmId:
      return DuelistModification.ecm();
  }

  return null;
}
