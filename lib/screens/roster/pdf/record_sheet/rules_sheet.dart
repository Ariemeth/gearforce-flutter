import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/rule.dart';
import 'package:pdf/widgets.dart' as pw;

const double _headerTextSize = 12;
const double _standardTextSize = 10;

pw.Widget buildRulesSheet(
  pw.Font font,
  UnitRoster roster, {
  bool includeFactionRules = true,
  bool includeSubFactionRules = true,
}) {
  final List<(String, String)> factionRules = [];
  if (includeFactionRules) {
    Rule.enabledRules(roster.rulesetNotifer.value.factionRules).forEach((fr) {
      factionRules.add((fr.name, fr.description));
    });
  }

  final List<(String, String)> subFactionRules = [];
  if (includeSubFactionRules) {
    Rule.enabledRules(roster.rulesetNotifer.value.subFactionRules)
        .forEach((fr) {
      subFactionRules.add((fr.name, fr.description));
    });
  }

  final rules = [
    _buildRuleTable(font, ['Faction Rule', 'Description'], factionRules),
    _buildRuleTable(font, ['Sub-Faction Rule', 'Description'], subFactionRules),
  ];

  if (roster.rulesetNotifer.value.alphaBetaRules.isNotEmpty) {
    final List<(String, String)> alphaBetaRules = [];
    Rule.enabledRules(roster.rulesetNotifer.value.alphaBetaRules).forEach((fr) {
      alphaBetaRules.add((fr.name, fr.description));
    });
    rules.add(_buildRuleTable(
        font, ['Alpha-Beta Rule', 'Description'], alphaBetaRules));
  }

  final sheet = pw.Column(children: rules);

  return pw.Padding(
    padding: pw.EdgeInsets.only(
      left: 10.0,
      right: 10.0,
      top: 10.0,
      bottom: 10.0,
    ),
    child: sheet,
  );
}

pw.Widget _buildRuleTable(
  pw.Font font,
  List<String> tableHeaders,
  List<(String, String)> rules,
) {
  if (rules.isEmpty) {
    return pw.Container();
  }
  var table = pw.TableHelper.fromTextArray(
    cellStyle: pw.TextStyle(
      font: font,
      fontSize: _standardTextSize,
    ),
    columnWidths: {
      0: const pw.FixedColumnWidth(200.0),
    },
    headers: tableHeaders,
    headerStyle: pw.TextStyle(
      font: font,
      fontSize: _headerTextSize,
      fontWeight: pw.FontWeight.bold,
    ),
    data: List<List<String>>.generate(
      rules.length,
      (row) => List<String>.generate(tableHeaders.length, (col) {
        switch (col) {
          case 0:
            return rules[row].$1;
          case 1:
            return rules[row].$2;
          default:
            return '';
        }
      }),
    ),
  );
  return pw.Padding(
      padding: pw.EdgeInsets.only(
        bottom: 10.0,
      ),
      child: table);
}
