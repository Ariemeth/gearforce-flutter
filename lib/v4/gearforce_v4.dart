import 'package:flutter/material.dart';
import 'package:gearforce/widgets/roster_id.dart';
import 'package:gearforce/widgets/roster_title.dart';
import 'package:gearforce/widgets/settings.dart';
import 'package:gearforce/widgets/version_selector.dart';

const double _titleHeight = 40.0;

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
    final title = 'Gearforce';

    final roster = RosterTitle(
      title: title,
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
    );
  }
}
