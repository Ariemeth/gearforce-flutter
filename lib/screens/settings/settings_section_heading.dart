import 'package:flutter/material.dart';

class SettingsSectionHeading extends StatelessWidget {
  final String text;
  final EdgeInsets padding;
  const SettingsSectionHeading(
    this.text, {
    super.key,
    this.padding = const EdgeInsets.all(2.5),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
