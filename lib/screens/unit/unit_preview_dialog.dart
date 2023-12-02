import 'package:flutter/material.dart';
import 'package:gearforce/models/unit/unit.dart';

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
        Container(
          decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadiusDirectional.circular(5.0)),
          child: Column(
            children: [
              _nameRow(context),
              _StatsRow(context),
              _TraitsRow(context),
              _WeaponsRow(context),
            ],
          ),
        ),
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

// TODO finish implementing
  Widget _nameRow(BuildContext context) {
    return Text(unit.name);
  }

  Widget _StatsRow(BuildContext context) {
    return Row(
      children: [
        _PrimaryStats(context),
        _SecondaryStats(context),
      ],
    );
  }

  Widget _PrimaryStats(BuildContext context) {
    return Column();
  }

  Widget _SecondaryStats(BuildContext context) {
    return Column();
  }

  Widget _TraitsRow(BuildContext context) {
    return Row(
      children: [Text(unit.traits.join(', '))],
    );
  }

  Widget _WeaponsRow(BuildContext context) {
    return Column();
  }
}
