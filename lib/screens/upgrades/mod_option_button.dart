import 'package:flutter/material.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/screens/upgrades/upgrade_options.dart';

class ModOptionButton extends StatefulWidget {
  ModOptionButton({
    Key? key,
    required this.mod,
    required this.isSelectable,
  }) : super(key: key);

  final BaseModification mod;
  final bool isSelectable;

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
        await results;
        setState(() {});
      },
      icon: const Icon(Icons.add_link_sharp),
    );
  }
}
