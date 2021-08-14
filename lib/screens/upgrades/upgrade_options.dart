import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gearforce/models/mods/modification_option.dart';

class UpgradeOptions extends StatelessWidget {
  UpgradeOptions({
    Key? key,
    required this.options,
  }) : super(key: key);

  final ModificationOption options;

  @override
  Widget build(BuildContext context) {
    var screen = SimpleDialog(
      title: Center(
        child: Text(options.text),
      ),
      children: [
        OptionDropdown(options: options),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, null);
          },
          child: Center(
            child: Text(
              'Done',
              style: TextStyle(fontSize: 24, color: Colors.green),
            ),
          ),
        ),
      ],
    );
    return screen;
  }
}

class OptionDropdown extends StatefulWidget {
  OptionDropdown({
    Key? key,
    required this.options,
  }) : super(key: key);

  final ModificationOption options;

  @override
  _OptionDropdownState createState() => _OptionDropdownState();
}

class _OptionDropdownState extends State<OptionDropdown> {
  @override
  Widget build(BuildContext context) {
    var selectionRow = Row(
      children: [
        DropdownButton<ModificationOption>(
          value: widget.options.selectedOption,
          hint: Text('Choose'),
          onChanged: (ModificationOption? newValue) {
            setState(() {
              widget.options.selectedOption = newValue;
            });
          },
          items: widget.options.subOptions!
              .map<DropdownMenuItem<ModificationOption>>(
                  (ModificationOption value) {
            return DropdownMenuItem<ModificationOption>(
              value: value,
              child: Text(value.text),
            );
          }).toList(),
        )
      ],
    );

    if (widget.options.selectedOption != null &&
        widget.options.selectedOption!.hasOptions()) {
      selectionRow.children
          .add(OptionDropdown(options: widget.options.selectedOption!));
    }

    return selectionRow;
  }
}
