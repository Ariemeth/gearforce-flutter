import 'package:flutter/material.dart';
import 'package:gearforce/src/localization/app_localizations.dart';
import 'package:gearforce/widgets/roster_id.dart';
import 'package:gearforce/widgets/roster_title.dart';
import 'package:gearforce/widgets/settings.dart';
import 'package:gearforce/widgets/version_selector.dart';

const double _titleHeight = 40.0;
const double _menuTitleHeight = 50.0;

class GearForceV4 extends StatefulWidget {
  const GearForceV4({
    super.key,
    required this.rosterId,
    required this.version,
    required this.versionSelector,
    required this.settings,
  });

  final RosterId rosterId;
  final String version;
  final VersionSelector versionSelector;
  final Settings settings;

  @override
  State<GearForceV4> createState() => _GearForceV4State();
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
      body: const Center(
        child: Text('Gearforce V4'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: _menuTitleHeight,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.menuTitle,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                ),
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
