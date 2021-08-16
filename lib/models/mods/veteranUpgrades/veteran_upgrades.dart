import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/veteranUpgrades/veteran_modification.dart';
import 'package:gearforce/models/unit/unit.dart';

List<VeternModification> getVeteranMods(Unit u, CombatGroup cg) {
  return [
    VeternModification.makeVet(u, cg),
    VeternModification.ewSpecialist(u),
    VeternModification.fieldArmor(u),
    VeternModification.inYourFace1(u),
    VeternModification.inYourFace2(u),
    VeternModification.insulated(u),
    VeternModification.fireproof(u),
    VeternModification.oldReliable(u),
    VeternModification.stainlessSteel(u),
    VeternModification.sharpShooter(u),
    VeternModification.trickShot(u),
    VeternModification.meleeWeaponUpgradeLCW(u),
    VeternModification.meleeWeaponUpgradeLVB(u),
  ];
}
