import 'package:flutter/material.dart';
import 'package:gearforce/v3/models/combatGroups/combat_group.dart';
import 'package:gearforce/v3/models/rules/options/combat_group_options.dart';
import 'package:gearforce/widgets/settings.dart';
import 'package:provider/provider.dart';

const int _maxOptionNameLines = 2;

class OptionLine extends StatefulWidget {
  const OptionLine({
    super.key,
    required this.cg,
    required this.cgOption,
    required this.onLineUpdated,
  });
  final CombatGroup cg;
  final CombatGroupOption cgOption;
  final void Function() onLineUpdated;

  @override
  State<OptionLine> createState() => _OptionLineState();
}

class _OptionLineState extends State<OptionLine> {
  @override
  Widget build(BuildContext context) {
    final settings = context.read<Settings>();

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
                        widget.onLineUpdated();
                      });
                    }
                  : null),
          Tooltip(
            richMessage: WidgetSpan(
              baseline: TextBaseline.alphabetic,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 250.0),
                padding: const EdgeInsets.all(5),
                child: Text(
                  widget.cgOption.description != null
                      ? widget.cgOption.description!
                      : '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            preferBelow: true,
            waitDuration: settings.tooltipDelay,
            decoration: const BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: Text(
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
          ),
        ],
      ),
    );
  }
}
