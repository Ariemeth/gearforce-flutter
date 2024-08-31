import 'package:flutter/material.dart';
import 'package:gearforce/v3/models/unit/unit.dart';
import 'package:gearforce/v3/screens/unit/unit_card.dart';

class UnitPreviewDialog extends StatelessWidget {
  final Unit unit;

  const UnitPreviewDialog({super.key, required this.unit});
  @override
  Widget build(BuildContext context) {
    var dialog = SimpleDialog(
      contentPadding: EdgeInsets.fromLTRB(5.0, 12.0, 5.0, 12.0),
      clipBehavior: Clip.antiAlias,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      children: [
        UnitCard(unit),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, null);
          },
          child: Center(
            child: Text(
              'Done',
              style: TextStyle(fontSize: 24, color: Colors.green),
            ),
          ),
        ),
      ],
    );
    return dialog;
  }
}
