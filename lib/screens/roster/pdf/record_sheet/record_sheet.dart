import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/screens/roster/pdf/record_sheet/combat_groups.dart';
import 'package:gearforce/screens/roster/pdf/record_sheet/header.dart';
import 'package:pdf/widgets.dart' as pw;

List<pw.Widget> buildRecordSheet(pw.Font font, UnitRoster roster) {
  return [
    buildRosterHeader(font, roster),
    pw.Spacer(),
    ...buildCombatGroups(font, roster),
  ];
}
