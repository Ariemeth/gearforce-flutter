import 'package:flutter/material.dart';

class BoxedInt extends StatelessWidget {
  BoxedInt({
    Key? key,
    required this.value,
    this.textColor = Colors.black,
    this.borderColor = Colors.grey,
    this.width = 30.0,
  }) : super(key: key);

  final int value;
  final Color textColor;
  final Color borderColor;
  final Color backgroundColor = Colors.grey[300]!;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Text(
        value.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: this.textColor),
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          top: BorderSide(color: borderColor),
          bottom: BorderSide(color: borderColor),
          right: BorderSide(color: borderColor),
          left: BorderSide(color: borderColor),
        ),
      ),
    );
  }
}
