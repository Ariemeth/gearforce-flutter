import 'package:gearforce/models/mods/duelist/duelist_modification.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/unit/unit.dart';

List<DuelistModification> getDuelistMods(Unit u, UnitRoster roster) {
  return [
    DuelistModification.makeDuelist(u, roster),
    DuelistModification.independentOperator(u, roster),
    DuelistModification.aceGunner(u),
    DuelistModification.advancedControlSystem(u),
    DuelistModification.crackShot(u),
    DuelistModification.defender(u),
    DuelistModification.dualWield(u),
    DuelistModification.gunslinger(u),
    DuelistModification.lunge(u),
    DuelistModification.pushTheEnvelope(u),
    DuelistModification.quickDraw(u),
    DuelistModification.shieldBearer(u),
    DuelistModification.smashfest(u),
  ];
}

DuelistModification? buildDuelistUpgrade(String id, Unit u, UnitRoster roster) {
  switch (id) {
    case duelistId:
      return DuelistModification.makeDuelist(u, roster);
    case independentOperatorId:
      return DuelistModification.independentOperator(u, roster);
    // TODO add lead by example
    case aceGunnerId:
      return DuelistModification.aceGunner(u); // Stable
    case advancedControlSystemId:
      return DuelistModification.advancedControlSystem(
          u); // requires tweaks for cost
    case crackShotId:
      return DuelistModification.crackShot(u); // Precise
    case defenderId:
      return DuelistModification.defender(u); // This is now the vet trait AMS
    case dualWieldId:
      return DuelistModification.dualWield(u); // dual melee weapons
    case gunslingerId:
      return DuelistModification.gunslinger(
          u); // This is now vet trait Dual Guns
    case lungeId:
      return DuelistModification.lunge(u); // this is now vet upgrade Reach
    case pushTheEnvelopeId:
      return DuelistModification.pushTheEnvelope(u); // agile
    case quickDrawId:
      return DuelistModification.quickDraw(u); // Auto
    case shieldBearerId:
      return DuelistModification.shieldBearer(u); // shield
    case smashFestId:
      return DuelistModification.smashfest(u); // duelist melee upgrade
    // TODO add trick shot
    // TODO add ecm upgrade
  }

  return null;
}
