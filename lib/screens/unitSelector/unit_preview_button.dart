import 'package:flutter/material.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/screens/unit/unit_preview_dialog.dart';

const _buttonIcon = Icons.drag_indicator;

class UnitPreviewButton extends StatelessWidget {
  final Unit unit;

  const UnitPreviewButton({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    var button = IconButton(
      onPressed: () => {_showUnitPreviewDialog(context, unit)},
      icon: Icon(_buttonIcon),
      splashRadius: 10.0,
      padding: EdgeInsets.zero,
      tooltip: 'Preview Unit',
    );

    return button;
  }

  void _showUnitPreviewDialog(BuildContext context, Unit unit) {
    final unitPreviewDialog = UnitPreviewDialog(unit: unit);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return unitPreviewDialog;
        });
  }
}
