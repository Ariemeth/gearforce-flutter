import 'package:flutter/material.dart';
import 'package:gearforce/v3/models/combatGroups/group.dart';
import 'package:gearforce/v3/models/roster/roster.dart';
import 'package:gearforce/v3/models/unit/role.dart';

class SelectRole extends StatefulWidget {
  final Group group;
  final UnitRoster roster;
  final double width;

  const SelectRole({
    super.key,
    required this.group,
    required this.roster,
    required this.width,
  });

  @override
  _SelectRoleState createState() => _SelectRoleState();
}

class _SelectRoleState extends State<SelectRole> {
  @override
  Widget build(BuildContext context) {
    final dropdown = DropdownButton<RoleType>(
      value: widget.group.role(),
      icon: const Icon(Icons.arrow_drop_down_outlined),
      iconSize: 24,
      elevation: 8,
      isExpanded: true,
      isDense: true,
      style: const TextStyle(color: Colors.blue),
      onChanged: (RoleType? newValue) {
        setState(() {
          if (newValue == null) {
            return;
          }

          widget.group.changeRole(newValue);
        });
      },
      items: RoleType.values.map<DropdownMenuItem<RoleType>>((value) {
        return DropdownMenuItem<RoleType>(
          value: value,
          child: Center(
            child: Text(
              value.toString().split('.').last.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        );
      }).toList(),
    );

    return SizedBox(
      width: widget.width,
      child: dropdown,
    );
  }
}
