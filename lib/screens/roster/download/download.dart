import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:gearforce/models/roster/roster.dart';

const String _defaultRosterFileName = 'hg-roster';
const String _downloadFileExtension = 'gf';

void downloadRoster(UnitRoster roster) {
  var encodedRoster = json.encode(roster);
  //TODO remove print when satisfied with external testing
  print(encodedRoster);
  final data = utf8.encode(encodedRoster);
  var myFile = FilePickerCross(Uint8List.fromList(data),
      type: FileTypeCross.custom, fileExtension: _downloadFileExtension);
  final filename = roster.name == null || roster.name!.isEmpty
      ? _defaultRosterFileName
      : roster.name;
  myFile.exportToStorage(fileName: '$filename.$_downloadFileExtension');
}
