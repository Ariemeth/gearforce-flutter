import 'dart:typed_data';

import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<bool> printPDF(UnitRoster roster) async {
  // This is where we print the document
  return Printing.layoutPdf(
    // [onLayout] will be called multiple times
    // when the user changes the printer or printer settings
    onLayout: (PdfPageFormat format) {
      // Any valid Pdf document can be returned here as a list of int
      return buildPdf(format, roster);
    },
  );
}

/// This method takes a page format and generates the Pdf file data
Future<Uint8List> buildPdf(PdfPageFormat format, UnitRoster roster) async {
  // Create the Pdf document
  final pw.Document doc = pw.Document();
  final font = await PdfGoogleFonts.nunitoExtraLight();

  // Add one page with centered text "Hello World"
  doc.addPage(
    pw.MultiPage(
      pageFormat: format,
      build: (pw.Context context) {
        return [
          ...buildRosterContent(font, roster),
        ];
      },
    ),
  );

  // Build and return the final Pdf file data
  return doc.save();
}

const String _defaultRosterFileName = 'hg-roster';
const String _downloadFileExtension = 'pdf';

Future<void> downloadPDF(UnitRoster roster) async {
  final pdf = await buildPdf(PdfPageFormat.letter, roster);

  var myFile = FilePickerCross(pdf,
      type: FileTypeCross.custom, fileExtension: _downloadFileExtension);
  final filename = roster.name == null || roster.name!.isEmpty
      ? _defaultRosterFileName
      : roster.name;
  myFile.exportToStorage(fileName: '$filename.$_downloadFileExtension');
}

List<pw.Widget> buildRosterContent(pw.Font font, UnitRoster roster) {
  return [
    /*  pw.ConstrainedBox(
      constraints: pw.BoxConstraints.tightForFinite(),
      child: pw.FittedBox(
        fit: pw.BoxFit.none,
        child: pw.Column(children: [
          pw.Row(children: [
            pw.Text(
              'Heavy Gear Bltiz Force Record Sheet',
              style: pw.TextStyle(font: font, fontSize: 16),
            ),
          ]),
        ]),
      ),
    ),*/
    pw.Column(children: [
      pw.Center(
        child: pw.Text('Heavy Gear Bltiz Force Record Sheet',
            style: pw.TextStyle(font: font, fontSize: 24)),
      ),
      pw.Row(children: [
        pw.Expanded(
            child: pw.Column(children: [
          pw.Text('${roster.player}'),
        ])),
        pw.Expanded(
            child: pw.Column(children: [
          pw.Container(
              child: pw.Text(
                  '${factionTypeToString(roster.faction.value!)}/${roster.subFaction.value}'))
        ])),
      ]),
    ])
  ];
}
