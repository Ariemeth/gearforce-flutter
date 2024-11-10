import 'package:flutter/material.dart';

const String _threeOne = 'v3.1';
const String _fourZero = 'v4.0';

class VersionSelector extends StatelessWidget {
  VersionSelector(this.currentVersion, {super.key});

  static const String defaultSelectedVersion = _threeOne;
  static String get v3_1 => _threeOne;
  static String get v4_0 => _fourZero;

  //final versions = const [_3_1, _4_0];
  final versions = const [_threeOne];
  final String currentVersion;

  late final versionsDropdown = versions
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: DropdownButton<String>(
        value: currentVersion,
        items: versionsDropdown,
        onChanged: (String? value) {
          if (value == null) {
            return;
          }

          if (!versions.contains(value)) {
            return;
          }
          Navigator.pushReplacementNamed(context, '/$value');
        },
      ),
    );
  }
}
