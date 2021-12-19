import 'dart:math';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:pdf/widgets.dart' as pw;

//const double _standardTextSize = 12;
const double _smallTextSize = 8;

final primarySecondaryDivide =
    pw.Padding(padding: pw.EdgeInsets.only(bottom: 5.0));
final groupDivide = pw.Padding(padding: pw.EdgeInsets.only(bottom: 10.0));

List<pw.Widget> buildCombatGroups(pw.Font font, UnitRoster roster) {
  final List<pw.Widget> combatGroups = [];
  roster.getCGs().forEach((cg) {
    combatGroups.add(buildCombatGroup(font, cg));
  });
  return combatGroups;
}

pw.Widget buildCombatGroup(pw.Font font, CombatGroup cg) {
//  final standardTextStyle =
//      pw.TextStyle(font: font, fontSize: _standardTextSize);
  final smallTextStyle = pw.TextStyle(font: font, fontSize: _smallTextSize);

  final primary = pw.Row(children: [
    pw.Transform.rotateBox(
        angle: pi / 2,
        child: pw.Text(
          '${cg.name} Primary',
          style: smallTextStyle,
        ))
  ]);

  final secondary = pw.Row(children: [
    pw.Transform.rotateBox(
        angle: pi / 2,
        child: pw.Text(
          '${cg.name} Seondary',
          style: smallTextStyle,
        ))
  ]);

  final result = pw.Column(children: [
    primary,
    primarySecondaryDivide,
    secondary,
    groupDivide,
  ]);

  return result;
}
