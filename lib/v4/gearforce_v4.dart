import 'package:flutter/material.dart';
import 'package:gearforce/widgets/roster_id.dart';
import 'package:gearforce/widgets/roster_title.dart';
import 'package:gearforce/widgets/settings.dart';
import 'package:gearforce/widgets/version_selector.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const double _titleHeight = 40.0;
const double _menuTitleHeight = 50.0;

class GearForceV4 extends StatefulWidget {
  const GearForceV4({
    Key? key,
    required this.rosterId,
    required this.version,
    required this.versionSelector,
    required this.settings,
  }) : super(key: key);

  final RosterId rosterId;
  final String version;
  final VersionSelector versionSelector;
  final Settings settings;

  @override
  _GearForceV4State createState() => _GearForceV4State();
}

class _GearForceV4State extends State<GearForceV4> {
  _GearForceV4State();

  @override
  void initState() {
    super.initState();

    _loadSettings();
  }

  void _loadSettings() async {
    if (!widget.settings.isInitialized) {
      await widget.settings.load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final roster = RosterTitle(
      title: AppLocalizations.of(context)!.appTitle,
      versionSelector: widget.versionSelector,
      version: widget.version,
    );

    return Scaffold(
      appBar: AppBar(
        title: roster,
        toolbarHeight: _titleHeight,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Text('Gearforce V4'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: _menuTitleHeight,
              child: DrawerHeader(
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.menuTitle,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              ),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.menuSettingsTitle),
              onTap: () {
                Navigator.pop(context);
                //  Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
      ),
    );
  }
}
