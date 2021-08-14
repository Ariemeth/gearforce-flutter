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
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Center(
        child: Text(options.text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            )),
      ),
      children: [
        Container(
          width: 120,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              options.description,
              maxLines: 6,
            ),
          ),
        ),
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
