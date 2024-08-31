import 'package:flutter/material.dart';
import 'package:gearforce/widgets/settings.dart';
import 'package:provider/provider.dart';

class SettingsCheckboxOptionLine extends StatefulWidget {
  final String text;
  final ValueChanged<bool?> onChanged;
  final EdgeInsets padding;
  final bool value;
  final bool isEnabled;
  final String tooltipMessage;

  SettingsCheckboxOptionLine({
    required this.text,
    required this.onChanged,
    this.padding = const EdgeInsets.only(),
    this.value = true,
    this.isEnabled = true,
    this.tooltipMessage = '',
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
    final settings = context.watch<Settings>();
    value ??= widget.value;
    return Tooltip(
      message: widget.tooltipMessage,
      waitDuration: settings.tooltipDelay,
      child: Padding(
        padding: widget.padding,
        child: Row(
          children: [
            Text(widget.text),
            Spacer(),
            Checkbox(
              value: value,
              onChanged: widget.isEnabled
                  ? (bool? newValue) {
                      setState(() {
                        value = newValue!;
                      });
                      widget.onChanged(newValue);
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
