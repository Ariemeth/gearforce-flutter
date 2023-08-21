import 'package:flutter/material.dart';
import 'package:gearforce/models/rules/faction_rule.dart';

const int _maxOptionNameLines = 2;

class FactionRulesLine extends StatefulWidget {
  const FactionRulesLine({
    super.key,
    required this.upgrade,
    required this.rules,
    this.leftOffset = 0.0,
    required this.notifyParent,
  });
  final FactionRule upgrade;
  final double leftOffset;
  final List<FactionRule> rules;
  final Function() notifyParent;

  @override
  State<FactionRulesLine> createState() => _FactionRulesLineState();
}

class _FactionRulesLineState extends State<FactionRulesLine> {
  @override
  Widget build(BuildContext context) {
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
          richMessage: WidgetSpan(
            baseline: TextBaseline.alphabetic,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 250.0),
              child: Text(
                upgrade.description,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                  color: Colors.white,
                ),
              ),
              padding: EdgeInsets.all(5),
            ),
          ),
          preferBelow: true,
          waitDuration: Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: const BorderRadius.all(Radius.circular(4)),
          ),
        ),
      ],
    );
  }
}
