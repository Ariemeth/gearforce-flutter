import 'package:flutter/material.dart';
import 'package:gearforce/v3/models/unit/unit.dart';
import 'package:gearforce/v3/screens/unitSelector/unit_selection_text_cell.dart';

class SelectedUnitFeedback extends StatelessWidget {
  final Unit unit;
  const SelectedUnitFeedback({
    super.key,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(225, 187, 222, 251),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UnitSelectionTextCell.draggableFeedback(
            'Model: ${unit.name}',
          ),
          UnitSelectionTextCell.draggableFeedback(
            'TV: ${unit.tv}',
          ),
          UnitSelectionTextCell.draggableFeedback(
            'Roles: ${unit.role == null ? '-' : unit.role!.roles.join(', ')}',
          ),
          UnitSelectionTextCell.draggableFeedback(
            'Weapons: ${unit.weapons.join(', ')}',
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}
