import 'package:flutter/material.dart';
import 'package:gearforce/v3/models/mods/modification_option.dart';

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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<ModificationOption>(
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
          ),
        )
      ],
    );

    if (widget.options.selectedOption != null &&
        widget.options.selectedOption!.hasOptions()) {
      selectionRow.children.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: OptionDropdown(options: widget.options.selectedOption!),
      ));
    }

    return selectionRow;
  }
}
