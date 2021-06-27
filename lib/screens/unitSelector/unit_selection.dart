import 'package:flutter/material.dart';
import 'package:gearforce/models/unit/role.dart';

class UnitSelection extends StatefulWidget {
  final Map<RoleType, bool> _filters = new Map<RoleType, bool>();
  @override
  _UnitSelectionState createState() => _UnitSelectionState();
}

class _UnitSelectionState extends State<UnitSelection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SelectionFilter(),
        SelectionList(),
      ],
    );
  }
}

class SelectionList extends StatelessWidget {
  const SelectionList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column();
  }
}

class SelectionFilter extends StatelessWidget {
  const SelectionFilter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row();
  }
}
