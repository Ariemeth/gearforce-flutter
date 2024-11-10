import 'package:flutter/material.dart';
import 'package:gearforce/widgets/version_checker.dart';
import 'package:gearforce/widgets/version_selector.dart';

class RosterTitle extends StatelessWidget {
  const RosterTitle({
    super.key,
    required this.title,
    required this.versionSelector,
    required this.version,
  });

  final String title;
  final VersionSelector versionSelector;
  final String version;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title),
        versionSelector,
        const Spacer(),
        VersionChecker(
          currentVersion: version,
        ),
      ],
    );
  }
}
