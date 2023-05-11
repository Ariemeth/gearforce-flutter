import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/roster/roster.dart';

//const String _defaultRosterFileName = 'hg-roster';
//const String _downloadFileExtension = 'gf';

UnitRoster loadRoster(Data data) {
  return UnitRoster(data);
}



// final filePicker = FilePickerCross.importFromStorage(
//     type: FileTypeCross
//         .custom, // Available: `any`, `audio`, `image`, `video`, `custom`. Note: not available using FDE
//     fileExtension:
//         'gf' // Only if FileTypeCross.custom . May be any file extension like `dot`, `ppt,pptx,odp`
//     );
// try {
//   final myFile = await filePicker;
//   var decodedFile = json.decode(myFile.toString());
//   var r = UnitRoster.fromJson(decodedFile, data);
//   setState(() {
//     roster.copyFrom(r);
//   });
// } on FormatException catch (e) {
//   // TODO add notification toast that the file format was invalid
//   print('Format exception caught : $e');
// } on Exception catch (e) {
//   // TODO add notification toast that the file could not be loaded and why
//   print('exception caught loading file : $e');
// } catch (e) {
//   print('error occured decoding safe file : $e');
// }