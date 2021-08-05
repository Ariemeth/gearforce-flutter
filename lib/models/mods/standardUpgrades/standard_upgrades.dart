import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/standardUpgrades/standard_modification.dart';
import 'package:gearforce/models/unit/unit.dart';

List<StandardModification> getStandardMods(Unit u, CombatGroup cg) {
  return [
    StandardModification.antiAir(u, cg),
    StandardModification.drones(u, cg),
    StandardModification.grenadeSwap(u, cg),
    StandardModification.handGrenadeLHG(u, cg),
    StandardModification.handGrenadeMHG(u, cg),
    StandardModification.panzerfaustsL(u, cg),
    StandardModification.panzerfaustsM(u, cg),
    StandardModification.shapedExplosivesL(u, cg),
    StandardModification.shapedExplosivesM(u, cg),
    StandardModification.sidearmLP(u, cg),
    StandardModification.sidearmSMG(u, cg),
    StandardModification.smoke(u, cg),
  ];
}
