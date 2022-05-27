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
    VeteranModification.stainlessSteel(u),
    VeteranModification.improvedGunnery(u),
    VeteranModification.trickShot(u),
    VeteranModification.meleeWeaponUpgrade(u),
  ];
}

VeteranModification? buildVetUpgrade(String id, Unit u, CombatGroup cg) {
  switch (id) {
    case veteranId:
      return VeteranModification.makeVet(u, cg);
    case improvedGunneryId:
      return VeteranModification.improvedGunnery(u);
    case ewSpecId:
      return VeteranModification.ewSpecialist(u); // ECCM
    case fieldArmorId:
      return VeteranModification.fieldArmor(u); // Field armor
    case inYourFaceId1:
      return VeteranModification.inYourFace1(u); // Brawler
    case inYourFaceId2:
      return VeteranModification.inYourFace2(u); // Brawler
    case insulatedId:
      return VeteranModification.insulated(u); // resist:H
    case fireproofId:
      return VeteranModification.fireproof(u); // resist:F
    case stainlessSteelId:
      return VeteranModification.stainlessSteel(u); // resist:C
    case trickShotId:
      return VeteranModification.trickShot(
          u); // DNE thi is now duelist ace gunner
    case meleeUpgrade:
      return VeteranModification.meleeWeaponUpgrade(
          u); // Veteran melee upgrade, slight tweak

    // TODO add improve gunnery
    // TODO add dual guns
    // TODO add Reach
    // TODO add AMS
  }
  return null;
}
