import 'dart:math';

import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/unit/command.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:pdf/widgets.dart' as pw;

const double _headerTextSize = 12;
const double _standardTextSize = 10;
const double _smallTextSize = 8;
const double _groupSpacing = 20.0;
const double _primarySecondarySpacing = 10.0;
const double _tableHeaderHeight = 25.0;
const double _tableCellHeight = 20.0;
const double _modelNameColumnWidth = 150.0;
const double _commandNameColumnWidth = 40.0;
const double _actionsColumnWidth = 30.0;
const double _cpAndSpColumnWidth = 40.0;
const double _tvColumnWidth = 30.0;
const double _borderThickness = 0.5;
const double _cornerRadius = 2.0;

final primarySecondaryDivide =
    pw.Padding(padding: pw.EdgeInsets.only(bottom: 5.0));

List<pw.Widget> buildCombatGroups(pw.Font font, UnitRoster roster) {
  final List<pw.Widget> combatGroups = [];
  roster.getCGs().forEach((cg) {
    combatGroups.add(_buildCombatGroup(font, cg));
  });

  return combatGroups;
}

pw.Widget _buildCombatGroup(pw.Font font, CombatGroup cg) {
  if (cg.primary.allUnits().length == 0) {
    return pw.Container();
  }

  final result = pw.Column(children: [
    _buildCombatGroupHeader(
      font,
      GroupName: cg.name,
      groupType: GroupType.Primary,
      role: cg.primary.role(),
    ),
    _buildUnitsContent(
      font,
      units: cg.primary.allUnits(),
      actions: cg.primary.totalActions,
      tv: cg.primary.totalTV(),
      groupType: 'Primary',
    ),
  ]);

  if (cg.secondary.allUnits().length > 0) {
    result.children.addAll([
      pw.Padding(
        padding: pw.EdgeInsets.only(top: _primarySecondarySpacing),
        child: _buildCombatGroupHeader(
          font,
          GroupName: cg.name,
          groupType: GroupType.Secondary,
          role: cg.secondary.role(),
        ),
      ),
      _buildUnitsContent(
        font,
        units: cg.secondary.allUnits(),
        actions: cg.secondary.totalActions,
        tv: cg.secondary.totalTV(),
        groupType: 'Secondary',
      ),
    ]);
  }

  return pw.Padding(
    padding: pw.EdgeInsets.only(bottom: _groupSpacing),
    child: result,
  );
}

pw.Widget _buildCombatGroupHeader(
  pw.Font font, {
  required String GroupName,
  required GroupType groupType,
  required RoleType role,
}) {
  final headerTextStyle = pw.TextStyle(
    font: font,
    fontSize: _headerTextSize,
    fontWeight: pw.FontWeight.bold,
  );

  return pw.Padding(
    padding: pw.EdgeInsets.only(bottom: 2.5),
    child: pw.Row(
      children: [
        pw.Expanded(
          child: pw.Text(
            'Combat Group $GroupName',
            style: headerTextStyle,
            textAlign: pw.TextAlign.center,
          ),
        ),
        pw.Text(
          'Role: ${role.name}',
          style: headerTextStyle,
        ),
      ],
    ),
  );
}

pw.Widget _buildUnitsContent(
  pw.Font font, {
  required List<Unit> units,
  required int actions,
  required int tv,
  required String groupType,
}) {
  final smallTextStyle = pw.TextStyle(
    font: font,
    fontSize: _smallTextSize,
  );

  return pw.Column(
    children: [
      pw.Container(
        child: pw.Row(children: [
          pw.Padding(
            padding: pw.EdgeInsets.all(5.0),
            child: pw.Transform.rotateBox(
              angle: pi / 2,
              child: pw.Text(
                groupType,
                style: smallTextStyle,
                textAlign: pw.TextAlign.center,
              ),
            ),
          ),
          pw.Expanded(child: _buildUnitsContentTable(font, units)),
        ]),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(),
          borderRadius: const pw.BorderRadius.only(
            topLeft: pw.Radius.circular(_cornerRadius),
            topRight: pw.Radius.circular(_cornerRadius),
            bottomLeft: pw.Radius.circular(_cornerRadius),
          ),
        ),
      ),
      _buildUnitsFooter(font, actions: actions, tv: tv),
    ],
  );
}

pw.Widget _buildUnitsContentTable(pw.Font font, List<Unit> units) {
  const tableHeaders = [
    'Model',
    'Upgrades',
    'Rank',
    'CP/SP',
    'Act',
    'TV',
  ];

  return pw.TableHelper.fromTextArray(
    border: null,
    cellAlignment: pw.Alignment.centerLeft,
    headerDecoration: pw.BoxDecoration(
      border: pw.Border(
        left: pw.BorderSide(width: _borderThickness),
        //      color: accentColor,
      ),
    ),
    headerHeight: _tableHeaderHeight,
    cellHeight: _tableCellHeight,
    cellAlignments: {
      0: pw.Alignment.centerLeft,
      1: pw.Alignment.centerLeft,
      2: pw.Alignment.center,
      3: pw.Alignment.center,
      4: pw.Alignment.center,
      5: pw.Alignment.center,
    },
    headerStyle: pw.TextStyle(
      //  color: _baseTextColor,
      font: font,
      fontSize: _standardTextSize,
      fontWeight: pw.FontWeight.bold,
    ),
    cellStyle: pw.TextStyle(
      //  color: _darkColor,
      font: font,
      fontSize: _standardTextSize,
    ),
    rowDecoration: pw.BoxDecoration(
      border: pw.Border(
        top: pw.BorderSide(width: _borderThickness),
        left: pw.BorderSide(width: _borderThickness),
      ),
    ),
    headers: List<String>.generate(
      tableHeaders.length,
      (col) => tableHeaders[col],
    ),
    columnWidths: {
      0: const pw.FixedColumnWidth(_modelNameColumnWidth),
      1: const pw.FlexColumnWidth(2.0),
      2: const pw.FixedColumnWidth(_commandNameColumnWidth),
      3: const pw.FixedColumnWidth(_cpAndSpColumnWidth),
      4: const pw.FixedColumnWidth(_actionsColumnWidth),
      5: const pw.FixedColumnWidth(_tvColumnWidth),
    },
    data: List<List<String>>.generate(
      units.length,
      (row) => List<String>.generate(tableHeaders.length, (col) {
        final unit = units[row];
        switch (col) {
          case 0:
            return unit.name;
          case 1:
            return '${unit.modNamesWithCost.join(', ')}';
          case 2:
            if (unit.commandLevel == CommandLevel.none) {
              return '-';
            }
            final isForceleader = unit.roster?.selectedForceLeader == unit;
            if (isForceleader) {
              return '${unit.commandLevel.name}**';
            }
            return '${unit.commandLevel.name}';
          case 3:
            return '${unit.commandLevel == CommandLevel.none ? unit.skillPoints : unit.commandPoints}';
          case 4:
            return '${unit.actions ?? '-'}';
          case 5:
            return '${unit.tv}';
          default:
            return '';
        }
      }),
    ),
  );
}

pw.Widget _buildUnitsFooter(
  pw.Font font, {
  required int actions,
  required int tv,
}) {
  final footerTextStyle = pw.TextStyle(
    //  color: _darkColor,
    font: font,
    fontSize: _standardTextSize,
  );

  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.end,
    children: [
      pw.Container(
        child: pw.Padding(
          padding: pw.EdgeInsets.only(top: 5.0),
          child: pw.Row(
            children: [
              pw.Container(
                width: _commandNameColumnWidth,
                child: pw.Text(
                  'Total:',
                  textAlign: pw.TextAlign.right,
                  style: footerTextStyle,
                ),
              ),
              pw.Container(
                width: _actionsColumnWidth,
                child: pw.Text(
                  '${actions}',
                  textAlign: pw.TextAlign.center,
                  style: footerTextStyle,
                ),
              ),
              pw.Container(
                width: _tvColumnWidth,
                child: pw.Text(
                  '${tv}',
                  textAlign: pw.TextAlign.center,
                  style: footerTextStyle,
                ),
              ),
            ],
          ),
        ),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(width: _borderThickness),
          borderRadius: const pw.BorderRadius.only(
            bottomRight: pw.Radius.circular(_cornerRadius),
            bottomLeft: pw.Radius.circular(_cornerRadius),
          ),
        ),
      ),
    ],
  );
}
