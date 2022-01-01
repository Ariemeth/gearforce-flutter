import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/unit/command.dart';
import 'package:pdf/widgets.dart' as pw;

const double _standardTextSize = 12;
//const double _smallTextSize = 8;
const double _groupSpacing = 25.0;
const double _primarySecondarySpacing = 15.0;

final primarySecondaryDivide =
    pw.Padding(padding: pw.EdgeInsets.only(bottom: 5.0));

List<pw.Widget> buildCombatGroups(pw.Font font, UnitRoster roster) {
  final List<pw.Widget> combatGroups = [];
  roster.getCGs().forEach((cg) {
    combatGroups.add(buildCombatGroup(font, cg));
  });
  return combatGroups;
}

pw.Widget buildCombatGroup(pw.Font font, CombatGroup cg) {
  if (cg.primary.allUnits().length == 0) {
    return pw.Container();
  }

  final headerTextStyle = pw.TextStyle(
    font: font,
    fontSize: _standardTextSize,
    fontWeight: pw.FontWeight.bold,
  );
  //final smallTextStyle = pw.TextStyle(font: font, fontSize: _smallTextSize);

  final primary = pw.Column(
    children: [
      pw.Row(
        children: [
          pw.Expanded(
              child: pw.Text(
            'Combat Group: ${cg.name} Primary',
            style: headerTextStyle,
          )),
          pw.Text(
            'TV: ',
            style: headerTextStyle,
          ),
          pw.Text(
            '${cg.primary.totalTV()}',
            style: headerTextStyle,
          ),
        ],
      ),
      _contentTable(cg.primary),
    ],
  );

  final secondary = pw.Column(
    children: [
      pw.Row(
        children: [
          pw.Expanded(
              child: pw.Text(
            'Combat Group: ${cg.name} Secondary',
            style: headerTextStyle,
          )),
          pw.Text(
            'TV: ',
            style: headerTextStyle,
          ),
          pw.Text(
            '${cg.secondary.totalTV()}',
            style: headerTextStyle,
          ),
        ],
      ),
      _contentTable(cg.secondary),
    ],
  );

  final result = pw.Column(children: [
    primary,
  ]);

  if (cg.secondary.allUnits().length > 0) {
    result.children.add(
      pw.Padding(
        padding: pw.EdgeInsets.only(top: _primarySecondarySpacing),
        child: secondary,
      ),
    );
  }

  return pw.Padding(
    padding: pw.EdgeInsets.only(bottom: _groupSpacing),
    child: result,
  );
}

pw.Widget _contentTable(Group cg) {
  const tableHeaders = [
    'Model',
    'Upgrades',
    'Actions',
    'Command',
    'TV',
  ];

  return pw.Table.fromTextArray(
    border: null,
    cellAlignment: pw.Alignment.centerLeft,
    headerDecoration: pw.BoxDecoration(
      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
      // color: baseColor,
    ),
    headerHeight: 25,
    cellHeight: 30,
    cellAlignments: {
      0: pw.Alignment.centerLeft,
      1: pw.Alignment.centerLeft,
      2: pw.Alignment.center,
      3: pw.Alignment.center,
      4: pw.Alignment.center,
    },
    headerStyle: pw.TextStyle(
      //  color: _baseTextColor,
      fontSize: 10,
      fontWeight: pw.FontWeight.bold,
    ),
    cellStyle: const pw.TextStyle(
      //  color: _darkColor,
      fontSize: 10,
    ),
    rowDecoration: pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(
          //      color: accentColor,
          width: .5,
        ),
      ),
    ),
    headers: List<String>.generate(
      tableHeaders.length,
      (col) => tableHeaders[col],
    ),
    columnWidths: {
      0: const pw.FixedColumnWidth(170),
      1: const pw.FlexColumnWidth(),
      2: const pw.FixedColumnWidth(50),
      3: const pw.FixedColumnWidth(60),
      4: const pw.FixedColumnWidth(30),
    },
    data: List<List<String>>.generate(
      cg.allUnits().length,
      (row) => List<String>.generate(tableHeaders.length, (col) {
        final unit = cg.allUnits()[row];
        switch (col) {
          case 0:
            return unit.name;
          case 1:
            return '';
          case 2:
            return '${unit.actions ?? ''}';
          case 3:
            return '${commandLevelString(unit.commandLevel)}';
          case 4:
            return '${unit.tv}';
          default:
            return '';
        }
      }
          // (col) => cg.allUnits()[row].getIndex(col),
          ),
    ),
  );
}
