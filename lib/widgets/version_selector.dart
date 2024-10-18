import 'package:flutter/material.dart';

class VersionSelector extends StatefulWidget {
  const VersionSelector();

  @override
  _VersionSelectorState createState() => _VersionSelectorState();
}

class _VersionSelectorState extends State<VersionSelector> {
  String _currentSelectedVersion = 'v3.1';
  final versions = ['v3.1']
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
        value: _currentSelectedVersion,
        items: versions,
        onChanged: (String? value) {
          if (value == null) {
            return;
          }

          setState(() {
            if (_currentSelectedVersion == value) {
              return;
            }
            _currentSelectedVersion = value;
            Navigator.pushNamed(context, '/${value}');
          });
        },
      ),
    );
  }
}
