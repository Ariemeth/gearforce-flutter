import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/screens/roster/pdf/record_sheet/record_sheet.dart';
import 'package:gearforce/screens/roster/pdf/unit_cards/unit_cards.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

const String _defaultRosterFileName = 'hg-roster';
const String _webURL = 'https://gf.metadiversions.com';

const double _leftRightPageMargins = PdfPageFormat.inch / 8.0;
const double _topPageMargins = PdfPageFormat.inch / 32;
const double _bottomPageMargins = PdfPageFormat.inch / 28;
const double _unitCardMargins = 5.0 / 2.0;
const pw.EdgeInsets _footerMargin = const pw.EdgeInsets.only(top: 0);

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
  final pageTheme = await _myPageTheme(format);

  // Add record sheet summary
  doc.addPage(
    pw.MultiPage(
        pageTheme: pageTheme,
        build: (pw.Context context) {
          return buildRecordSheet(font, roster);
        },
        footer: (pw.Context context) {
          return _buildFooter(context, version, roster.rulesVersion);
        }),
  );

  final unitCards = buildUnitCards(font, roster, version: version);
  List<pw.Widget> cardRows = _buildCardRows(unitCards);

  // Add unit cards, they should be aligned in a 3 x 3 layout on each page
  doc.addPage(pw.MultiPage(
    pageTheme: pageTheme,
    build: (pw.Context context) {
      return cardRows;
    },
    footer: (pw.Context context) {
      return _buildFooter(context, version, roster.rulesVersion);
    },
  ));

  // Build and return the final Pdf file data
  return doc.save();
}

pw.Widget _buildFooter(
    pw.Context context, String version, String rulesVersion) {
  final footerStyle = pw.Theme.of(context)
      .defaultTextStyle
      .copyWith(color: PdfColors.grey, fontSize: 10);
// TODO Instead of manually placing cards to print into rows, put them into a
// pw.grid like the hull and structure boxes used to use.

  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Container(
        alignment: pw.Alignment.centerLeft,
        margin: _footerMargin,
        child: pw.Text('Rules: $rulesVersion', style: footerStyle),
      ),
      pw.Container(
        alignment: pw.Alignment.center,
        margin: _footerMargin,
        child: pw.Text('Created using Gearforce v$version  $_webURL',
            style: footerStyle),
      ),
      pw.Container(
        alignment: pw.Alignment.centerRight,
        margin: _footerMargin,
        child: pw.Text(
          'Page ${context.pageNumber} of ${context.pagesCount}',
          style: footerStyle,
        ),
      ),
    ],
  );
}

List<pw.Widget> _buildCardRows(List<pw.Widget> unitCards) {
  final List<pw.Widget> cardRows = [];

  for (var i = 0; i < unitCards.length; i++) {
    final leftCard = pw.Padding(
      padding: pw.EdgeInsets.all(_unitCardMargins),
      child: unitCards[i],
    );

    pw.Widget? middleCard;
    var nextCardIndex = i + 1;
    if (nextCardIndex < unitCards.length) {
      middleCard = pw.Padding(
        padding: pw.EdgeInsets.all(_unitCardMargins),
        child: unitCards[nextCardIndex],
      );
      i++;
    }

    pw.Widget? rightCard;
    nextCardIndex = nextCardIndex + 1;
    if (nextCardIndex < unitCards.length) {
      rightCard = pw.Padding(
        padding: pw.EdgeInsets.all(_unitCardMargins),
        child: unitCards[nextCardIndex],
      );
      i++;
    }
    cardRows.add(
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          leftCard,
          middleCard ?? pw.Container(),
          rightCard ?? pw.Container(),
        ],
      ),
    );
  }
  return cardRows;
}

Future<void> downloadPDF(UnitRoster roster, {required String version}) async {
  final pdf = await buildPdf(
    PdfPageFormat.letter,
    roster,
    version: version,
  );

  final String fileName = '${roster.name ?? _defaultRosterFileName}.pdf';
  final saveLocation = await getSaveLocation(suggestedName: fileName);
  if (saveLocation == null) {
    // Operation was canceled by the user.
    return;
  }

  final XFile textFile = XFile.fromData(
    pdf,
    mimeType: 'application/pdf',
    name: fileName,
  );

  await textFile.saveTo(saveLocation.path);
}

Future<pw.PageTheme> _myPageTheme(PdfPageFormat format) async {
  final updatedFormat = format.copyWith(
    marginLeft: _leftRightPageMargins,
    marginRight: _leftRightPageMargins,
    marginTop: _topPageMargins,
    marginBottom: _bottomPageMargins,
  );

  return pw.PageTheme(
    pageFormat: updatedFormat,
    theme: pw.ThemeData.withFont(
      base: await PdfGoogleFonts.openSansRegular(),
      bold: await PdfGoogleFonts.openSansBold(),
      icons: await PdfGoogleFonts.materialIcons(),
    ),
  );
}
