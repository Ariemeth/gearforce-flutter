import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/standardUpgrades/standard_modification.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/unit/unit.dart';

List<StandardModification> getStandardMods(
    Unit u, CombatGroup cg, UnitRoster roster) {
  return [
    StandardModification.antiAirTrait(u, cg),
    StandardModification.antiAirSwap(u, cg),
    StandardModification.meleeSwap(u),
    StandardModification.grenadeSwap(u, cg),
    StandardModification.handGrenadeLHG(u, cg, roster),
    StandardModification.handGrenadeMHG(u, cg),
    StandardModification.panzerfaustsL(u, cg, roster),
    StandardModification.panzerfaustsM(u, cg),
    StandardModification.shapedExplosivesL(u, cg, roster),
    StandardModification.shapedExplosivesM(u, cg),
    StandardModification.sidearmLP(u, cg, roster),
    StandardModification.sidearmSMG(u, cg, roster),
    StandardModification.smoke(u, cg),
  ];
}

StandardModification? buildStandardUpgrade(
  String id,
  Unit u,
  CombatGroup cg,
  UnitRoster roster,
) {
  switch (id) {
    case antiAirTraitId:
      return StandardModification.antiAirTrait(u, cg);
    case antiAirSwapId:
      return StandardModification.antiAirSwap(u, cg);
    case meleeSwapId:
      return StandardModification.meleeSwap(u);
    case grenadeSwapId:
      return StandardModification.grenadeSwap(u, cg);
    case handGrenadeLId:
      return StandardModification.handGrenadeLHG(u, cg, roster);
    case handGrenadeMId:
      return StandardModification.handGrenadeMHG(u, cg);
    case panzerfaustsLId:
      return StandardModification.panzerfaustsL(u, cg, roster);
    case panzerfaustsMId:
      return StandardModification.panzerfaustsM(u, cg);
    case pistolsId:
      return StandardModification.sidearmLP(u, cg, roster);
    case subMachineGunId:
      return StandardModification.sidearmSMG(u, cg, roster);
    case shapedExplosivesLId:
      return StandardModification.shapedExplosivesL(u, cg, roster);
    case shapedExplosivesMId:
      return StandardModification.shapedExplosivesM(u, cg);
    case smokeId:
      return StandardModification.smoke(u, cg);
  }
  return null;
}
