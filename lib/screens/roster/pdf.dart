import 'dart:typed_data';

import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

const String _defaultRosterFileName = 'hg-roster';
const String _downloadFileExtension = 'pdf';

const String _recordSheetHeadingText = 'Heavy Gear Blitz Force Record Sheet';
const double _recordSheetHeadingFontSize = 30;
const double _pageMargins = 36.0;

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
          _buildRosterHeader(font, roster),
          pw.Spacer(),
          ...buildRosterContent(font, roster),
        ];
      },
    ),
  );

  // Build and return the final Pdf file data
  return doc.save();
}

Future<void> downloadPDF(UnitRoster roster) async {
  final pdf = await buildPdf(
      PdfPageFormat.letter.copyWith(
          marginLeft: _pageMargins,
          marginRight: _pageMargins,
          marginTop: _pageMargins,
          marginBottom: _pageMargins),
      roster);

  var myFile = FilePickerCross(pdf,
      type: FileTypeCross.custom, fileExtension: _downloadFileExtension);
  final filename = roster.name == null || roster.name!.isEmpty
      ? _defaultRosterFileName
      : roster.name;
  myFile.exportToStorage(fileName: '$filename.$_downloadFileExtension');
}

List<pw.Widget> buildRosterContent(pw.Font font, UnitRoster roster) {
  return [
    pw.Text(
      'Content',
      style: pw.TextStyle(
        font: font,
        fontSize: 12,
      ),
    ),
  ];
}

pw.Widget _buildRosterHeader(pw.Font font, UnitRoster roster) {
  final standardTextStyle = pw.TextStyle(font: font, fontSize: 12);
  final smallTextStyle = pw.TextStyle(font: font, fontSize: 8);
  final sidePadding = pw.EdgeInsets.only(left: 10.0, right: 10.0);
  const double gapAboveFactionText = 5.0;

  return pw.Column(
    children: [
      pw.Center(
        child: pw.Text(
          _recordSheetHeadingText,
          style: pw.TextStyle(
            font: font,
            fontSize: _recordSheetHeadingFontSize,
          ),
        ),
      ),
      pw.Padding(
        padding: sidePadding,
        child: pw.Row(
          children: [
            pw.Expanded(
              flex: 10,
              child: pw.Column(
                children: [
                  pw.Container(
                    child: pw.Text(
                      '${roster.player}',
                      style: standardTextStyle,
                      maxLines: 1,
                      overflow: pw.TextOverflow.clip,
                    ),
                    decoration: pw.BoxDecoration(
                      border: pw.Border(bottom: pw.BorderSide()),
                    ),
                  ),
                  pw.Text(
                    'Player Name',
                    style: smallTextStyle,
                  ),
                ],
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                mainAxisAlignment: pw.MainAxisAlignment.end,
              ),
            ),
            pw.Spacer(flex: 1),
            pw.Expanded(
              flex: 10,
              child: pw.Column(
                children: [
                  pw.Container(
                    child: pw.Text(
                      '${roster.name}',
                      style: standardTextStyle,
                      maxLines: 1,
                      overflow: pw.TextOverflow.clip,
                    ),
                    decoration: pw.BoxDecoration(
                      border: pw.Border(bottom: pw.BorderSide()),
                    ),
                  ),
                  pw.Text(
                    'Force Name',
                    style: smallTextStyle,
                  ),
                ],
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                mainAxisAlignment: pw.MainAxisAlignment.end,
              ),
            ),
          ],
        ),
      ),
      pw.Padding(
        padding: sidePadding.copyWith(top: gapAboveFactionText),
        child: pw.Column(
          children: [
            pw.Container(
              //   alignment: pw.Alignment.topRight,
              child: pw.Text(
                '${factionTypeToString(roster.faction.value!)}/${roster.subFaction.value}',
                style: standardTextStyle,
                maxLines: 2,
                overflow: pw.TextOverflow.clip,
              ),
              decoration: pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide()),
              ),
            ),
            pw.Text(
              'Faction / Sublist',
              style: smallTextStyle,
            ),
          ],
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          mainAxisAlignment: pw.MainAxisAlignment.end,
        ),
      ),
    ],
  );
}
