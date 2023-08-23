import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/command.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/weapons/weapon.dart';
import 'package:gearforce/models/weapons/weapon_modes.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

const double _cornerRadius = 5.0;
const double _borderThickness = 1.0;
const double _roleRowPadding = 2.0;
const double _nameRowVerticalPadding = 1.0;
const double _nameRowHorizontalPadding = 3.0;
const double _traitsSectionPadding = 3.0;
const double _weaponSectionPadding = 3.0;
const double _unitCardFooterPadding = 3.0;
const double _cardHeight = PdfPageFormat.inch * 3.5;
const double _cardWidth = PdfPageFormat.inch * 2.5;
const double? _section3Height = 73.0;
const double _standardFontSize = 10;
const double _weaponHeaderFontSize = 10;
const double _weaponFontSize = 8;
const double _traitFontSize = 8;
const double _nameFontSize = 12;
const double _unitCardFooterFontSize = 6;

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
  final rulesVersion = u.roster?.rulesVersion;
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
            'Gearforce $version${rulesVersion != null ? '; Rules: $rulesVersion' : ''}',
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
    child: pw.Row(children: [
      pw.Expanded(
        child: pw.Text(
          u.name,
          style: pw.TextStyle(
            fontSize: _nameFontSize,
            font: font,
            fontWeight: pw.FontWeight.bold,
          ),
          textAlign: pw.TextAlign.center,
        ),
      ),
      pw.Text(
        u.commandLevel != CommandLevel.none ? u.commandLevel.name : '',
        style: pw.TextStyle(
          fontSize: _nameFontSize,
          font: font,
          fontWeight: pw.FontWeight.bold,
        ),
        textAlign: pw.TextAlign.right,
      ),
    ]),
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
      mainAxisAlignment: pw.MainAxisAlignment.start,
      children: [
        pw.Container(
          padding: pw.EdgeInsets.only(left: 3.0),
          child: pw.Text(
            u.combatGroup?.name ?? 'not part of a CG',
            style: pw.TextStyle(fontSize: _standardFontSize),
            textAlign: pw.TextAlign.left,
          ),
        ),
        pw.Spacer(),
        pw.Container(
          padding: pw.EdgeInsets.only(right: 3.0),
          child: pw.Text(
            'TV: ${u.tv}',
            style: pw.TextStyle(fontSize: _standardFontSize),
            textAlign: pw.TextAlign.right,
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
      mainAxisAlignment: pw.MainAxisAlignment.start,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildFirstStatBlock(font, u),
        _buildSecondaryStatBlock(font, u),
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
  const nameColumnSize = 21.0;
  return pw.Container(
    alignment: pw.Alignment.topCenter,
    width: 42.0, //_combatStatsWidth,
    padding: pw.EdgeInsets.fromLTRB(3.0, 2.0, 3.0, 2.0),
    child: pw.Table(
      columnWidths: {
        0: pw.FixedColumnWidth(nameColumnSize),
        1: pw.FlexColumnWidth(),
      },
      children: [
        _buildPrimaryStatRow(
          textStyle,
          'Gu:',
          '${u.gunnery ?? ' - '}${u.gunnery != null ? '+' : ''}',
        ),
        _buildPrimaryStatRow(
          textStyle,
          'Pi:',
          '${u.piloting ?? ' - '}${u.piloting != null ? '+' : ''}',
        ),
        _buildPrimaryStatRow(
          textStyle,
          'Ew:',
          '${u.ew ?? ' - '}${u.ew != null ? '+' : ''}',
        ),
        _buildPrimaryStatRow(
          textStyle,
          'A:',
          '${u.actions ?? ' - '}',
        ),
        _buildPrimaryStatRow(
          textStyle,
          'Arm:',
          '${u.armor ?? ' - '}',
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

pw.TableRow _buildPrimaryStatRow(
    pw.TextStyle textStyle, String stat, String value) {
  final row = pw.TableRow(
    children: [
      pw.Text(stat, style: textStyle, textAlign: pw.TextAlign.right),
      pw.Padding(
        padding: pw.EdgeInsets.only(left: 2.0),
        child: pw.Text(
          value,
          style: textStyle,
          textAlign: pw.TextAlign.left,
        ),
      ),
    ],
  );

  return row;
}

pw.Widget _buildSecondaryStatBlock(pw.Font font, Unit u) {
  final textStyle = pw.TextStyle(font: font, fontSize: _standardFontSize);
  const blockWidth = _cardWidth - 42;
  const attributeNameWidth = 23.0;

  final typeBlock = pw.Row(children: [
    pw.Text(
      u.type.name,
      style: textStyle,
      textAlign: pw.TextAlign.left,
    ),
    pw.Text(
      '${u.core.height == '-' ? '' : ': ${u.core.height}"'}',
      style: textStyle,
      textAlign: pw.TextAlign.left,
    ),
  ]);

  final commandBlock = pw.Row(children: [
    pw.Container(
      width: attributeNameWidth,
      child: pw.Text(
        'Cmd: ',
        style: textStyle,
        textAlign: pw.TextAlign.left,
      ),
    ),
    pw.Padding(
      padding: pw.EdgeInsets.only(left: 2.0),
      child: pw.Text(
        u.commandLevel == CommandLevel.none ? ' - ' : u.commandLevel.name,
        style: textStyle,
        textAlign: pw.TextAlign.left,
      ),
    ),
    pw.Spacer(),
    pw.Text(
      '${u.commandLevel == CommandLevel.none ? 'SP' : 'CP'}:',
      style: textStyle,
      textAlign: pw.TextAlign.right,
    ),
    pw.Padding(
      padding: pw.EdgeInsets.only(right: 2.0),
      child: pw.Text(
        ' ${u.commandLevel == CommandLevel.none ? u.skillPoints : u.commandPoints}',
        style: textStyle,
        textAlign: pw.TextAlign.right,
      ),
    ),
  ]);

  final movementBlock = pw.Row(
    children: [
      pw.Container(
        width: attributeNameWidth,
        child: pw.Text('MR:', style: textStyle, textAlign: pw.TextAlign.right),
      ),
      pw.Padding(
        padding: pw.EdgeInsets.only(left: 2.0),
        child: pw.Text(
          '${u.movement ?? ' - '}',
          style: textStyle,
          textAlign: pw.TextAlign.left,
        ),
      ),
    ],
  );

  final hullBlock = pw.Row(
    children: [
      pw.Container(
        width: attributeNameWidth,
        child: pw.Text('H:', style: textStyle, textAlign: pw.TextAlign.right),
      ),
      pw.Padding(
        padding: pw.EdgeInsets.only(left: 2.0),
        child: pw.Text(
          _cheapHS(u.hull),
          style: textStyle,
          textAlign: pw.TextAlign.left,
        ),
      ),
    ],
  );

  final structureBlock = pw.Row(
    children: [
      pw.Container(
        width: attributeNameWidth,
        child: pw.Text('S:', style: textStyle, textAlign: pw.TextAlign.right),
      ),
      pw.Padding(
        padding: pw.EdgeInsets.only(left: 2.0),
        child: pw.Text(
          _cheapHS(u.structure),
          style: textStyle,
          textAlign: pw.TextAlign.left,
        ),
      ),
    ],
  );

  final block = pw.Container(
    padding: pw.EdgeInsets.only(top: 2.0, bottom: 2.0, right: 3.0, left: 3.0),
    width: blockWidth,
    child: pw.Column(children: [
      typeBlock,
      commandBlock,
      movementBlock,
      hullBlock,
      structureBlock,
      //  secondaryStatBlock,
    ]),
    decoration: pw.BoxDecoration(
      border: pw.Border(
        right: pw.BorderSide(
          width: _borderThickness,
        ),
      ),
    ),
  );
  return block;
}

String _cheapHS(int? num) {
  if (num == null || num == 0) {
    return '';
  }
  final r = 'O ' * num;
  return r;
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
        'D',
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
        'Mode',
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
    traits2.isEmpty ? traits1 : "[$traits1] or [$traits2]",
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
