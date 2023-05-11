import 'dart:typed_data';

//import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/screens/roster/pdf/record_sheet/record_sheet.dart';
import 'package:gearforce/screens/roster/pdf/unit_cards/unit_cards.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

//const String _defaultRosterFileName = 'hg-roster';
//const String _downloadFileExtension = 'pdf';
const String _webURL = 'https://gf.metadiversions.com';

//const double _pageMargins = 36.0;
const double _unitCardMargins = 5.0;

Future<bool> printPDF(UnitRoster roster, {required String version}) async {
  // This is where we print the document
  return Printing.layoutPdf(
    // [onLayout] will be called multiple times
    // when the user changes the printer or printer settings
    onLayout: (PdfPageFormat format) {
      // Any valid Pdf document can be returned here as a list of int
      return buildPdf(format, roster, version: version);
    },
  );
}

/// This method takes a page format and generates the Pdf file data
Future<Uint8List> buildPdf(PdfPageFormat format, UnitRoster roster,
    {required String version}) async {
  // Create the Pdf document
  final pw.Document doc = pw.Document();
  final font = await PdfGoogleFonts.nunitoRegular();

  // Add record sheet summary
  doc.addPage(
    pw.MultiPage(
        pageFormat: format,
        build: (pw.Context context) {
          return buildRecordSheet(font, roster);
        },
        footer: (pw.Context context) {
          return _buildFooter(context, version);
        }),
  );

  final unitCards = buildUnitCards(font, roster, version: version);
  List<pw.Widget> cardRows = _buildCardRow(unitCards);

  // Add unit cards, they should be aligned in a 2 x 2 layout on each page
  doc.addPage(pw.MultiPage(
    pageFormat: format,
    build: (pw.Context context) {
      return cardRows;
    },
    footer: (pw.Context context) {
      return _buildFooter(context, version);
    },
  ));

  // Build and return the final Pdf file data
  return doc.save();
}

pw.Widget _buildFooter(pw.Context context, String version) {
  final footerStyle = pw.Theme.of(context)
      .defaultTextStyle
      .copyWith(color: PdfColors.grey, fontSize: 10);

  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Container(
        alignment: pw.Alignment.centerLeft,
        margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
        child: pw.Text(
          'Created using Gearforce version: $version\n$_webURL',
          style: footerStyle,
        ),
      ),
      pw.Container(
        alignment: pw.Alignment.centerRight,
        margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
        child: pw.Text(
          'Page ${context.pageNumber} of ${context.pagesCount}',
          style: footerStyle,
        ),
      ),
    ],
  );
}

List<pw.Widget> _buildCardRow(List<pw.Widget> unitCards) {
  final List<pw.Widget> cardRows = [];

  for (var i = 0; i < unitCards.length; i++) {
    final leftCard = pw.Padding(
      padding: pw.EdgeInsets.all(_unitCardMargins),
      child: unitCards[i],
    );
    pw.Widget? rightCard;
    final nextCardIndex = i + 1;
    if (nextCardIndex < unitCards.length) {
      rightCard = pw.Padding(
        padding: pw.EdgeInsets.all(_unitCardMargins),
        child: unitCards[nextCardIndex],
      );
      i++;
    }
    cardRows.add(
      pw.Row(
        children: [
          leftCard,
          rightCard ?? pw.Container(),
        ],
      ),
    );
  }
  return cardRows;
}

Future<void> downloadPDF(UnitRoster roster, {required String version}) async {
  // final pdf = await buildPdf(
  //   PdfPageFormat.letter.copyWith(
  //       marginLeft: _pageMargins,
  //       marginRight: _pageMargins,
  //       marginTop: _pageMargins,
  //       marginBottom: _pageMargins),
  //   roster,
  //   version: version,
  // );

  // var myFile = FilePickerCross(pdf,
  //     type: FileTypeCross.custom, fileExtension: _downloadFileExtension);
  // final filename = roster.name == null || roster.name!.isEmpty
  //     ? _defaultRosterFileName
  //     : roster.name;
  // myFile.exportToStorage(fileName: '$filename.$_downloadFileExtension');
}
