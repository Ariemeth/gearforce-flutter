import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gearforce/models/mods/modification_option.dart';

class UpgradeOptions extends StatelessWidget {
  UpgradeOptions({
    Key? key,
    required this.options,
  }) : super(key: key);

  final List<ModificationOption> options;
// TODO create UI to select the different options

  @override
  Widget build(BuildContext context) {
    var screen = SimpleDialog(
      title: Center(
        child: Text('Options'),
      ),
      children: [
        ..._buildOptions(options),
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

List<Widget> _buildOptions(List<ModificationOption> options) {
  if (options.isEmpty) {
    return [];
  }

  List<Widget> results = [];

  results.add(Row(
    children: [
      OptionDropdown(options: options),
    ],
  ));

  return results;
}

class OptionDropdown extends StatefulWidget {
  OptionDropdown({
    Key? key,
    required this.options,
  }) : super(key: key);

  final List<ModificationOption> options;
  @override
  _OptionDropdownState createState() => _OptionDropdownState();
}

class _OptionDropdownState extends State<OptionDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      items: <String>['One', 'Two', 'Free', 'Four']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
