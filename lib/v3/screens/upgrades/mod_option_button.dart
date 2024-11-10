import 'package:flutter/material.dart';
import 'package:gearforce/v3/models/mods/base_modification.dart';
import 'package:gearforce/v3/screens/upgrades/upgrade_options.dart';

class ModOptionButton extends StatefulWidget {
  const ModOptionButton({
    super.key,
    required this.mod,
    required this.isSelectable,
    required this.onChanged,
  });

  final BaseModification mod;
  final bool isSelectable;
  final Function onChanged;

  @override
  _ModOptionButtonState createState() => _ModOptionButtonState();
}

class _ModOptionButtonState extends State<ModOptionButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: widget.mod.options!.selectionComplete()
          ? Colors.green
          : widget.isSelectable
              ? Colors.red
              : Colors.black,
      tooltip: 'This upgrade has options to select.',
      onPressed: () async {
        var results = showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return UpgradeOptions(
                options: widget.mod.options!,
              );
            });
        results.whenComplete(() {
          widget.onChanged();
        });
      },
      icon: const Icon(Icons.add_link_sharp),
    );
  }
}
