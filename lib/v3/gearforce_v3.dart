import 'package:flutter/material.dart';
import 'package:gearforce/v3/data/data.dart';
import 'package:gearforce/v3/screens/roster/roster.dart';
import 'package:gearforce/widgets/roster_id.dart';
import 'package:gearforce/widgets/settings.dart';
import 'package:gearforce/widgets/version_selector.dart';
import 'package:provider/provider.dart';

class GearForceV3 extends StatefulWidget {
  const GearForceV3({
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
  _GearForceV3State createState() => _GearForceV3State();
}

class _GearForceV3State extends State<GearForceV3> {
  _GearForceV3State();

  final DataV3 _v3Data = DataV3();

  @override
  void initState() {
    super.initState();

    if (!widget.settings.isInitialized) {
      widget.settings.load().then((_) {
        _v3Data.load(widget.settings).whenComplete(() {
          setState(() {});
        });
      });
    } else {
      _v3Data.load(widget.settings).whenComplete(() {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Gearforce';

    return MultiProvider(
      providers: [
        Provider<DataV3>(create: (_) => _v3Data),
      ],
      child: RosterWidget(
        title: title,
        data: _v3Data,
        rosterId: widget.rosterId,
        version: widget.version,
        settings: widget.settings,
        versionSelector: widget.versionSelector,
      ),
    );
  }
}
