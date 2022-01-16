//import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/roster/roster.dart';
//import 'package:gearforce/models/combatGroups/group.dart';
//import 'package:gearforce/models/unit/command.dart';
import 'package:pdf/widgets.dart' as pw;

//const double _headerTextSize = 12;
//const double _standardTextSize = 10;
//const double _smallTextSize = 8;

final primarySecondaryDivide =
    pw.Padding(padding: pw.EdgeInsets.only(bottom: 5.0));

List<pw.Widget> buildUnitCards(pw.Font font, UnitRoster roster) {
  final List<pw.Widget> units = [];
  roster.getCGs().forEach((cg) {});
  return units;
}
