import 'package:flutter/material.dart';
import 'package:gearforce/v3/models/unit/unit.dart';
import 'package:gearforce/v3/screens/unitSelector/unit_selector_text_cell.dart';

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
          UnitSelectorTextCell.draggableFeedback(
            'Model: ${unit.name}',
          ),
          UnitSelectorTextCell.draggableFeedback(
            'TV: ${unit.tv}',
          ),
          UnitSelectorTextCell.draggableFeedback(
            'Roles: ${unit.role == null ? '-' : unit.role!.roles.join(', ')}',
          ),
          UnitSelectorTextCell.draggableFeedback(
            'Weapons: ${unit.weapons.join(', ')}',
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}
