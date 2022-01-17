import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:pdf/widgets.dart' as pw;

const double _headerTextSize = 12;
const double _standardTextSize = 10;
//const double _smallTextSize = 8;
const double _cornerRadius = 5.0;
const double _borderThickness = 1.0;

final primarySecondaryDivide =
    pw.Padding(padding: pw.EdgeInsets.only(bottom: 5.0));

List<pw.Widget> buildUnitCards(pw.Font font, UnitRoster roster) {
  final List<pw.Widget> units = [];
  roster.getCGs().forEach((cg) {
    units.addAll(_buildCombatGroupUnits(font, cg));
  });
  return units;
}

List<pw.Widget> _buildCombatGroupUnits(pw.Font font, CombatGroup cg) {
  final List<pw.Widget> groupCards = [];

  groupCards.addAll(_buildUnitCards(font, cg.primary.allUnits()));
  groupCards.addAll(_buildUnitCards(font, cg.secondary.allUnits()));

  return groupCards;
}

List<pw.Widget> _buildUnitCards(pw.Font font, List<Unit> units) {
  return units.map((us) => _buildUnitCard(font, us)).toList();
}

pw.Widget _buildUnitCard(pw.Font font, Unit u) {
  final titleTextStyle = pw.TextStyle(
    font: font,
    fontSize: _headerTextSize,
    fontWeight: pw.FontWeight.bold,
  );

  final standardTextStyle = pw.TextStyle(
    font: font,
    fontSize: _standardTextSize,
  );

  return pw.Container(
    width: 250.0,
    height: 300.0,
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        // Name box
        pw.Container(
          child: pw.Padding(
            padding: pw.EdgeInsets.all(5.0),
            child: pw.Text(
              u.name,
              style: titleTextStyle,
              textAlign: pw.TextAlign.center,
            ),
          ),
          decoration: pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(
                width: _borderThickness,
              ),
            ),
          ),
        ),
        // Role, TV, and Type boxes
        pw.Container(
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
            children: [
              pw.Container(
                child: pw.Text(
                  'Roles: ${u.role()!.roles.join(', ')}',
                  style: standardTextStyle,
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Container(
                child: pw.Text(
                  'TV: ${u.tv}',
                  style: standardTextStyle,
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Container(
                child: pw.Text(
                  'Type: ${u.type} ${u.core.height}',
                  style: standardTextStyle,
                  textAlign: pw.TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(),
      borderRadius: const pw.BorderRadius.only(
        topLeft: pw.Radius.circular(_cornerRadius),
        topRight: pw.Radius.circular(_cornerRadius),
        bottomLeft: pw.Radius.circular(_cornerRadius),
        bottomRight: pw.Radius.circular(_cornerRadius),
      ),
    ),
  );
}
