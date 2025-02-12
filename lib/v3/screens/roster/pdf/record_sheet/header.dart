import 'package:gearforce/v3/models/roster/roster.dart';
import 'package:gearforce/v3/models/unit/model_type.dart';
import 'package:pdf/widgets.dart' as pw;

const String _recordSheetHeadingText = 'Heavy Gear Blitz Force Record Sheet';
const String _playerNameDescriptor = 'Player Name';
const String _forceNameDescriptor = 'Force Name';
const String _factionNameDescriptor = 'Faction / Sublist';
const String _totalTVNameDescriptor = 'TV';
const String _totalActionsNameDescriptor = 'Actions';
const String _totalModelCountNameDescriptor = 'Models';
const String _cgModelCountNameDescriptor = 'Combat Groups';
const String _airstrikeCounterNameDescriptor = 'Airstrike Counters';
const double _recordSheetHeadingFontSize = 30;
const double _totalTVBlockWidth = 40.0;
const double _combatGroupCountBlockWidth = 70.0;
const double _spaceBetweenValues = 10.0;

pw.Widget buildRosterHeader(pw.Font font, UnitRoster roster) {
  final standardTextStyle = pw.TextStyle(font: font, fontSize: 12);
  final smallTextStyle = pw.TextStyle(font: font, fontSize: 8);
  const sideInset = pw.EdgeInsets.only(left: 10.0, right: 10.0);
  const double gapAboveFactionText = 5.0;

  return pw.Column(
    children: [
      pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 5.0),
        child: pw.Center(
          child: pw.Text(
            _recordSheetHeadingText,
            style: pw.TextStyle(
              font: font,
              fontSize: _recordSheetHeadingFontSize,
            ),
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
                      roster.player ?? ' ',
                      style: standardTextStyle,
                      maxLines: 1,
                      overflow: pw.TextOverflow.clip,
                    ),
                    decoration: const pw.BoxDecoration(
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
                      roster.name ?? ' ',
                      style: standardTextStyle,
                      maxLines: 1,
                      overflow: pw.TextOverflow.clip,
                    ),
                    decoration: const pw.BoxDecoration(
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
              child: pw.Text(
                '${roster.factionNotifier.value.name} ${roster.rulesetNotifer.value.name != '' ? '/' : ''} ${roster.rulesetNotifer.value.name}',
                style: standardTextStyle,
                maxLines: 2,
                overflow: pw.TextOverflow.clip,
              ),
              decoration: const pw.BoxDecoration(
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
                    decoration: const pw.BoxDecoration(
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
            pw.SizedBox(width: _spaceBetweenValues),
            pw.Container(
              width: _totalTVBlockWidth,
              child: pw.Column(
                children: [
                  pw.Container(
                    child: pw.Text(
                      '${roster.totalActions}',
                      style: standardTextStyle,
                      maxLines: 1,
                      textAlign: pw.TextAlign.center,
                    ),
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(bottom: pw.BorderSide()),
                    ),
                  ),
                  pw.Text(
                    _totalActionsNameDescriptor,
                    style: smallTextStyle,
                    textAlign: pw.TextAlign.center,
                  ),
                ],
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                mainAxisAlignment: pw.MainAxisAlignment.end,
              ),
            ),
            pw.SizedBox(width: _spaceBetweenValues),
            pw.Container(
              width: _totalTVBlockWidth,
              child: pw.Column(
                children: [
                  pw.Container(
                    child: pw.Text(
                      '${roster.getAllUnits().where((unit) => unit.type != ModelType.airstrikeCounter).length}',
                      style: standardTextStyle,
                      maxLines: 1,
                      textAlign: pw.TextAlign.center,
                    ),
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(bottom: pw.BorderSide()),
                    ),
                  ),
                  pw.Text(
                    _totalModelCountNameDescriptor,
                    style: smallTextStyle,
                    textAlign: pw.TextAlign.center,
                  ),
                ],
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                mainAxisAlignment: pw.MainAxisAlignment.end,
              ),
            ),
            pw.SizedBox(width: _spaceBetweenValues),
            pw.Container(
              width: _combatGroupCountBlockWidth,
              child: pw.Column(
                children: [
                  pw.Container(
                    child: pw.Text(
                      '${roster.combatGroupCount}',
                      style: standardTextStyle,
                      maxLines: 1,
                      textAlign: pw.TextAlign.center,
                    ),
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(bottom: pw.BorderSide()),
                    ),
                  ),
                  pw.Text(
                    _cgModelCountNameDescriptor,
                    style: smallTextStyle,
                    textAlign: pw.TextAlign.center,
                  ),
                ],
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                mainAxisAlignment: pw.MainAxisAlignment.end,
              ),
            ),
            pw.SizedBox(width: _spaceBetweenValues),
            pw.Container(
              width: _combatGroupCountBlockWidth,
              child: pw.Column(
                children: [
                  pw.Container(
                    child: pw.Text(
                      '${roster.totalAirstrikeCounters()}',
                      style: standardTextStyle,
                      maxLines: 1,
                      textAlign: pw.TextAlign.center,
                    ),
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(bottom: pw.BorderSide()),
                    ),
                  ),
                  pw.Text(
                    _airstrikeCounterNameDescriptor,
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
