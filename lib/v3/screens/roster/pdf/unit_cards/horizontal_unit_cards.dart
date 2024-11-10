import 'package:gearforce/v3/models/roster/roster.dart';
import 'package:gearforce/v3/models/traits/trait.dart';
import 'package:gearforce/v3/models/unit/command.dart';
import 'package:gearforce/v3/models/unit/unit.dart';
import 'package:gearforce/v3/models/weapons/weapon.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

const double _cornerRadius = 5.0;
const double _borderThickness = 1.0;
const double _roleRowPadding = 2.0;
const double _nameRowVerticalPadding = 1.0;
const double _nameRowHorizontalPadding = 3.0;
const double _traitsSectionPadding = 3.0;
const pw.EdgeInsets _weaponSectionPadding =
    pw.EdgeInsets.only(left: 3.0, right: 3.0);
const double _unitCardFooterPadding = 1.5;
const double _cardHeight = PdfPageFormat.inch * 3.33;
const double _cardWidth = PdfPageFormat.inch * 3.75;
const _combatStatsWidth = 42.0;
const double _statSectionHeight = 48;
const double _hullStructureNameWidth = 12.0;
const double _standardFontSize = 10;
const double _weaponHeaderFontSize = 10;
const double _weaponFontSize = 8;
const double _traitFontSize = 8;
const double _nameFontSize = 12;
const double _unitCardFooterFontSize = 6;

const _reactSymbol = '»';

List<pw.Widget> buildHorizontalUnitCards(
  pw.Font font,
  UnitRoster roster, {
  required bool isExtendedContentAllowed,
  required bool isAlphaBetaAllowed,
  required String version,
}) {
  final List<pw.Widget> units = [];
  roster.getCGs().forEach((cg) {
    units.addAll(_buildGroupUnits(
      font,
      primaryUnits: cg.primary.allUnits(),
      secondaryUnits: cg.secondary.allUnits(),
      isExtendedContentAllowed: isExtendedContentAllowed,
      isAlphaBetaAllowed: isAlphaBetaAllowed,
      version: version,
    ));
  });

  return units;
}

List<pw.Widget> _buildGroupUnits(
  pw.Font font, {
  required List<Unit> primaryUnits,
  required List<Unit> secondaryUnits,
  required bool isExtendedContentAllowed,
  required bool isAlphaBetaAllowed,
  required String version,
}) {
  final List<pw.Widget> groupCards = [];

  groupCards.addAll(_buildUnitCards(
    font,
    primaryUnits,
    version: version,
    isExtendedContentAllowed: isExtendedContentAllowed,
    isAlphaBetaAllowed: isAlphaBetaAllowed,
  ));
  groupCards.addAll(_buildUnitCards(
    font,
    secondaryUnits,
    version: version,
    isExtendedContentAllowed: isExtendedContentAllowed,
    isAlphaBetaAllowed: isAlphaBetaAllowed,
  ));

  return groupCards;
}

List<pw.Widget> _buildUnitCards(
  pw.Font font,
  List<Unit> units, {
  required bool isExtendedContentAllowed,
  required bool isAlphaBetaAllowed,
  required String version,
}) {
  return units
      .map((us) => _buildUnitCard(
            font,
            us,
            version: version,
            isExtendedContentAllowed: isExtendedContentAllowed,
            isAlphaBetaAllowed: isAlphaBetaAllowed,
          ))
      .toList();
}

pw.Widget _buildUnitCard(
  pw.Font font,
  Unit u, {
  required bool isExtendedContentAllowed,
  required bool isAlphaBetaAllowed,
  required String version,
}) {
  final rulesVersion = u.roster?.rulesVersion;
  var rulesVersionText = rulesVersion != null ? 'Rules: $rulesVersion' : '';
  if (isExtendedContentAllowed) {
    rulesVersionText += ' + Extended Content';
  }
  if (isAlphaBetaAllowed) {
    rulesVersionText += ' + Alpha/Beta';
  }

  final card = pw.Container(
    width: _cardWidth,
    height: _cardHeight,
    child: pw.Row(
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              _buildNameSection(font, u),
              _buildCGandTVSection(font, u),
              _buildStatSection(font, u),
              _buildTraitsSection(font, u.traits),
              pw.Expanded(child: _buildWeaponsSection(font, u.weapons)),
              pw.Padding(
                  padding: const pw.EdgeInsets.only(
                    left: 5.0,
                    right: 5.0,
                    bottom: _unitCardFooterPadding,
                  ),
                  child: pw.Row(
                    children: [
                      pw.Text(
                        'Gearforce $version',
                        maxLines: 1,
                        softWrap: true,
                        style: const pw.TextStyle(
                            color: PdfColors.grey,
                            fontSize: _unitCardFooterFontSize),
                      ),
                      pw.Spacer(),
                      pw.Text(
                        rulesVersionText,
                        style: const pw.TextStyle(
                            color: PdfColors.grey,
                            fontSize: _unitCardFooterFontSize),
                      ),
                    ],
                  ))
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

  return card;
}

pw.Widget _buildNameSection(pw.Font font, Unit u) {
  return pw.Container(
    padding: const pw.EdgeInsets.symmetric(
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
    ]),
    decoration: const pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(
          width: _borderThickness,
        ),
      ),
    ),
  );
}

pw.Widget _buildCGandTVSection(pw.Font font, Unit u) {
  return pw.Container(
    padding:
        const pw.EdgeInsets.only(top: _roleRowPadding, bottom: _roleRowPadding),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.only(left: 3.0),
          child: pw.Text(
            u.combatGroup?.name ?? 'not part of a CG',
            style: const pw.TextStyle(fontSize: _standardFontSize),
            textAlign: pw.TextAlign.left,
          ),
        ),
        pw.Spacer(),
        pw.Container(
          padding: const pw.EdgeInsets.only(right: 3.0),
          child: pw.Text(
            'TV: ${u.tv}',
            style: const pw.TextStyle(fontSize: _standardFontSize),
            textAlign: pw.TextAlign.right,
          ),
        ),
      ],
    ),
    decoration: const pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(
          width: _borderThickness,
        ),
      ),
    ),
  );
}

pw.Widget _buildStatSection(pw.Font font, Unit u) {
  return pw.Container(
    height: _statSectionHeight,
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildFirstStatBlock(font, u),
        _buildSecondStatBlock(font, u),
        _buildSecondaryStatBlock(font, u)
      ],
    ),
    decoration: const pw.BoxDecoration(
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
    width: _combatStatsWidth,
    padding: const pw.EdgeInsets.fromLTRB(3.0, 2.0, 3.0, 2.0),
    child: pw.Table(
      columnWidths: {
        0: const pw.FixedColumnWidth(nameColumnSize),
        1: const pw.FlexColumnWidth(),
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
      ],
    ),
    decoration: const pw.BoxDecoration(
      border: pw.Border(
        right: pw.BorderSide(
          width: _borderThickness,
        ),
      ),
    ),
  );
}

pw.Widget _buildSecondStatBlock(pw.Font font, Unit u) {
  final textStyle = pw.TextStyle(font: font, fontSize: _standardFontSize);
  const nameColumnSize = 21.0;
  return pw.Container(
    alignment: pw.Alignment.topCenter,
    width: _combatStatsWidth,
    padding: const pw.EdgeInsets.fromLTRB(3.0, 2.0, 3.0, 2.0),
    child: pw.Table(
      columnWidths: {
        0: const pw.FixedColumnWidth(nameColumnSize),
        1: const pw.FlexColumnWidth(),
      },
      children: [
        _buildPrimaryStatRow(
          textStyle,
          'Arm:',
          '${u.armor ?? ' - '}',
        ),
        _buildPrimaryStatRow(
          textStyle,
          'A:',
          '${u.actions ?? ' - '}',
        ),
        _buildPrimaryStatRow(
          textStyle,
          '${u.commandLevel == CommandLevel.none ? 'SP' : 'CP'}:',
          '${u.commandLevel == CommandLevel.none ? u.skillPoints : u.commandPoints}',
        ),
      ],
    ),
    decoration: const pw.BoxDecoration(
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
        padding: const pw.EdgeInsets.only(left: 2.0),
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

  final typeBlock = pw.Container(
    child: pw.Padding(
      padding: const pw.EdgeInsets.only(
          left: 4.0, top: 1.0, bottom: 1.0, right: 4.0),
      child: pw.Row(
        children: [
          pw.Text(
            u.type.name,
            style: textStyle,
            textAlign: pw.TextAlign.left,
          ),
          pw.Spacer(),
          pw.Text(
            u.core.height == '-' ? '' : '${u.core.height}"',
            style: textStyle,
            textAlign: pw.TextAlign.left,
          ),
        ],
      ),
    ),
    decoration: const pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(
          width: _borderThickness,
        ),
      ),
    ),
  );

  final block = pw.Container(
    decoration: const pw.BoxDecoration(),
    child: pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: [
        typeBlock,
        pw.Row(children: [
          _buildCommandAndMovementBlock(font, u),
          _buildStructureAndHullBlock(font, u),
        ], mainAxisAlignment: pw.MainAxisAlignment.spaceAround),
      ],
    ),
  );

  return pw.Expanded(child: block);
}

pw.Widget _buildCommandAndMovementBlock(pw.Font font, Unit u) {
  final textStyle = pw.TextStyle(font: font, fontSize: _standardFontSize);
  const blockWidth = 70.0;
  const attributeNameWidth = 23.0;

  final commandBlock = pw.Row(children: [
    pw.Container(
      child: pw.Text(
        'Cmd: ',
        style: textStyle,
        textAlign: pw.TextAlign.left,
      ),
    ),
    pw.Padding(
      padding: const pw.EdgeInsets.only(left: 2.0),
      child: pw.Text(
        u.commandLevel == CommandLevel.none
            ? ' - '
            : '${u.commandLevel.name}${u.roster?.selectedForceLeader == u ? '**' : ''}',
        style: textStyle,
        textAlign: pw.TextAlign.left,
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
        padding: const pw.EdgeInsets.only(left: 2.0),
        child: pw.Text(
          '${u.movement ?? ' - '}',
          style: textStyle,
          textAlign: pw.TextAlign.left,
        ),
      ),
    ],
  );

  final block = pw.Container(
    padding:
        const pw.EdgeInsets.only(top: 2.0, bottom: 2.0, right: 3.0, left: 3.0),
    width: blockWidth,
    child: pw.Column(children: [
      commandBlock,
      movementBlock,
    ]),
    decoration: const pw.BoxDecoration(
      border: pw.Border(
        right: pw.BorderSide(
          width: _borderThickness,
        ),
      ),
    ),
  );
  return block;
}

pw.Widget _buildStructureAndHullBlock(pw.Font font, Unit u) {
  final textStyle = pw.TextStyle(font: font, fontSize: _standardFontSize);

  final hullBlock = pw.Row(
    children: [
      pw.Container(
        child: pw.Text('H:', style: textStyle, textAlign: pw.TextAlign.right),
        width: _hullStructureNameWidth,
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.only(left: 2.0),
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
        child: pw.Text('S:', style: textStyle, textAlign: pw.TextAlign.right),
        width: _hullStructureNameWidth,
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.only(left: 2.0),
        child: pw.Text(
          _cheapHS(u.structure),
          style: textStyle,
          textAlign: pw.TextAlign.left,
        ),
      ),
    ],
  );

  final block = pw.Container(
    padding:
        const pw.EdgeInsets.only(top: 2.0, bottom: 2.0, right: 3.0, left: 3.0),
    child: pw.Column(children: [
      hullBlock,
      structureBlock,
    ]),
    decoration: const pw.BoxDecoration(),
  );
  return pw.Expanded(child: block);
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
    padding: const pw.EdgeInsets.all(_traitsSectionPadding),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(),
    ),
  );
}

pw.Widget _buildWeaponsSection(pw.Font font, List<Weapon> weapons) {
  final List<pw.TableRow> rows = [];
  for (var w in weapons) {
    rows.add(_buildWeaponRow(font, w));
    if (w.isCombo && w.combo != null) {
      rows.add(_buildWeaponRow(font, w.combo!));
    }
  }
  final headerRow = pw.TableRow(children: [
    pw.Padding(
      padding: const pw.EdgeInsets.only(right: 5.0),
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
      padding: const pw.EdgeInsets.only(),
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
      padding: const pw.EdgeInsets.only(right: 5.0, left: 5.0),
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
      padding: const pw.EdgeInsets.only(),
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
      padding: const pw.EdgeInsets.only(),
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

  final Map<int, pw.TableColumnWidth> columnWidths = {
    3: const pw.FlexColumnWidth()
  };

  return pw.Container(
    alignment: pw.Alignment.topLeft,
    padding: _weaponSectionPadding,
    child: pw.Table(
      children: [headerRow, ...rows],
      columnWidths: columnWidths,
    ),
    decoration: const pw.BoxDecoration(),
  );
}

pw.TableRow _buildWeaponRow(pw.Font font, Weapon w) {
  return pw.TableRow(children: [
    pw.Padding(
      padding: const pw.EdgeInsets.only(right: 5.0),
      child: _buildWeaponName(font, w),
    ),
    pw.Padding(
      padding: const pw.EdgeInsets.only(),
      child: _buildWeaponRange(font, w),
    ),
    pw.Padding(
      padding: const pw.EdgeInsets.only(right: 5.0, left: 5.0),
      child: _buildWeaponDamage(font, w),
    ),
    pw.Padding(
      padding: const pw.EdgeInsets.only(),
      child: _buildWeaponTraits(font, w),
    ),
    pw.Padding(
      padding: const pw.EdgeInsets.only(),
      child: _buildWeaponModes(font, w),
    ),
  ]);
}

pw.Widget _buildWeaponName(pw.Font font, Weapon w) {
  final nameField = _buildWeaponField(
    font,
    '${w.hasReact ? _reactSymbol : ''}${w.numberOf >= 2 ? '2 x ' : ''}${w.abbreviation}',
  );

  return nameField;
}

pw.Widget _buildWeaponRange(pw.Font font, Weapon w) {
  final rangeField = _buildWeaponField(
    font,
    w.range.toString(),
  );

  return rangeField;
}

pw.Widget _buildWeaponDamage(pw.Font font, Weapon w) {
  final damageField = _buildWeaponField(font, w.damage.toString(),
      textAlign: pw.TextAlign.center);

  return damageField;
}

pw.Widget _buildWeaponTraits(pw.Font font, Weapon w) {
  final traits1 = w.traits.join(', ');
  final traits2 = w.alternativeTraits.join(', ');
  final traitField = _buildWeaponField(
    font,
    traits2.isEmpty ? traits1 : '[$traits1] or [$traits2]',
  );
  return traitField;
}

pw.Widget _buildWeaponModes(pw.Font font, Weapon w) {
  final modeField = _buildWeaponField(
      font, w.modes.map((m) => m.abbr).join(', '),
      textAlign: pw.TextAlign.center);

  return modeField;
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
