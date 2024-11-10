import 'package:flutter/material.dart';
import 'package:gearforce/widgets/boxed_int.dart';

class RosterTVTotalsDisplayLine extends StatelessWidget {
  const RosterTVTotalsDisplayLine({
    super.key,
    required this.text,
    required this.value,
    this.textColor = Colors.black,
    this.spacing = 8.0,
    this.padding = const EdgeInsets.only(left: 5, top: 5),
  });

  final int value;
  final Color textColor;
  final String text;
  final double spacing;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    Widget display;

    display = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        BoxedInt(
          value: value,
          textColor: textColor,
        ),
        Padding(
          padding: EdgeInsets.only(left: spacing),
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );

    return Padding(
      padding: padding,
      child: display,
    );
  }
}
