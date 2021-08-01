import 'dart:convert';

import 'package:gearforce/models/roster/roster.dart';
// using dart:html to allow rosters to be saved locally on web builds.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as webFile;

const String _defaultRosterFileName = 'roster';
const String _downloadFileExtension = 'gf';

void downloadRoster(UnitRoster roster) {
  var encodedRoster = json.encode(roster);
  //TODO remove print when satisfied with external testing
  print(encodedRoster);
  var blob = webFile.Blob([encodedRoster], 'application/json', 'native');
  webFile.AnchorElement(
    href: webFile.Url.createObjectUrlFromBlob(blob).toString(),
  )
    ..setAttribute(
        "download",
        roster.name == null
            ? '$_defaultRosterFileName.$_downloadFileExtension'
            : '${roster.name}.$_downloadFileExtension')
    ..click();
}
