import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/screens/roster/combatGroup/combat_groups_display.dart';
import 'package:gearforce/screens/roster/filehandler/downloader.dart';
import 'package:gearforce/screens/roster/filehandler/uploader.dart';
import 'package:gearforce/screens/roster/pdf/pdf.dart';
import 'package:gearforce/screens/roster/roster_header_info.dart';
import 'package:gearforce/screens/unitSelector/unit_selection.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

const double _leftPanelWidth = 670.0;
const double _titleHeight = 40.0;
const double _menuTitleHeight = 50.0;
const String _version = '0.86.4';
const String _bugEmailAddress = 'gearforce@metadiversions.com';
const String _dp9URL = 'https://www.dp9.com/';
const String _sourceCodeURL = 'https://github.com/Ariemeth/gearforce-flutter';

class RosterWidget extends StatefulWidget {
  RosterWidget({
    Key? key,
    required this.title,
    required this.data,
  }) : super(key: key);

  final String? title;
  final Data data;

  @override
  _RosterWidgetState createState() => _RosterWidgetState();
}

class _RosterWidgetState extends State<RosterWidget> {
  late UnitRoster roster;

  @override
  void initState() {
    roster = UnitRoster(widget.data);
    super.initState();
  }

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
                final loadedRoster = await loadRoster(data);
                if (loadedRoster != null) {
                  setState(() {
                    roster.copyFrom(loadedRoster);
                  });
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
                Navigator.pop(context);
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
                  'Veteran force',
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
                Text('Special thanks to James \'Corvus\' Ho for all of the \n' +
                    'help ensuring gearforce is as good as it can be.  \n' +
                    'Without Corvus\'s enthusiasm gearforce would not be \n' +
                    'where it is today.'),
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
