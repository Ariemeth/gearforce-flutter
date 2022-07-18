import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/veteranUpgrades/veteran_modification.dart';
import 'package:gearforce/models/unit/unit.dart';

List<VeteranModification> getVeteranMods(Unit u, CombatGroup cg) {
  return [
    VeteranModification.makeVet(u, cg),
    VeteranModification.improvedGunnery(u),
    VeteranModification.dualGuns(u),
    VeteranModification.eccm(u),
    VeteranModification.brawler1(u),
    VeteranModification.brawler2(u),
    VeteranModification.reach(u),
    VeteranModification.meleeWeaponUpgrade(u),
    VeteranModification.resistHaywire(u),
    VeteranModification.resistFire(u),
    VeteranModification.resistCorrosion(u),
    VeteranModification.fieldArmor(u),
    VeteranModification.ams(u),
  ];
}

VeteranModification? buildVetUpgrade(String id, Unit u, CombatGroup cg) {
  switch (id) {
    case veteranId:
      return VeteranModification.makeVet(u, cg);
    case improvedGunneryID:
      return VeteranModification.improvedGunnery(u);
    case dualGunsId:
      return VeteranModification.dualGuns(u);
    case eccmId:
      return VeteranModification.eccm(u);
    case brawl1Id:
      return VeteranModification.brawler1(u);
    case brawler2Id:
      return VeteranModification.brawler2(u);
    case reachId:
      return VeteranModification.reach(u);
    case meleeUpgradeId:
      return VeteranModification.meleeWeaponUpgrade(u);
    case resistHId:
      return VeteranModification.resistHaywire(u);
    case resistFId:
      return VeteranModification.resistFire(u);
    case resistCId:
      return VeteranModification.resistCorrosion(u);
    case fieldArmorId:
      return VeteranModification.fieldArmor(u);
    case amsId:
      return VeteranModification.ams(u);
  }
  return null;
}
