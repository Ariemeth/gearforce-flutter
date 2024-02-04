import 'package:flutter/material.dart';
import 'package:gearforce/widgets/boxed_int.dart';

class DisplayValue extends StatelessWidget {
  const DisplayValue(
      {Key? key,
      required this.text,
      required this.value,
      this.textColor = Colors.black,
      this.spacing = 5.0,
      this.padding = const EdgeInsets.only()})
      : super(key: key);

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
            style: TextStyle(fontSize: 16),
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
