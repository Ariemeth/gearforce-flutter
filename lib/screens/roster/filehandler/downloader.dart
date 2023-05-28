import 'dart:convert';
import 'dart:typed_data';
import 'package:file_selector/file_selector.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/screens/roster/filehandler/fileHandler.dart';

const String _defaultRosterFileName = 'hg-roster';

Future<void> downloadRoster(UnitRoster roster) async {
  var encodedRoster = json.encode(roster);
  //TODO remove print when satisfied with external testing
  print(encodedRoster);
  final data = utf8.encode(encodedRoster);

  final String fileName =
      '${roster.name ?? _defaultRosterFileName}.${FileExtension}';
  final String? path = await getSavePath(suggestedName: fileName);
  if (path == null) {
    // Operation was canceled by the user.
    return;
  }

  final Uint8List fileData = Uint8List.fromList(data);
  const String mimeType = 'application/json';
  final XFile textFile = XFile.fromData(
    fileData,
    mimeType: mimeType,
    name: fileName,
  );

  await textFile.saveTo(path);
}