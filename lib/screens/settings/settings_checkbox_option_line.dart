import 'package:flutter/material.dart';

class SettingsCheckboxOptionLine extends StatefulWidget {
  final String text;
  final ValueChanged<bool?> onChanged;
  final EdgeInsets padding;
  final bool value;

  SettingsCheckboxOptionLine({
    required this.text,
    required this.onChanged,
    this.padding = const EdgeInsets.only(),
    this.value = true,
  });

  @override
  State<SettingsCheckboxOptionLine> createState() =>
      _SettingsCheckboxOptionLineState();
}

class _SettingsCheckboxOptionLineState
    extends State<SettingsCheckboxOptionLine> {
  bool? value;

  @override
  Widget build(BuildContext context) {
    value ??= widget.value;
    return Padding(
      padding: widget.padding,
      child: Row(
        children: [
          Text(widget.text),
          Spacer(),
          Checkbox(
            value: value,
            onChanged: (bool? newValue) {
              setState(() {
                value = newValue!;
              });
              widget.onChanged(newValue);
            },
          ),
        ],
      ),
    );
  }
}
