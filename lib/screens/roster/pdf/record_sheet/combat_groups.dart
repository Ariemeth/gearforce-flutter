import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:pdf/widgets.dart' as pw;

const double _standardTextSize = 12;
const double _smallTextSize = 8;

List<pw.Widget> buildCombatGroups(pw.Font font, UnitRoster roster) {
  final standardTextStyle =
      pw.TextStyle(font: font, fontSize: _standardTextSize);
  final smallTextStyle = pw.TextStyle(font: font, fontSize: _smallTextSize);

  final List<pw.Widget> combatGroups = [];
  roster.getCGs().forEach((cg) {
    combatGroups.add(buildCombatGroup(font, cg));
  });
  return combatGroups;
}

pw.Widget buildCombatGroup(pw.Font font, CombatGroup cg) {
  final standardTextStyle =
      pw.TextStyle(font: font, fontSize: _standardTextSize);
  final smallTextStyle = pw.TextStyle(font: font, fontSize: _smallTextSize);

  return pw.Text(
    'Content for ${cg.name} to be loaded here',
    style: standardTextStyle,
  );
}
