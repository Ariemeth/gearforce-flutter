import 'package:gearforce/models/roster/roster.dart';
import 'package:pdf/widgets.dart' as pw;

const String _recordSheetHeadingText = 'Heavy Gear Blitz Force Record Sheet';
const String _playerNameDescriptor = 'Player Name';
const String _forceNameDescriptor = 'Force Name';
const String _factionNameDescriptor = 'Faction / Sublist';
const String _totalTVNameDescriptor = 'Total TV';
const double _recordSheetHeadingFontSize = 30;
const double _totalTVBlockWidth = 40.0;

pw.Widget buildRosterHeader(pw.Font font, UnitRoster roster) {
  final standardTextStyle = pw.TextStyle(font: font, fontSize: 12);
  final smallTextStyle = pw.TextStyle(font: font, fontSize: 8);
  final sideInset = pw.EdgeInsets.only(left: 10.0, right: 10.0);
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
        padding: sideInset,
        child: pw.Row(
          children: [
            pw.Expanded(
              flex: 10,
              child: pw.Column(
                children: [
                  pw.Container(
                    child: pw.Text(
                      '${roster.player != null ? roster.player : ''}',
                      style: standardTextStyle,
                      maxLines: 1,
                      overflow: pw.TextOverflow.clip,
                    ),
                    decoration: pw.BoxDecoration(
                      border: pw.Border(bottom: pw.BorderSide()),
                    ),
                  ),
                  pw.Text(
                    _playerNameDescriptor,
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
                      '${roster.name != null ? roster.name : ''}',
                      style: standardTextStyle,
                      maxLines: 1,
                      overflow: pw.TextOverflow.clip,
                    ),
                    decoration: pw.BoxDecoration(
                      border: pw.Border(bottom: pw.BorderSide()),
                    ),
                  ),
                  pw.Text(
                    _forceNameDescriptor,
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
        padding: sideInset.copyWith(top: gapAboveFactionText),
        child: pw.Column(
          children: [
            pw.Container(
              //   alignment: pw.Alignment.topRight,
              child: pw.Text(
                '${roster.factionNotifier.value.name} / ${roster.rulesetNotifer.value}',
                style: standardTextStyle,
                maxLines: 2,
                overflow: pw.TextOverflow.clip,
              ),
              decoration: pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide()),
              ),
            ),
            pw.Text(
              _factionNameDescriptor,
              style: smallTextStyle,
            ),
          ],
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          mainAxisAlignment: pw.MainAxisAlignment.end,
        ),
      ),
      pw.Padding(
        padding: sideInset.copyWith(top: gapAboveFactionText),
        child: pw.Row(
          children: [
            pw.Container(
              width: _totalTVBlockWidth,
              child: pw.Column(
                children: [
                  pw.Container(
                    child: pw.Text(
                      '${roster.totalTV()}',
                      style: standardTextStyle,
                      maxLines: 1,
                      textAlign: pw.TextAlign.center,
                    ),
                    decoration: pw.BoxDecoration(
                      border: pw.Border(bottom: pw.BorderSide()),
                    ),
                  ),
                  pw.Text(
                    _totalTVNameDescriptor,
                    style: smallTextStyle,
                    textAlign: pw.TextAlign.center,
                  ),
                ],
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                mainAxisAlignment: pw.MainAxisAlignment.end,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
