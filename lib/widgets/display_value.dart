import 'package:flutter/material.dart';
import 'package:gearforce/widgets/boxed_int.dart';

class DisplayValue extends StatelessWidget {
  const DisplayValue(
      {super.key,
      required this.text,
      required this.value,
      this.textColor = Colors.black,
      this.spacing = 5.0,
      this.padding = const EdgeInsets.only()});

  final int value;
  final Color textColor;
  final String text;
  final double spacing;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final widget = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(right: spacing),
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        BoxedInt(
          value: value,
          textColor: textColor,
        )
      ],
    );

    return Padding(
      padding: padding,
      child: widget,
    );
  }
}
