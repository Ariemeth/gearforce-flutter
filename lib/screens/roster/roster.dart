import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/screens/roster/filehandler/downloader.dart';
import 'package:gearforce/screens/roster/filehandler/uploader.dart';
import 'package:gearforce/screens/roster/input_roster_id.dart';
import 'package:gearforce/screens/roster/markdown.dart';
import 'package:gearforce/screens/roster/pdf/pdf.dart';
import 'package:gearforce/screens/roster/pdf/pdf_settings_dialog.dart';
import 'package:gearforce/screens/roster/roster_display.dart';
import 'package:gearforce/screens/roster/show_roster_id.dart';
import 'package:gearforce/screens/unitSelector/unit_selection.dart';
import 'package:gearforce/widgets/api/api_service.dart';
import 'package:gearforce/widgets/confirmation_dialog.dart';
import 'package:gearforce/widgets/pdf_settings.dart';
import 'package:gearforce/widgets/roster_id.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

const double _leftPanelWidth = 670.0;
const double _titleHeight = 40.0;
const double _menuTitleHeight = 50.0;
const String _version = '1.3.5';
const String _bugEmailAddress = 'gearforce@metadiversions.com';
const String _dp9URL = 'https://www.dp9.com/';
const String _sourceCodeURL = 'https://github.com/Ariemeth/gearforce-flutter';

class RosterWidget extends StatefulWidget {
  RosterWidget({
    Key? key,
    required this.title,
    required this.data,
    required this.rosterId,
  }) : super(key: key);

  final String? title;
  final Data data;
  final RosterId rosterId;
  final hScrollController = ScrollController();

  @override
  _RosterWidgetState createState() => _RosterWidgetState();
}

class _RosterWidgetState extends State<RosterWidget> {
  late UnitRoster roster;

  @override
  void initState() {
    super.initState();

    roster = UnitRoster(widget.data);
    _loadRoster();
  }

  void _loadRoster() async {
    if (widget.rosterId.Id == null) {
      return;
    }

    final loadedRoster = await await ApiService.getRoster(
      widget.data,
      widget.rosterId.Id!,
    );
    if (loadedRoster != null) {
      roster.copyFrom(loadedRoster);
    }
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
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ChangeNotifierProvider(
        create: (_) => roster,
        child: Scrollbar(
          controller: widget.hScrollController,
          thumbVisibility: true,
          trackVisibility: true,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: widget.hScrollController,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RosterDisplay(width: _leftPanelWidth, height: 1000),
                UnitSelection(),
              ],
            ),
          ),
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
                'Load from file',
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
                'Load from id',
                style: TextStyle(fontSize: 16),
              ),
              onTap: () async {
                final loadedRoster = await showInputRosterId(context, data);
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
                'Save to file',
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
                'Save to Gearforce Online',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () async {
                await showRosterIdDialog(context, roster);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Print',
                style: TextStyle(fontSize: 16),
              ),
              onTap: () async {
                final pdfSettings = await showDialog<PDFSettings>(
                  context: context,
                  builder: (context) => PDFSettingsDialog('Print'),
                );

                if (pdfSettings != null) {
                  printPDF(roster, pdfSettings, version: _version);
                }
              },
            ),
            ListTile(
              title: Text(
                'Export to PDF',
                style: TextStyle(fontSize: 16),
              ),
              onTap: () async {
                final pdfSettings = await showDialog<PDFSettings>(
                  context: context,
                  builder: (context) => PDFSettingsDialog('Export to PDF'),
                );

                if (pdfSettings != null) {
                  downloadPDF(roster, pdfSettings, version: _version);
                }
              },
            ),
            ListTile(
              title: Text(
                'Generate Markdown',
                style: TextStyle(fontSize: 16),
              ),
              onTap: () async {
                showGeneratedMarkdown(context, roster);
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.clear_sharp),
        foregroundColor: Colors.red,
        mini: true,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ConfirmationDialog(
                text: 'Are you sure you want to reset everything?',
                onOptionSelected: (result) {
                  if (result == ConfirmationResult.Yes) {
                    setState(
                      () {
                        roster.copyFrom(UnitRoster(data));
                      },
                    );
                  }
                },
              );
            },
          );
        },
        tooltip: 'Reset roster',
      ),
    );
  }
}
