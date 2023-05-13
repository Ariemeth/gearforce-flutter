import 'package:flutter/material.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/rules/combat_group_options.dart';

const int _maxOptionNameLines = 2;

class OptionLine extends StatefulWidget {
  const OptionLine({super.key, required this.cg, required this.cgOption});
  final CombatGroup cg;
  final Option cgOption;

  @override
  State<OptionLine> createState() => _OptionLineState();
}

class _OptionLineState extends State<OptionLine> {
  @override
  Widget build(BuildContext context) {
    final isEnabled =
        widget.cgOption.requirementCheck(widget.cg, widget.cg.roster);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: ScrollController(),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Checkbox(
              value: widget.cg.hasTag(widget.cgOption.id),
              onChanged: isEnabled || widget.cg.hasTag(widget.cgOption.id)
                  ? (bool? newValue) {
                      setState(() {
                        widget.cgOption.SetActiveStatus(newValue!, widget.cg);
                      });
                    }
                  : null),
          Text(
            '${widget.cgOption.name} ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              decoration: isEnabled || widget.cg.hasTag(widget.cgOption.id)
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
