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
