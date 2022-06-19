import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/weapons/weapon.dart';
import 'package:gearforce/models/weapons/weapon_modes.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

const double _cornerRadius = 5.0;
const double _borderThickness = 1.0;
const double _roleRowPadding = 3.0;
const double _nameRowVerticalPadding = 1.0;
const double _nameRowHorizontalPadding = 3.0;
const double _statPadding = 3.0;
const double _traitsSectionPadding = 3.0;
const double _weaponSectionPadding = 3.0;
const double _unitCardFooterPadding = 3.0;
const double _cardHeight = 300.0;
const double _cardWidth = 250.0;
const double? _section3Height = 65.0;
const double _combatStatsWidth = 50.0;
const double _secondaryStatsWidth = 80.0;
const double _hullWidth =
    (_cardWidth - _combatStatsWidth - _secondaryStatsWidth) / 2;
const double _standardFontSize = 12;
const double _weaponHeaderFontSize = 10;
const double _weaponFontSize = 8;
const double _traitFontSize = 10;
const double _nameFontSize = 16;
const double _unitCardFooterFontSize = 8;
const double _structureBlockWidth = 15;
const double _structureBlockHeight = 15;
const double _structureBlockSpacingWidth = 3.0;
const double _structureBlockSpacingHeight = 5.0;

const _reactSymbol = '»';

List<pw.Widget> buildUnitCards(
  pw.Font font,
  UnitRoster roster, {
  required String version,
}) {
  final List<pw.Widget> units = [];
  roster.getCGs().forEach((cg) {
    units.addAll(_buildGroupUnits(
      font,
      primaryUnits: cg.primary.allUnits(),
      secondaryUnits: cg.secondary.allUnits(),
      version: version,
    ));
  });
  units.addAll(_buildGroupUnits(font,
      primaryUnits: roster.airStrikes.keys.toList(),
      secondaryUnits: [],
      version: version));
  return units;
}

List<pw.Widget> _buildGroupUnits(
  pw.Font font, {
  required List<Unit> primaryUnits,
  required List<Unit> secondaryUnits,
  required String version,
}) {
  final List<pw.Widget> groupCards = [];

  groupCards.addAll(_buildUnitCards(font, primaryUnits, version: version));
  groupCards.addAll(_buildUnitCards(font, secondaryUnits, version: version));

  return groupCards;
}

List<pw.Widget> _buildUnitCards(
  pw.Font font,
  List<Unit> units, {
  required String version,
}) {
  return units.map((us) => _buildUnitCard(font, us, version: version)).toList();
}

pw.Widget _buildUnitCard(
  pw.Font font,
  Unit u, {
  required String version,
}) {
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
        pw.Expanded(child: _buildWeaponsSection(font, u.weapons)),
        pw.Container(
          alignment: pw.Alignment.bottomCenter,
          child: pw.Text(
            'Created using Gearforce $version',
            style: pw.TextStyle(
                color: PdfColors.grey, fontSize: _unitCardFooterFontSize),
          ),
          padding: pw.EdgeInsets.only(bottom: _unitCardFooterPadding),
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

pw.Widget _buildFirstSection(pw.Font font, Unit u) {
  return pw.Container(
    padding: pw.EdgeInsets.symmetric(
      vertical: _nameRowVerticalPadding,
      horizontal: _nameRowHorizontalPadding,
    ),
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
            'Roles: ${u.role() != null ? u.role()!.roles.join(', ') : '-'}',
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
            'Type: ${u.type} ${u.core.height == '-' ? '' : u.core.height}',
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
    padding: pw.EdgeInsets.all(_traitsSectionPadding),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(),
    ),
  );
}

pw.Widget _buildWeaponsSection(pw.Font font, List<Weapon> weapons) {
  final rows = weapons.map((w) => _buildWeaponRow(font, w)).toList();
  final headerRow = pw.TableRow(children: [
    pw.Padding(
      padding: pw.EdgeInsets.only(right: 5.0),
      child: pw.Text(
        'Code',
        style: pw.TextStyle(
          font: font,
          fontSize: _weaponHeaderFontSize,
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
          fontSize: _weaponHeaderFontSize,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    ),
    pw.Padding(
      padding: pw.EdgeInsets.only(right: 5.0, left: 5.0),
      child: pw.Text(
        'Dam',
        style: pw.TextStyle(
          font: font,
          fontSize: _weaponHeaderFontSize,
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
          fontSize: _weaponHeaderFontSize,
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
          fontSize: _weaponHeaderFontSize,
          fontWeight: pw.FontWeight.bold,
        ),
        textAlign: pw.TextAlign.center,
      ),
    ),
  ]);

  final Map<int, pw.TableColumnWidth> columnWidths = {3: pw.FlexColumnWidth()};

  return pw.Container(
    alignment: pw.Alignment.topLeft,
    padding: pw.EdgeInsets.all(_weaponSectionPadding),
    child: pw.Table(
      children: [headerRow, ...rows],
      columnWidths: columnWidths,
    ),
    decoration: pw.BoxDecoration(),
  );
}

pw.TableRow _buildWeaponRow(pw.Font font, Weapon w) {
  return pw.TableRow(children: [
    pw.Padding(
      padding: pw.EdgeInsets.only(right: 5.0),
      child: _buildWeaponName(font, w),
    ),
    pw.Padding(
      padding: pw.EdgeInsets.only(),
      child: _buildWeaponRange(font, w),
    ),
    pw.Padding(
      padding: pw.EdgeInsets.only(right: 5.0, left: 5.0),
      child: _buildWeaponDamage(font, w),
    ),
    pw.Padding(
      padding: pw.EdgeInsets.only(),
      child: _buildWeaponTraits(font, w),
    ),
    pw.Padding(
      padding: pw.EdgeInsets.only(),
      child: _buildWeaponModes(font, w),
    ),
  ]);
}

pw.Widget _buildWeaponName(pw.Font font, Weapon w) {
  final nameField = _buildWeaponField(
    font,
    '${w.hasReact ? _reactSymbol : ''}${w.numberOf >= 2 ? '2 x ' : ''}${w.abbreviation}',
  );

  if (!w.isCombo) {
    return nameField;
  }

  return pw.Container(
    padding: pw.EdgeInsets.only(left: 2.0),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [nameField, _buildWeaponName(font, w.combo!)],
    ),
    decoration: pw.BoxDecoration(
      border: pw.Border(
        top: pw.BorderSide(
          width: 1.0,
        ),
        bottom: pw.BorderSide(
          width: 1.0,
        ),
        left: pw.BorderSide(
          width: 1.0,
        ),
      ),
    ),
  );
}

pw.Widget _buildWeaponRange(pw.Font font, Weapon w) {
  final rangeField = _buildWeaponField(
    font,
    w.range.toString(),
  );

  if (!w.isCombo) {
    return rangeField;
  }

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.center,
    children: [rangeField, _buildWeaponRange(font, w.combo!)],
  );
}

pw.Widget _buildWeaponDamage(pw.Font font, Weapon w) {
  final damageField = _buildWeaponField(font, w.damage.toString(),
      textAlign: pw.TextAlign.center);

  if (!w.isCombo) {
    return damageField;
  }

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.center,
    children: [damageField, _buildWeaponDamage(font, w.combo!)],
  );
}

pw.Widget _buildWeaponTraits(pw.Font font, Weapon w) {
  final traits1 = w.traits.join(', ');
  final traits2 = w.alternativeTraits.join(', ');
  final traitField = _buildWeaponField(
    font,
    traits2.isEmpty ? traits1 : "$traits1 or $traits2",
  );
  if (!w.isCombo) {
    return traitField;
  }

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [traitField, _buildWeaponTraits(font, w.combo!)],
  );
}

pw.Widget _buildWeaponModes(pw.Font font, Weapon w) {
  final modeField = _buildWeaponField(
      font, w.modes.map((e) => getWeaponModeName(e)[0]).join(', '),
      textAlign: pw.TextAlign.center);

  if (!w.isCombo) {
    return modeField;
  }

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.center,
    children: [modeField, _buildWeaponModes(font, w.combo!)],
  );
}

pw.Widget _buildWeaponField(
  pw.Font font,
  String text, {
  pw.TextAlign? textAlign,
}) {
  return pw.Text(
    text,
    style: pw.TextStyle(font: font, fontSize: _weaponFontSize),
    textAlign: textAlign,
  );
}
