import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/screens/roster/pdf/record_sheet/record_sheet.dart';
import 'package:gearforce/screens/roster/pdf/record_sheet/rules_sheet.dart';
import 'package:gearforce/screens/roster/pdf/record_sheet/traits_sheet.dart';
import 'package:gearforce/screens/roster/pdf/unit_cards/unit_cards.dart';
import 'package:gearforce/widgets/pdf_settings.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

const String _defaultRosterFileName = 'hg-roster';
const String _webURL = 'https://nj.playtest.gearforce.metadiversions.com';

const double _unitCardMargins = 0;

Future<bool> printPDF(
  UnitRoster roster,
  PDFSettings settings, {
  required String version,
}) async {
  final info = await Printing.info();
  if (!info.canPrint) {
    return false;
  }

  // This is where we print the document
  return Printing.layoutPdf(
    format: PdfPageFormat.letter.copyWith(
      width: PdfPageFormat.letter.width,
      height: PdfPageFormat.letter.height,
      marginLeft: PdfPageFormat.inch / 4.0,
      marginRight: PdfPageFormat.inch / 4.0,
      marginTop: PdfPageFormat.inch / 4.0,
      marginBottom: PdfPageFormat.inch / 4.0,
    ),
    dynamicLayout: false,
    // [onLayout] will be called multiple times
    // when the user changes the printer or printer settings
    onLayout: (PdfPageFormat format) {
      // Any valid Pdf document can be returned here as a list of int
      return buildPdf(format, roster, settings, version: version);
    },
  );
}

Future<void> downloadPDF(
  UnitRoster roster,
  PDFSettings settings, {
  required String version,
}) async {
  final pdf = await buildPdf(
    PdfPageFormat.letter.copyWith(
      width: PdfPageFormat.letter.width,
      height: PdfPageFormat.letter.height,
      marginLeft: PdfPageFormat.inch / 4.0,
      marginRight: PdfPageFormat.inch / 4.0,
      marginTop: PdfPageFormat.inch / 4.0,
      marginBottom: PdfPageFormat.inch / 4.0,
    ),
    roster,
    settings,
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

/// This method takes a page format and generates the Pdf file data
Future<Uint8List> buildPdf(
  PdfPageFormat format,
  UnitRoster roster,
  PDFSettings settings, {
  required String version,
}) async {
  // Create the Pdf document
  final pw.Document doc = pw.Document();
  final font = await PdfGoogleFonts.nunitoRegular();
  final pageTheme = await _myPageTheme(format);

  if (settings.sections.recordSheet) {
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
  }

  if (settings.sections.unitCards) {
    final unitCards = buildUnitCards(font, roster, version: version);

    // Add unit cards
    doc.addPage(pw.MultiPage(
      pageTheme: pageTheme,
      mainAxisAlignment: pw.MainAxisAlignment.start,
      crossAxisAlignment: unitCards.length % 9 == 1
          ? pw.CrossAxisAlignment.start
          : pw.CrossAxisAlignment.center,
      build: (pw.Context context) {
        return [
          pw.Wrap(
            children: unitCards,
            spacing: _unitCardMargins * 2,
            runSpacing: _unitCardMargins,
          )
        ];
      },
      footer: (pw.Context context) {
        return _buildFooter(context, version, roster.rulesVersion);
      },
    ));
  }

  if (settings.sections.traitReference) {
    // Add Trait reference page
    doc.addPage(pw.MultiPage(
        pageTheme: pageTheme,
        build: (context) {
          return [buildTraitSheet(font, roster.getAllUnits())];
        },
        footer: (pw.Context context) {
          return _buildFooter(context, version, roster.rulesVersion);
        }));
  }

  if (settings.sections.factionRules || settings.sections.subFactionRules) {
    // Add Rules reference page
    doc.addPage(pw.MultiPage(
        pageTheme: pageTheme,
        build: (context) {
          return [
            buildRulesSheet(
              font,
              roster,
              includeFactionRules: settings.sections.factionRules,
              includeSubFactionRules: settings.sections.subFactionRules,
            )
          ];
        },
        footer: (pw.Context context) {
          return _buildFooter(context, version, roster.rulesVersion);
        }));
  }
  // Build and return the final Pdf file data
  return doc.save();
}

pw.Widget _buildFooter(
    pw.Context context, String version, String rulesVersion) {
  final footerStyle = pw.Theme.of(context)
      .defaultTextStyle
      .copyWith(color: PdfColors.grey, fontSize: 10);

  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('Rules: $rulesVersion', style: footerStyle),
      ),
      pw.Container(
        alignment: pw.Alignment.center,
        child: pw.Text('Created using Gearforce v$version  $_webURL',
            style: footerStyle),
      ),
      pw.Container(
        alignment: pw.Alignment.centerRight,
        child: pw.Text(
          'Page ${context.pageNumber} of ${context.pagesCount}',
          style: footerStyle,
        ),
      ),
    ],
  );
}

Future<pw.PageTheme> _myPageTheme(PdfPageFormat format) async {
  final updatedFormat = PdfPageFormat.letter.copyWith(
    width: PdfPageFormat.letter.width,
    height: PdfPageFormat.letter.height,
    marginLeft: PdfPageFormat.inch / 4.0,
    marginRight: PdfPageFormat.inch / 4.0,
    marginTop: PdfPageFormat.inch / 4.0,
    marginBottom: PdfPageFormat.inch / 4.0,
  );

  return pw.PageTheme(
    pageFormat: updatedFormat,
    orientation: pw.PageOrientation.portrait,
    theme: pw.ThemeData.withFont(
      base: await PdfGoogleFonts.openSansRegular(),
      bold: await PdfGoogleFonts.openSansBold(),
      icons: await PdfGoogleFonts.materialIcons(),
    ),
  );
}
