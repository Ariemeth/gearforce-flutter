import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/weapons/weapon.dart';
import 'package:gearforce/models/weapons/weapon_modes.dart';
import 'package:pdf/widgets.dart' as pw;

const double _cornerRadius = 5.0;
const double _borderThickness = 1.0;
const double _roleRowPadding = 5.0;
const double _nameRowPadding = 5.0;
const double _statPadding = 5.0;
const double _weaponSectionPadding = 5.0;
const double _cardHeight = 300.0;
const double _cardWidth = 250.0;
const double? _section3Height = 65.0;
const double _combatStatsWidth = 50.0;
const double _secondaryStatsWidth = 80.0;
const double _hullWidth =
    (_cardWidth - _combatStatsWidth - _secondaryStatsWidth) / 2;
const double _standardFontSize = 12;
const double _weaponFontSize = 10;
const double _traitFontSize = 10;
const double _nameFontSize = 16;
const double _structureBlockWidth = 15;
const double _structureBlockHeight = 15;
const double _structureBlockSpacingWidth = 3.0;
const double _structureBlockSpacingHeight = 5.0;

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
        _buildTraitsSection(font, u.traits),
        _buildWeaponsSection(font, u.weapons),
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
  return pw.Container(
    padding: pw.EdgeInsets.all(_nameRowPadding),
    child: pw.Text(
      u.name,
      style: pw.TextStyle(
        fontSize: _nameFontSize,
        font: font,
        fontWeight: pw.FontWeight.bold,
      ),
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
  return pw.Container(
    padding: pw.EdgeInsets.only(top: _roleRowPadding, bottom: _roleRowPadding),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
      children: [
        pw.Container(
          child: pw.Text(
            'Roles: ${u.role()!.roles.join(', ')}',
            style: pw.TextStyle(fontSize: _standardFontSize),
            textAlign: pw.TextAlign.center,
          ),
        ),
        pw.Container(
          child: pw.Text(
            'TV: ${u.tv}',
            style: pw.TextStyle(fontSize: _standardFontSize),
            textAlign: pw.TextAlign.center,
          ),
        ),
        pw.Container(
          child: pw.Text(
            'Type: ${u.type} ${u.core.height}',
            style: pw.TextStyle(fontSize: _standardFontSize),
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
  final textStyle = pw.TextStyle(font: font, fontSize: _standardFontSize);
  return pw.Container(
    alignment: pw.Alignment.topCenter,
    width: _combatStatsWidth,
    height: _section3Height,
    padding: pw.EdgeInsets.all(_statPadding),
    child: pw.Table(
      columnWidths: {
        0: pw.FixedColumnWidth(_combatStatsWidth * 0.45),
        1: pw.FlexColumnWidth(),
      },
      children: [
        pw.TableRow(
          children: [
            pw.Text('Gu:', style: textStyle, textAlign: pw.TextAlign.right),
            pw.Text('${u.gunnery ?? ' - '}${u.gunnery != null ? '+' : ''}',
                style: textStyle, textAlign: pw.TextAlign.right),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Text('Pi:', style: textStyle, textAlign: pw.TextAlign.right),
            pw.Text('${u.piloting ?? ' - '}${u.piloting != null ? '+' : ''}',
                style: textStyle, textAlign: pw.TextAlign.right),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Text('Ew:', style: textStyle, textAlign: pw.TextAlign.right),
            pw.Text('${u.ew ?? ' - '}${u.ew != null ? '+' : ''}',
                style: textStyle, textAlign: pw.TextAlign.right),
          ],
        ),
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
        _buildStatLine(font, 'Actions: ', '${u.actions ?? ' - '}'),
        _buildStatLine(font, 'Armor: ', '${u.armor ?? ' - '}'),
        _buildStatLine(font, 'Move: ', '${u.movement ?? ' - '}'),
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
      pw.Text(statName,
          style: pw.TextStyle(fontSize: _standardFontSize, font: font)),
      pw.Text(stat,
          style: pw.TextStyle(fontSize: _standardFontSize, font: font)),
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
        pw.Text(
          typeName,
          style: pw.TextStyle(
            fontSize: _standardFontSize,
            font: font,
          ),
        ),
        pw.GridView(
          padding: pw.EdgeInsets.only(top: 5.0),
          crossAxisCount: 5,
          childAspectRatio: 1,
          children: [
            for (var i = 0; i < numberOf; i++)
              pw.Container(
                width: _structureBlockWidth,
                height: _structureBlockHeight,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                  borderRadius: pw.BorderRadius.all(
                    pw.Radius.circular(2.5),
                  ),
                ),
              ),
          ],
          crossAxisSpacing: _structureBlockSpacingWidth,
          mainAxisSpacing: _structureBlockSpacingHeight,
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

pw.Widget _buildTraitsSection(pw.Font font, List<Trait> traits) {
  return pw.Container(
    child: pw.Text(traits.join(', '),
        softWrap: true,
        style: pw.TextStyle(
          fontSize: _traitFontSize,
          font: font,
        )),
    padding: pw.EdgeInsets.all(_nameRowPadding),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(),
    ),
  );
}

pw.Widget _buildWeaponsSection(pw.Font font, List<Weapon> weapons) {
  final rows = weapons
      .map(
        (w) => pw.TableRow(children: [
          pw.Padding(
            padding: pw.EdgeInsets.only(right: 5.0),
            child: pw.Text(
              w.abbreviation,
              style: pw.TextStyle(font: font, fontSize: _weaponFontSize),
            ),
          ),
          pw.Padding(
            padding: pw.EdgeInsets.only(),
            child: pw.Text(
              w.range.toString(),
              style: pw.TextStyle(font: font, fontSize: _weaponFontSize),
            ),
          ),
          pw.Padding(
            padding: pw.EdgeInsets.only(right: 5.0, left: 5.0),
            child: pw.Text(
              w.damage.toString(),
              style: pw.TextStyle(font: font, fontSize: _weaponFontSize),
              textAlign: pw.TextAlign.center,
            ),
          ),
          pw.Padding(
            padding: pw.EdgeInsets.only(),
            child: pw.Text(
              w.traits.join(', '),
              style: pw.TextStyle(font: font, fontSize: _weaponFontSize),
            ),
          ),
          pw.Padding(
            padding: pw.EdgeInsets.only(),
            child: pw.Text(
              w.modes.map((e) => getWeaponModeName(e)[0]).join(', '),
              style: pw.TextStyle(font: font, fontSize: _weaponFontSize),
              textAlign: pw.TextAlign.center,
            ),
          ),
        ]),
      )
      .toList();
  final headerRow = pw.TableRow(children: [
    pw.Padding(
      padding: pw.EdgeInsets.only(right: 5.0),
      child: pw.Text(
        'Code',
        style: pw.TextStyle(
          font: font,
          fontSize: _weaponFontSize,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    ),
    pw.Padding(
      padding: pw.EdgeInsets.only(),
      child: pw.Text(
        'Range',
        style: pw.TextStyle(
          font: font,
          fontSize: _weaponFontSize,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    ),
    pw.Padding(
      padding: pw.EdgeInsets.only(right: 5.0, left: 5.0),
      child: pw.Text(
        'Damage',
        style: pw.TextStyle(
          font: font,
          fontSize: _weaponFontSize,
          fontWeight: pw.FontWeight.bold,
        ),
        textAlign: pw.TextAlign.center,
      ),
    ),
    pw.Padding(
      padding: pw.EdgeInsets.only(),
      child: pw.Text(
        'Traits',
        style: pw.TextStyle(
          font: font,
          fontSize: _weaponFontSize,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    ),
    pw.Padding(
      padding: pw.EdgeInsets.only(),
      child: pw.Text(
        'Modes',
        style: pw.TextStyle(
          font: font,
          fontSize: _weaponFontSize,
          fontWeight: pw.FontWeight.bold,
        ),
        textAlign: pw.TextAlign.center,
      ),
    ),
  ]);

  final Map<int, pw.TableColumnWidth> columnWidths = {3: pw.FlexColumnWidth()};

  return pw.Container(
    padding: pw.EdgeInsets.all(_weaponSectionPadding),
    child: pw.Table(
      children: [headerRow, ...rows],
      columnWidths: columnWidths,
    ),
    decoration: pw.BoxDecoration(),
  );
}
