import 'package:gearforce/models/roster/roster.dart';
import 'package:pdf/widgets.dart' as pw;

List<pw.Widget> buildCombatGroups(pw.Font font, UnitRoster roster) {
  return [
    pw.Text(
      'Content',
      style: pw.TextStyle(
        font: font,
        fontSize: 12,
      ),
    ),
  ];
}
