import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsValueOptionLine extends StatefulWidget {
  final String text;
  final ValueChanged<int?> onChanged;
  final int value;
  final String inputFormatter;
  final EdgeInsets padding;

  SettingsValueOptionLine({
    required this.text,
    required this.value,
    required this.onChanged,
    this.inputFormatter = r"^\d{0,4}",
    this.padding = const EdgeInsets.only(),
  });

  @override
  State<SettingsValueOptionLine> createState() =>
      _SettingsValueOptionLineState();
}

class _SettingsValueOptionLineState extends State<SettingsValueOptionLine> {
  int? tempValue;

  @override
  Widget build(BuildContext context) {
    tempValue = widget.value;
    return Padding(
      padding: widget.padding,
      child: Row(
        children: [
          Text(widget.text),
          Spacer(),
          SizedBox(
            width: 50,
            child: TextField(
              controller: TextEditingController(
                text: tempValue == null
                    ? widget.value.toString()
                    : tempValue.toString(),
              ),
              decoration: const InputDecoration(
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.only(
                  left: 5,
                  right: 5,
                  top: 3,
                  bottom: 3,
                ),
                isDense: true,
              ),
              onChanged: (String newValue) {
                final value = int.tryParse(newValue);
                if (value == null) {
                  return;
                }
                tempValue = value;
              },
              onEditingComplete: () {
                if (tempValue != null) {
                  widget.onChanged(tempValue);
                }
              },
              onTapOutside: (event) {
                if (tempValue != null) {
                  widget.onChanged(tempValue);
                }
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(widget.inputFormatter))
              ],
            ),
          )
        ],
      ),
    );
  }
}
