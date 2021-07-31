import 'package:flutter/material.dart';
import 'package:gearforce/models/unit/unit_core.dart';
import 'package:gearforce/screens/unitSelector/unit_selection_text_Cell.dart';

class SelectedUnitFeedback extends StatelessWidget {
  final UnitCore uc;
  const SelectedUnitFeedback({
    Key? key,
    required this.uc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UnitSelectionTextCell.draggableFeedback(
            'Model: ${this.uc.name}',
          ),
          UnitSelectionTextCell.draggableFeedback(
            'TV: ${this.uc.tv}',
          ),
          UnitSelectionTextCell.draggableFeedback(
            'Roles: ${this.uc.role == null ? '-' : this.uc.role!.roles.join(', ')}',
          ),
        ],
      ),
    );
  }
}
