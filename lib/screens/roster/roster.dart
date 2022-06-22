import 'dart:convert';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/screens/roster/air_strike.dart';
import 'package:gearforce/screens/roster/combat_groups_display.dart';
import 'package:gearforce/screens/roster/download/download.dart';
import 'package:gearforce/screens/roster/pdf/pdf.dart';
import 'package:gearforce/screens/roster/roster_header_info.dart';
import 'package:gearforce/screens/unitSelector/unit_selection.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

const double _leftPanelWidth = 670.0;
const double _titleHeight = 40.0;
const double _menuTitleHeight = 50.0;
const String _version = '0.37.0';
const String _bugEmailAddress = 'gearforce@metadiversions.com';
const String _dp9URL = 'https://www.dp9.com/';
const String _sourceCodeURL = 'https://github.com/Ariemeth/gearforce-flutter';

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
        toolbarHeight: _titleHeight,
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
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              ),
            ),
            ListTile(
              title: Text(
                'Load',
                style: TextStyle(fontSize: 16),
              ),
              onTap: () async {
                final filePicker = FilePickerCross.importFromStorage(
                    type: FileTypeCross
                        .custom, // Available: `any`, `audio`, `image`, `video`, `custom`. Note: not available using FDE
                    fileExtension:
                        'gf' // Only if FileTypeCross.custom . May be any file extension like `dot`, `ppt,pptx,odp`
                    );
                try {
                  final myFile = await filePicker;
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
                  print('exception caught loading file : $e');
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
              onTap: () async {
                downloadRoster(roster);
              },
            ),
            ListTile(
              title: Text(
                'Print',
                style: TextStyle(fontSize: 16),
              ),
              onTap: () async {
                printPDF(roster, version: _version);
              },
            ),
            ListTile(
              title: Text(
                'Export to PDF',
                style: TextStyle(fontSize: 16),
              ),
              onTap: () async {
                downloadPDF(roster, version: _version);
              },
            ),
            ListTile(
              title: Row(children: [
                Text(
                  'Elite force',
                  style: TextStyle(fontSize: 16),
                ),
                Checkbox(
                    value: roster.isEliteForce,
                    onChanged: (bool? newValue) {
                      if (newValue == null) {
                        return;
                      }
                      setState(() {
                        roster.isEliteForce = newValue;
                      });
                    })
              ]),
            ),
            ListTile(
              title: Row(children: [
                Text(
                  'Airstrike Tokens (TV:${roster.airStrikeTV})',
                  style: TextStyle(fontSize: 16),
                ),
                Tooltip(
                  message: 'Remove all airstrike counters',
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        roster.clearAirstrikes();
                      });
                    },
                    icon: const Icon(Icons.clear),
                    splashRadius: 20.0,
                    highlightColor: Colors.red,
                  ),
                )
              ]),
              onTap: () {
                var result = showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AirStrikeSelectorDialog(roster);
                    });
                result.whenComplete(() {
                  setState(() {});
                });
              },
            ),
            AboutListTile(
              applicationName: 'Gearforce',
              applicationVersion: _version,
              aboutBoxChildren: [
                Text('Gearforce is a Heavy Gear Blitz force creation tool'),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'Report any issues to ',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                        text: '$_bugEmailAddress',
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrlString(
                              'mailto:$_bugEmailAddress?subject=Gearforce%20bug',
                            );
                          }),
                  ]),
                ),
                Text(''),
                Text('Heavy Gear Blitz is a trademark of Dream Pod 9'),
                Text('Gearforce is not associated with Dream Pod 9'),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'Visit ',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                        text: '$_dp9URL',
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrlString('$_dp9URL');
                          }),
                    TextSpan(
                      text: ' for more information about',
                      style: TextStyle(color: Colors.black),
                    ),
                  ]),
                ),
                Text('Dream Pod 9 or Heavy Gear'),
                Text(''),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'Source code available at \n',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                        text: '$_sourceCodeURL',
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrlString('$_sourceCodeURL');
                          }),
                    TextSpan(
                      text: '\nunder the MIT license',
                      style: TextStyle(color: Colors.black),
                    )
                  ]),
                ),
                Text(''),
                Text('Rules version: ${roster.rulesVersion}'),
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
