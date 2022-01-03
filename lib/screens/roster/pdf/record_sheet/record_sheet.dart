import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/screens/roster/pdf/record_sheet/combat_groups.dart';
import 'package:gearforce/screens/roster/pdf/record_sheet/header.dart';
import 'package:pdf/widgets.dart' as pw;

final sectionDivide = pw.Padding(padding: pw.EdgeInsets.only(bottom: 10.0));

List<pw.Widget> buildRecordSheet(pw.Font font, UnitRoster roster) {
  return [
    buildRosterHeader(font, roster),
    sectionDivide,
    ...buildCombatGroups(font, roster),
  ];
}
