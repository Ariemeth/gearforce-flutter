import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:pdf/widgets.dart' as pw;

const double _headerTextSize = 12;
const double _standardTextSize = 10;
//const double _smallTextSize = 8;
const double _cornerRadius = 5.0;
const double _borderThickness = 1.0;
const double _roleRowPadding = 5.0;
const double _nameRowPadding = 5.0;
const double _statPadding = 5.0;
const double _cardHeight = 300.0;
const double _cardWidth = 250.0;
const double? _section3Height = 65.0;
const double _combatStatsWidth = 50.0;
const double _secondaryStatsWidth = 80.0;
const double _hullWidth =
    (_cardWidth - _combatStatsWidth - _secondaryStatsWidth) / 2;

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
  return pw.Container(
    width: _cardWidth,
    height: _cardHeight,
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        _buildFirstSection(font, u),
        _buildSecondSection(font, u),
        _buildThirdSection(font, u),
        _buildTraitsSection(font, u),
        _buildWeaponsSection(font, u),
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

pw.Widget _buildFirstSection(pw.Font font, Unit u) {
  final titleTextStyle = pw.TextStyle(
    font: font,
    fontSize: _headerTextSize,
    fontWeight: pw.FontWeight.bold,
  );

  return pw.Container(
    padding: pw.EdgeInsets.all(_nameRowPadding),
    child: pw.Text(
      u.name,
      style: titleTextStyle,
      textAlign: pw.TextAlign.center,
    ),
    decoration: pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(
          width: _borderThickness,
        ),
      ),
    ),
  );
}

pw.Widget _buildSecondSection(pw.Font font, Unit u) {
  final standardTextStyle = pw.TextStyle(
    font: font,
    fontSize: _standardTextSize,
  );
  return pw.Container(
    padding: pw.EdgeInsets.only(top: _roleRowPadding, bottom: _roleRowPadding),
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
    decoration: pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(
          width: _borderThickness,
        ),
      ),
    ),
  );
}

pw.Widget _buildThirdSection(pw.Font font, Unit u) {
  return pw.Container(
    height: _section3Height,
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildFirstStatBlock(font, u),
        _buildSecondStatBlock(font, u),
        _buildHullStructureBlock(font, 'Hull', u.hull ?? 0),
        _buildHullStructureBlock(font, 'Structure', u.structure ?? 0),
      ],
    ),
    decoration: pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(
          width: _borderThickness,
        ),
      ),
    ),
  );
}

pw.Widget _buildFirstStatBlock(pw.Font font, Unit u) {
  return pw.Container(
    width: _combatStatsWidth,
    padding: pw.EdgeInsets.all(_statPadding),
    child: pw.Column(
      children: [
        _buildStatLine(
            font, 'Gu: ', '${u.gunnery ?? '-'}${u.gunnery != null ? '+' : ''}'),
        _buildStatLine(font, 'Pi: ',
            '${u.piloting ?? '-'}${u.piloting != null ? '+' : ''}'),
        _buildStatLine(
            font, 'Ew: ', '${u.ew ?? '-'}${u.ew != null ? '+' : ''}'),
      ],
    ),
    decoration: pw.BoxDecoration(
      border: pw.Border(
        right: pw.BorderSide(
          width: _borderThickness,
        ),
      ),
    ),
  );
}

pw.Widget _buildSecondStatBlock(pw.Font font, Unit u) {
  return pw.Container(
    width: _secondaryStatsWidth,
    padding: pw.EdgeInsets.all(_statPadding),
    child: pw.Column(
      children: [
        _buildStatLine(font, 'Actions: ', '${u.actions ?? '-'}'),
        _buildStatLine(font, 'Armor: ', '${u.armor ?? '-'}'),
        _buildStatLine(font, 'Move: ', '${u.movement ?? '-'}'),
      ],
    ),
    decoration: pw.BoxDecoration(
      border: pw.Border(
        right: pw.BorderSide(
          width: _borderThickness,
        ),
      ),
    ),
  );
}

pw.Widget _buildStatLine(pw.Font font, String statName, String stat) {
  return pw.Row(
    children: [
      pw.Text(statName),
      pw.Text(stat),
    ],
  );
}

pw.Widget _buildHullStructureBlock(
    pw.Font font, String typeName, int numberOf) {
  return pw.Container(
    width: _hullWidth,
    padding: pw.EdgeInsets.all(_statPadding),
    child: pw.Column(
      children: [
        pw.Text(typeName),
        pw.GridView(
          padding: pw.EdgeInsets.only(top: 5.0),
          crossAxisCount: 5,
          childAspectRatio: 1,
          children: [
            for (var i = 0; i < numberOf; i++)
              pw.Container(
                  width: 15,
                  height: 15,
                  decoration: pw.BoxDecoration(
                      border: pw.Border.all(),
                      borderRadius:
                          pw.BorderRadius.all(pw.Radius.circular(2.5))))
          ],
          crossAxisSpacing: 3.0,
          mainAxisSpacing: 5.0,
        )
      ],
    ),
    decoration: pw.BoxDecoration(
      border: pw.Border(
        left: pw.BorderSide(
          width: _borderThickness,
        ),
        bottom: pw.BorderSide(
          width: _borderThickness,
        ),
      ),
    ),
  );
}

pw.Widget _buildTraitsSection(pw.Font font, Unit u) {
  return pw.Container(
    height: 10.0,
    decoration: pw.BoxDecoration(
      border: pw.Border.all(),
    ),
  );
}

pw.Widget _buildWeaponsSection(pw.Font font, Unit u) {
  return pw.Container(
    height: 10.0,
    decoration: pw.BoxDecoration(
      border: pw.Border.all(),
    ),
  );
}
