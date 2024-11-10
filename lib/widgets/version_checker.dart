import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gearforce/widgets/api/api_service.dart';
import 'package:gearforce/widgets/settings.dart';
import 'package:provider/provider.dart';
import 'package:pub_semver/pub_semver.dart';

class VersionChecker extends StatefulWidget {
  late final Version currentVersion;

  VersionChecker({
    super.key,
    required String currentVersion,
  }) {
    this.currentVersion = Version.parse(currentVersion);
  }

  @override
  State<VersionChecker> createState() => _VersionCheckerState();
}

class _VersionCheckerState extends State<VersionChecker> {
  Version? latestVersion;

  @override
  void initState() {
    super.initState();
    _checkForUpdatedVersion();
    Timer.periodic(const Duration(seconds: 600), (timer) async {
      _checkForUpdatedVersion();
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.read<Settings>();
    final isOutdated =
        latestVersion != null && widget.currentVersion < latestVersion!;
    if (latestVersion == null || !isOutdated) {
      return Container();
    }

    // TODO change message for desktop app before making it available
    return Tooltip(
      message: 'Refresh the page to get the latest version',
      waitDuration: settings.tooltipDelay,
      child: Text(
        'New version available: ${latestVersion.toString()}',
        style: const TextStyle(color: Colors.amber),
      ),
    );
  }

  void _checkForUpdatedVersion() async {
    final latestVersionStr = await ApiService.getLatestVersion(Uri.base);
    if (latestVersionStr == null || latestVersionStr.isEmpty) {
      if (this.latestVersion != null) {
        setState(() {
          this.latestVersion = null;
        });
      }
      return;
    }

    final latestVersion = Version.parse(latestVersionStr);
    if (latestVersion != widget.currentVersion) {
      setState(() {
        this.latestVersion = latestVersion;
      });
    }
  }
}
