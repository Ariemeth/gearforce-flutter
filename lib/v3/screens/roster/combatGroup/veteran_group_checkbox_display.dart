import 'package:flutter/material.dart';
import 'package:gearforce/v3/models/combatGroups/combat_group.dart';
import 'package:gearforce/widgets/settings.dart';
import 'package:provider/provider.dart';

class VeteranGroupCheckboxDisplay extends StatelessWidget {
  final EdgeInsets padding;
  final CombatGroup cg;

  const VeteranGroupCheckboxDisplay({
    super.key,
    required this.cg,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final settings = context.read<Settings>();

    final widget = Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Vet Group',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            width: 35.0,
            height: 24.0,
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Tooltip(
                message: 'Check to make this squad a veteran squad',
                waitDuration: settings.tooltipDelay,
                child: Checkbox(
                  onChanged: (bool? newValue) {
                    cg.isVeteran = newValue ?? false;
                  },
                  value: cg.isVeteran,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return widget;
  }
}
