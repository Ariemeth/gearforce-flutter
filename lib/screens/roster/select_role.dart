import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gearforce/models/unit/role.dart';

/// This is the stateful widget that the main application instantiates.
class SelectRole extends StatefulWidget {
  final ValueNotifier<String> selectedRole = ValueNotifier<String>("");

  SelectRole({Key? key}) : super(key: key);

  @override
  _SelectRoleState createState() => _SelectRoleState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _SelectRoleState extends State<SelectRole> {
  String? dropdownValue;

  _SelectRoleState();

  @override
  Widget build(BuildContext context) {
//    return SizedBox(
//      width: 100,
//      child: DropdownButton<String>(
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
          widget.selectedRole.value = newValue;
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
//      ),
    );
  }
}
