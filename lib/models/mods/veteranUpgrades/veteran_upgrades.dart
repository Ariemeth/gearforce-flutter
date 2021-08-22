import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/veteranUpgrades/veteran_modification.dart';
import 'package:gearforce/models/unit/unit.dart';

List<VeteranModification> getVeteranMods(Unit u, CombatGroup cg) {
  return [
    VeteranModification.makeVet(u, cg),
    VeteranModification.ewSpecialist(u),
    VeteranModification.fieldArmor(u),
    VeteranModification.inYourFace1(u),
    VeteranModification.inYourFace2(u),
    VeteranModification.insulated(u),
    VeteranModification.fireproof(u),
    VeteranModification.oldReliable(u),
    VeteranModification.stainlessSteel(u),
    VeteranModification.sharpShooter(u),
    VeteranModification.trickShot(u),
    VeteranModification.meleeWeaponUpgrade(u),
  ];
}
