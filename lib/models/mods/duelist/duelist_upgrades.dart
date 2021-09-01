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
    case aceGunnerId:
      return DuelistModification.aceGunner(u);
    case advancedControlSystemId:
      return DuelistModification.advancedControlSystem(u);
    case crackShotId:
      return DuelistModification.crackShot(u);
    case defenderId:
      return DuelistModification.defender(u);
    case dualWieldId:
      return DuelistModification.dualWield(u);
    case gunslingerId:
      return DuelistModification.gunslinger(u);
    case lungeId:
      return DuelistModification.lunge(u);
    case pushTheEnvelopeId:
      return DuelistModification.pushTheEnvelope(u);
    case quickDrawId:
      return DuelistModification.quickDraw(u);
    case shieldBearerId:
      return DuelistModification.shieldBearer(u);
    case smashFestId:
      return DuelistModification.smashfest(u);
  }

  return null;
}
