import 'package:flutter/material.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';

class UpgradesDialog extends StatelessWidget {
  UpgradesDialog({
    Key? key,
    required this.unit,
  }) : super(key: key);

  final Unit unit;

  @override
  Widget build(BuildContext context) {
    var dialog = SimpleDialog(
      title: Center(
        child: Text(
          'Upgrades',
          style: TextStyle(fontSize: 24),
        ),
      ),
      children: [
        Column(
          children: [
            Text(
              unit.attribute(UnitAttribute.name),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Container(
              child: Column(
                  // create listview with available upgrades
                  ),
            ),
          ],
        ),
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
