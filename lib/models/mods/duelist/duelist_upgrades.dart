import 'package:gearforce/models/mods/duelist/duelist_modification.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/unit/unit.dart';

List<DuelistModification> getDuelistMods(Unit u, UnitRoster roster) {
  return [
    DuelistModification.makeDuelist(u, roster),
  ];
}
