import 'package:flutter/material.dart';
import 'package:gearforce/v3/models/mods/modification_option.dart';
import 'package:gearforce/v3/screens/upgrades/option_dropdown.dart';

class UpgradeOptions extends StatelessWidget {
  const UpgradeOptions({
    super.key,
    required this.options,
  });

  final ModificationOption options;

  @override
  Widget build(BuildContext context) {
    var screen = SimpleDialog(
      shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Center(
        child: Text(options.text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            )),
      ),
      children: [
        SizedBox(
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
          child: const Center(
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
