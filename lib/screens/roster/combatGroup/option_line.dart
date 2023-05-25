import 'package:flutter/material.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/rules/options/combat_group_options.dart';

const int _maxOptionNameLines = 2;

class OptionLine extends StatefulWidget {
  const OptionLine({
    super.key,
    required this.cg,
    required this.cgOption,
  });
  final CombatGroup cg;
  final CombatGroupOption cgOption;

  @override
  State<OptionLine> createState() => _OptionLineState();
}

class _OptionLineState extends State<OptionLine> {
  @override
  Widget build(BuildContext context) {
    final isAvailable =
        widget.cgOption.requirementCheck(widget.cg, widget.cg.roster);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: ScrollController(),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Checkbox(
              value: widget.cgOption.isEnabled,
              onChanged: (isAvailable || widget.cgOption.isEnabled) &&
                      widget.cgOption.canBeToggled
                  ? (bool? newValue) {
                      setState(() {
                        widget.cgOption.isEnabled = newValue!;
                      });
                    }
                  : null),
          Text(
            '${widget.cgOption.name} ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              decoration:
                  isAvailable || widget.cg.isOptionEnabled(widget.cgOption.id)
                      ? null
                      : TextDecoration.lineThrough,
            ),
            maxLines: _maxOptionNameLines,
          ),
        ],
      ),
    );
  }
}
