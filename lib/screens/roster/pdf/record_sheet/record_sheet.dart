import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/screens/roster/pdf/record_sheet/combat_groups.dart';
import 'package:gearforce/screens/roster/pdf/record_sheet/header.dart';
import 'package:pdf/widgets.dart' as pw;

final sectionDivide = pw.Padding(padding: pw.EdgeInsets.only(bottom: 10.0));
const double _airStrikeTableHeaderHeight = 15.0;
const double _airStrikeTableCellHeight = 10.0;
const double _standardTextSize = 10;
const double _borderThickness = 0.5;

List<pw.Widget> buildRecordSheet(pw.Font font, UnitRoster roster) {
  return [
    buildRosterHeader(font, roster),
    sectionDivide,
    ...buildCombatGroups(font, roster),
    _buildAirstrikeDisplay(font, roster),
  ];
}

pw.Widget _buildAirstrikeDisplay(pw.Font font, UnitRoster roster) {
  if (roster.airStrikes.isEmpty) {
    return pw.Container();
  }
  const tableHeaders = [
    'Airstrike Counter',
    'Number of',
    'TV',
    'Total TV',
  ];

  return pw.Table.fromTextArray(
    border: const pw.TableBorder(
      left: pw.BorderSide(width: _borderThickness),
      right: pw.BorderSide(width: _borderThickness),
      top: pw.BorderSide(width: _borderThickness),
      bottom: pw.BorderSide(width: _borderThickness),
    ),
    headerHeight: _airStrikeTableHeaderHeight,
    cellHeight: _airStrikeTableCellHeight,
    cellAlignments: {
      0: pw.Alignment.centerLeft,
      1: pw.Alignment.center,
      2: pw.Alignment.center,
      3: pw.Alignment.center,
    },
    data: List<List<String>>.generate(
      roster.airStrikes.length,
      (row) => List<String>.generate(tableHeaders.length, (col) {
        final unit = roster.airStrikes.keys.toList()[row];
        final count = roster.airStrikes[unit];
        switch (col) {
          case 0:
            return unit.name;
          case 1:
            return '$count';
          case 2:
            return '${unit.tv}';
          case 3:
            return '${unit.tv * count!}';
          default:
            return '';
        }
      }),
    ),
    headerDecoration: pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(width: _borderThickness),
      ),
    ),
    headers: List<String>.generate(
      tableHeaders.length,
      (col) => tableHeaders[col],
    ),
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
    tableWidth: pw.TableWidth.min,
  );
}
