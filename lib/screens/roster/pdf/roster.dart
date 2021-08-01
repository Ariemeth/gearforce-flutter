import 'package:gearforce/models/roster/roster.dart';
import 'package:pdf/widgets.dart' as pw;

List<pw.Widget> buildRosterContent(pw.Font font, UnitRoster roster) {
  return [
    pw.ConstrainedBox(
      constraints: pw.BoxConstraints.expand(),
      child: pw.FittedBox(
        fit: pw.BoxFit.none,
        child: pw.Text(
          'Hello World',
          style: pw.TextStyle(font: font, fontSize: 10),
        ),
      ),
    )
  ];
}
