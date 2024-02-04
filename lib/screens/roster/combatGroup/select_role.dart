import 'package:flutter/material.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/unit/role.dart';

class SelectRole extends StatefulWidget {
  final Group group;
  final UnitRoster roster;
  final double width;

  SelectRole({
    Key? key,
    required this.group,
    required this.roster,
    required this.width,
  }) : super(key: key);

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
              value.toString().split('.').last,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      }).toList(),
    );

    return SizedBox(
      child: dropdown,
      width: widget.width,
    );
  }
}
