import 'package:gearforce/models/unit/unit.dart';
import 'package:pdf/widgets.dart' as pw;

const double _headerTextSize = 12;
const double _standardTextSize = 10;

pw.Widget buildTraitSheet(pw.Font font, List<Unit> units) {
  const tableHeaders = [
    'Trait',
    'Description',
  ];

  final Map<String, String> allTraits = Map();
  units.forEach((unit) {
    unit.traits.forEach((trait) {
      allTraits[trait.toString()] = trait.description ?? '';
    });
    unit.weapons.forEach((weapon) {
      weapon.traits.forEach((trait) {
        allTraits[trait.toString()] = trait.description ?? '';
      });
      weapon.alternativeTraits.forEach((trait) {
        allTraits[trait.toString()] = trait.description ?? '';
      });
    });
  });

  final sortedTraits = allTraits.keys.toList();
  sortedTraits.sort();

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
      sortedTraits.length,
      (row) => List<String>.generate(tableHeaders.length, (col) {
        final traitName = sortedTraits[row];
        switch (col) {
          case 0:
            return traitName;
          case 1:
            return allTraits[traitName] ?? '';
          default:
            return '';
        }
      }),
    ),
  );

  return pw.Padding(
    padding: pw.EdgeInsets.only(
      left: 10.0,
      right: 10.0,
      top: 10.0,
      bottom: 10.0,
    ),
    child: table,
  );
}
