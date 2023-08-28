import 'package:flutter/material.dart';
import 'package:gearforce/screens/roster/combatGroup/combat_groups_display.dart';
import 'package:gearforce/screens/roster/roster_header_info.dart';

class RosterDisplay extends StatelessWidget {
  const RosterDisplay({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final vScrollController = ScrollController();

    return Scrollbar(
      scrollbarOrientation: ScrollbarOrientation.left,
      trackVisibility: true,
      controller: vScrollController,
      interactive: true,
      child: SingleChildScrollView(
        controller: vScrollController,
        child: SizedBox(
          width: width,
          height: height,
          child: Column(
            children: [
              RosterHeaderInfo(),
              CombatGroupsDisplay(),
            ],
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
          ),
        ),
      ),
    );
  }
}
