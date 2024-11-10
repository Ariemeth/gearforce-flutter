import 'package:flutter/material.dart';
import 'package:gearforce/v3/models/rules/rule.dart';
import 'package:gearforce/widgets/settings.dart';
import 'package:provider/provider.dart';

const int _maxOptionNameLines = 2;

class FactionRulesLine extends StatefulWidget {
  const FactionRulesLine({
    super.key,
    required this.upgrade,
    required this.rules,
    this.leftOffset = 0.0,
    required this.notifyParent,
  });
  final Rule upgrade;
  final double leftOffset;
  final List<Rule> rules;
  final Function() notifyParent;

  @override
  State<FactionRulesLine> createState() => _FactionRulesLineState();
}

class _FactionRulesLineState extends State<FactionRulesLine> {
  @override
  Widget build(BuildContext context) {
    final settings = context.read<Settings>();
    final upgrade = widget.upgrade;
    final meetsReqs = upgrade.requirementCheck(widget.rules);
    final canBeToggled = upgrade.canBeToggled && meetsReqs;
    return Row(
      children: [
        widget.leftOffset > 0.0
            ? SizedBox(
                width: widget.leftOffset,
              )
            : Container(),
        Checkbox(
            value: upgrade.isEnabled,
            onChanged: canBeToggled
                ? (bool? newValue) {
                    setState(() {
                      upgrade.setIsEnabled(newValue!, widget.rules);
                      widget.notifyParent();
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
                upgrade.description,
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
            '${upgrade.name} ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              decoration: meetsReqs ? null : TextDecoration.lineThrough,
            ),
            maxLines: _maxOptionNameLines,
          ),
        ),
      ],
    );
  }
}
