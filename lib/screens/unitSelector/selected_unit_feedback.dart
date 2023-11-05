import 'package:flutter/material.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/screens/unitSelector/unit_selection_text_Cell.dart';

class SelectedUnitFeedback extends StatelessWidget {
  final Unit unit;
  const SelectedUnitFeedback({
    Key? key,
    required this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(225, 187, 222, 251),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UnitSelectionTextCell.draggableFeedback(
            'Model: ${this.unit.name}',
          ),
          UnitSelectionTextCell.draggableFeedback(
            'TV: ${this.unit.tv}',
          ),
          UnitSelectionTextCell.draggableFeedback(
            'Roles: ${this.unit.role == null ? '-' : this.unit.role!.roles.join(', ')}',
          ),
          UnitSelectionTextCell.draggableFeedback(
            'Weapons: ${this.unit.weapons.join(', ')}',
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}
