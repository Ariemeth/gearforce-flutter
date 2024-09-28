import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gearforce/v3/models/combatGroups/group.dart';
import 'package:gearforce/v3/models/roster/roster.dart';
import 'package:gearforce/v3/models/unit/command.dart';
import 'package:gearforce/v3/models/unit/unit.dart';

void showGeneratedMarkdown(
  BuildContext context,
  UnitRoster roster,
) {
  var result = showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return MarkdownDialog(roster);
      });

  result.whenComplete(() {});
}

class MarkdownDialog extends StatelessWidget {
  const MarkdownDialog(this.roster);

  final UnitRoster roster;
  @override
  Widget build(BuildContext context) {
    final markdownText = _buildMarkdown();

    return SimpleDialog(
      children: [
        Padding(
          padding: EdgeInsets.all(6.0),
          child: SelectableText(markdownText),
        ),
        SimpleDialogOption(
          onPressed: () {
            Clipboard.setData(
              new ClipboardData(text: markdownText),
            );
            Navigator.pop(context, null);
          },
          child: Center(
            child: Text(
              'Copy to Clipboard',
              style: TextStyle(fontSize: 24, color: Colors.green),
            ),
          ),
        ),
      ],
    );
  }

  String _buildMarkdown() {
    String results = '';
    final faction = roster.factionNotifier.value.name;
    final subFaction = roster.rulesetNotifer.value.name;
    var header = '# $faction';
    if (subFaction.isNotEmpty) {
      header += '- ${roster.rulesetNotifer.value.name}';
    }

    header += ' TV(${roster.totalTV()})\n\n';

    results += header;

    roster.getCGs().where((cg) => cg.numberOfUnits() > 0).forEach((cg) {
      final cgHeader = '## ${cg.name} - TV(${cg.totalTV()})\n';
      final primaryGroup = _buildGroupMarkdown(cg.primary);
      final secondaryGroup = _buildGroupMarkdown(cg.secondary);
      results += cgHeader;
      if (primaryGroup != null) {
        results += primaryGroup;
      }
      if (secondaryGroup != null) {
        results += secondaryGroup;
      }
      results += '\n';
    });

    return results;
  }

  String? _buildGroupMarkdown(Group group) {
    if (group.numberOfUnits() == 0) {
      return null;
    }
    final groupType = group.groupType.name;
    final role = group.role().name;
    final actions = group.totalActions;
    final totalTv = group.totalTV();

    String result = '';

    final header =
        '### $groupType - $role - Actions($actions) - TV($totalTv)\n';
    result += header;

    group.allUnits().forEach((unit) {
      result += _buildUnitMarkdown(unit);
    });

    return result;
  }

  String _buildUnitMarkdown(Unit unit) {
    var result = '';

    final name = unit.core.name;
    final tv = unit.tv;
    final rank = unit.commandLevel;
    final rankCost = roster.rulesetNotifer.value.commandTVCost(rank);
    final isForceLeader = roster.selectedForceLeader == unit;
    final mods = unit.modNamesWithCost.join(', ').replaceAll(' Upgrade', '');

    result += '* $name - TV($tv)';
    if (rank != CommandLevel.none) {
      result += ' - ${rank.name}($rankCost)';
      if (isForceLeader) {
        result += '(**FL**)';
      }
    }

    if (mods.isNotEmpty) {
      result += ' - $mods';
    }

    result += '\n';
    return result;
  }
}

/* Example output
# Peace River - Peace River Defense Force (90 TV)

## CG1 - TV(46)
### Primary - GP - Actions(4) - TV(27)
* Warrior - TV(7) - CGL** - Chieftain(1)
* Warrior - TV(6)
* Vanguard Warrior TV(7)
* Sweeper Warrior - TV(7) - Spectre(1)
### Secondary - FS - Actions(2) - TV(19)
* Skirmisher - TV(10) - Tag(1)
* Scourge Skirmisher - TV(9)

## CG2 - TV(44)
### Primary - RC - Actions(4) - TV(44)
* Greyhound - TV(13) - CGL - Chieftain(2)
* Greyhound - TV(11)
* Harrier - TV(11)
* Skirmisher - TV(9)

*/
