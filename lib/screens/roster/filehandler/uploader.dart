import 'dart:convert';
import 'package:file_selector/file_selector.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/screens/roster/filehandler/fileHandler.dart';

Future<UnitRoster?> loadRoster(Data data) async {
  UnitRoster? resultRoster;

  const XTypeGroup typeGroup = XTypeGroup(
    label: 'gearforce',
    extensions: <String>[FileExtension],
  );
  final XFile? file =
      await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);

  if (file == null) {
    return resultRoster;
  }

  try {
    var decodedFile = json.decode(await file.readAsString());
    resultRoster = UnitRoster.fromJson(decodedFile, data);
  } catch (e) {
    print('error occured loading ${file.name} : $e');
  }

  return resultRoster;
}
