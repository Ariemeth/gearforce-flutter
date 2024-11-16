import 'package:gearforce/v3/models/roster/roster.dart';
import 'package:gearforce/v3/screens/roster/pdf/record_sheet/combat_groups.dart';
import 'package:gearforce/v3/screens/roster/pdf/record_sheet/header.dart';
import 'package:pdf/widgets.dart' as pw;

final sectionDivide =
    pw.Padding(padding: const pw.EdgeInsets.only(bottom: 10.0));

List<pw.Widget> buildRecordSheet(pw.Font font, UnitRoster roster) {
  return [
    buildRosterHeader(font, roster),
    sectionDivide,
    ...buildCombatGroups(font, roster),
    roster.rulesetNotifer.value.specialRules != null
        ? pw.Column(children: [
            pw.Text('Faction Special Rules',
                style: pw.TextStyle(font: font, fontSize: 14)),
            ...roster.rulesetNotifer.value.specialRules!.map((rule) => pw.Text(
                  rule,
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 12,
                  ),
                )),
          ])
        : pw.Container(),
  ];
}
