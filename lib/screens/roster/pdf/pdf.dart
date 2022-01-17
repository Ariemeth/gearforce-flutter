import 'dart:typed_data';

import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/screens/roster/pdf/record_sheet/record_sheet.dart';
import 'package:gearforce/screens/roster/pdf/unit_cards/unit_cards.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

const String _defaultRosterFileName = 'hg-roster';
const String _downloadFileExtension = 'pdf';

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
        return buildRecordSheet(font, roster);
      },
    ),
  );
  doc.addPage(pw.MultiPage(
    pageFormat: format,
    build: (pw.Context context) {
      return buildUnitCards(font, roster);
    },
  ));

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
