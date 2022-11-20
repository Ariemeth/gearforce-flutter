import 'package:flutter/material.dart';
import 'package:gearforce/models/factions/faction_rule.dart';

const int _maxOptionNameLines = 2;

class FactionRulesLine extends StatefulWidget {
  const FactionRulesLine({
    super.key,
    required this.upgrade,
    this.leftOffset = 0.0,
  });
  final FactionRule upgrade;
  final double leftOffset;

  @override
  State<FactionRulesLine> createState() => _FactionRulesLineState();
}

class _FactionRulesLineState extends State<FactionRulesLine> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        widget.leftOffset > 0.0
            ? SizedBox(
                width: widget.leftOffset,
              )
            : Container(),
        Checkbox(
            value: widget.upgrade.isEnabled,
            onChanged: (bool? newValue) {
              setState(() {
                // TODO add functionality
              });
            }),
        Tooltip(
          child: Text(
            '${widget.upgrade.name} ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
            ),
            maxLines: _maxOptionNameLines,
          ),
          richMessage: WidgetSpan(
            baseline: TextBaseline.alphabetic,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 250.0),
              child: Text(
                widget.upgrade.description,
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
