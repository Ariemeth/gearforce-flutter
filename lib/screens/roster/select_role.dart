import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gearforce/models/unit/role.dart';

/// This is the stateful widget that the main application instantiates.
class SelectRole extends StatefulWidget {
  final ValueNotifier<RoleType?>? selectedRole;
  final ValueChanged<RoleType>? onSelected;
  final String _defaultRole = RoleType.GP.toString().split('.').last;

  SelectRole({Key? key, this.selectedRole, this.onSelected}) : super(key: key);

  @override
  _SelectRoleState createState() =>
      _SelectRoleState(this.selectedRole?.value == null
          ? this._defaultRole
          : this.selectedRole?.value.toString().split('.').last);
}

/// This is the private State class that goes with MyStatefulWidget.
class _SelectRoleState extends State<SelectRole> {
  String? dropdownValue;

  _SelectRoleState(String? selection) {
    this.dropdownValue = selection ?? widget._defaultRole;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      hint: Text("Select Role"),
      icon: const Icon(Icons.arrow_downward),
      iconSize: 16,
      elevation: 16,
      isExpanded: true,
      isDense: true,
      style: const TextStyle(color: Colors.blue),
      underline: SizedBox(),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
          widget.selectedRole?.value = convertRoleType(newValue);
          if (widget.onSelected != null) {
            widget.onSelected!(convertRoleType(newValue));
          }
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
