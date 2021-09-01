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

VeteranModification? buildVetUpgrade(String id, Unit u, CombatGroup cg) {
  switch (id) {
    case veteranId:
      return VeteranModification.makeVet(u, cg);
    case ewSpecId:
      return VeteranModification.ewSpecialist(u);
    case fieldArmorId:
      return VeteranModification.fieldArmor(u);
    case inYourFaceId1:
      return VeteranModification.inYourFace1(u);
    case inYourFaceId2:
      return VeteranModification.inYourFace2(u);
    case insulatedId:
      return VeteranModification.insulated(u);
    case fireproofId:
      return VeteranModification.fireproof(u);
    case oldReliableId:
      return VeteranModification.oldReliable(u);
    case stainlessSteelId:
      return VeteranModification.stainlessSteel(u);
    case sharpshooterId:
      return VeteranModification.sharpShooter(u);
    case trickShotId:
      return VeteranModification.trickShot(u);
    case meleeUpgrade:
      return VeteranModification.meleeWeaponUpgrade(u);
  }
  return null;
}
