import 'dart:convert';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/screens/roster/combat_groups_display.dart';
import 'package:gearforce/screens/roster/roster_header_info.dart';
import 'package:gearforce/screens/unitSelector/unit_selection.dart';
import 'package:provider/provider.dart';

// using dart:html to allow rosters to be saved locally on web builds.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as webFile;

const double _leftPanelWidth = 670.0;
const double _menuTitleHeight = 60.0;
const String _version = '0.16.1';
const String _bugMessage =
    'Please report any issues to gearforce@metadiversions.com';
const String _defaultRosterFileName = 'roster';
const String _downloadFileExtension = 'gf';

class RosterWidget extends StatefulWidget {
  RosterWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String? title;

  @override
  _RosterWidgetState createState() => _RosterWidgetState();
}

class _RosterWidgetState extends State<RosterWidget> {
  final UnitRoster roster = UnitRoster();

  @override
  Widget build(BuildContext context) {
    final data = context.watch<Data>();
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the Roster object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title!),
      ),
      body: ChangeNotifierProvider(
        create: (_) => roster,
        child: Row(
          children: [
            SizedBox(
              width: _leftPanelWidth,
              child: Column(
                children: [
                  RosterHeaderInfo(),
                  CombatGroupsDisplay(),
                ],
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
              ),
            ),
            Expanded(
              child: UnitSelection(),
              flex: 2,
            ),
          ],
        ),
      ),
      drawer: Drawer(
        semanticLabel: 'menu',
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: _menuTitleHeight,
              child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Center(
                  child: Text(
                    'Menu',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Load',
                style: TextStyle(fontSize: 16),
              ),
              onTap: () async {
                FilePickerCross myFile =
                    await FilePickerCross.importFromStorage(
                        type: FileTypeCross
                            .custom, // Available: `any`, `audio`, `image`, `video`, `custom`. Note: not available using FDE
                        fileExtension:
                            'gf' // Only if FileTypeCross.custom . May be any file extension like `dot`, `ppt,pptx,odp`
                        );
                try {
                  var decodedFile = json.decode(myFile.toString());
                  var r = UnitRoster.fromJson(decodedFile, data);
                  setState(() {
                    roster.copyFrom(r);
                  });
                } on FormatException catch (e) {
                  // TODO add notification toast that the file format was invalid
                  print('Format exception caught : $e');
                } on Exception catch (e) {
                  // TODO add notification toast that the file could not be loaded and why
                  print('exception caught loading ${myFile.fileName} : $e');
                } catch (e) {
                  print('error occured decoding safe file : $e');
                }
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Save',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              enabled: kIsWeb,
              onTap: () async {
                var encodedRoster = json.encode(roster);
                //TODO remove print when satisfied with external testing
                print(encodedRoster);
                var blob =
                    webFile.Blob([encodedRoster], 'application/json', 'native');
                webFile.AnchorElement(
                  href: webFile.Url.createObjectUrlFromBlob(blob).toString(),
                )
                  ..setAttribute(
                      "download",
                      roster.name == null
                          ? '$_defaultRosterFileName.$_downloadFileExtension'
                          : '${roster.name}.$_downloadFileExtension')
                  ..click();
              },
            ),
            AboutListTile(
              applicationName: 'Gearforce',
              applicationVersion: _version,
              aboutBoxChildren: [
                Text(_bugMessage),
                Text('Rules version: ${roster.rulesVersion}'),
                Text('Compedndium version: ${roster.compendiumVersion}'),
              ],
              dense: true,
              child: Text('About Gearforce',
                  style: TextStyle(
                    fontSize: 16,
                  )),
            ),
            ListTile(
              title: Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
              dense: true,
              horizontalTitleGap: 5.0,
            ),
          ],
        ),
      ),
    );
  }
}
