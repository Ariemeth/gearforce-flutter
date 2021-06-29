import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/unit/role.dart';

/// This is the stateful widget that the main application instantiates.
class SelectRole extends StatefulWidget {
  final Group group;

  SelectRole({
    Key? key,
    required this.group,
  }) : super(key: key);

  @override
  _SelectRoleState createState() => _SelectRoleState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _SelectRoleState extends State<SelectRole> {

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.group.role().toString().split('.').last,
      hint: Text("Select Role"),
      icon: const Icon(Icons.arrow_drop_down_outlined),
      iconSize: 24,
      elevation: 8,
      isExpanded: true,
      isDense: true,
      style: const TextStyle(color: Colors.blue),
      onChanged: (String? newValue) {
        setState(() {
          widget.group.changeRole(convertRoleType(newValue!));
        });
      },
      items: RoleType.values.map<DropdownMenuItem<String>>((value) {
        var text = value.toString().split('.').last;
        return DropdownMenuItem<String>(
          value: text,
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      }).toList(),
    );
  }
}
