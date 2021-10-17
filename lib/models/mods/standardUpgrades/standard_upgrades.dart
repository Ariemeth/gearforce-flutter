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

StandardModification? buildStandardUpgrade(String id, Unit u, CombatGroup cg) {
  switch (id) {
    case antiAirId:
      return StandardModification.antiAir(u, cg);
    case droneId:
      return StandardModification.drones(u, cg);
    case grenadeSwapId:
      return StandardModification.grenadeSwap(u, cg);
    case handGrenadeLId:
      return StandardModification.handGrenadeLHG(u, cg);
    case handGrenadeMId:
      return StandardModification.handGrenadeMHG(u, cg);
    case panzerfaustsLId:
      return StandardModification.panzerfaustsL(u, cg);
    case panzerfaustsMId:
      return StandardModification.panzerfaustsM(u, cg);
    case pistolsId:
      return StandardModification.sidearmLP(u, cg);
    case subMachineGunId:
      return StandardModification.sidearmSMG(u, cg);
    case shapedExplosivesLId:
      return StandardModification.shapedExplosivesL(u, cg);
    case shapedExplosivesMId:
      return StandardModification.shapedExplosivesM(u, cg);
    case smokeId:
      return StandardModification.smoke(u, cg);
  }
  return null;
}
