import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/veteranUpgrades/veteran_modification.dart';
import 'package:gearforce/models/unit/unit.dart';

List<VeternModification> getVeteranMods(Unit u, CombatGroup cg) {
  return [
    VeternModification.makeVet(u, cg),
    VeternModification.ewSpecialist(u, cg),
    VeternModification.fieldArmor(u, cg),
    VeternModification.inYourFace1(u, cg),
    VeternModification.inYourFace2(u, cg),
    VeternModification.insulated(u, cg),
    VeternModification.fireproof(u, cg),
    VeternModification.oldReliable(u, cg),
    VeternModification.stainlessSteel(u, cg),
    VeternModification.sharpShooter(u, cg),
    VeternModification.trickShot(u, cg),
    VeternModification.meleeWeaponUpgradeLCW(u, cg),
    VeternModification.meleeWeaponUpgradeLVB(u, cg),
  ];
}
