import 'package:flutter/material.dart';
import 'package:gearforce/models/unit/unit.dart';

class UpgradesDialog extends StatelessWidget {
  UpgradesDialog({
    Key? key,
    required this.unit,
  }) : super(key: key);
  final Unit unit;
  @override
  Widget build(BuildContext context) {
    var dialog = SimpleDialog(
      title: Text('Upgrades'),
      children: [
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, null);
          },
          child: Center(
            child: Text(
              'Cancel',
              style: TextStyle(fontSize: 24, color: Colors.red),
            ),
          ),
        ),
      ],
    );
    return dialog;
  }
}
