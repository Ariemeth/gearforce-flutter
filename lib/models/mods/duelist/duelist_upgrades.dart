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
