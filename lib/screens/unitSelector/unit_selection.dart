import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:provider/provider.dart';

class UnitSelection extends StatefulWidget {
  final Map<RoleType, bool> _filters = <RoleType, bool>{};

  UnitSelection() {
    RoleType.values.forEach((element) {
      _filters.addAll({element: false});
    });
  }

  @override
  _UnitSelectionState createState() => _UnitSelectionState();
}

class _UnitSelectionState extends State<UnitSelection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SelectionFilters(
          filters: widget._filters,
          onChanged: (RoleType role, bool newValue) {
            setState(() {
              widget._filters[role] = newValue;
            });
          },
        ),
        Expanded(child: SelectionList(filters: widget._filters)),
      ],
    );
  }
}

class SelectionList extends StatelessWidget {
  const SelectionList({
    Key? key,
    required this.filters,
  }) : super(key: key);

  final Map<RoleType, bool> filters;
  @override
  Widget build(BuildContext context) {
    final roster = context.watch<UnitRoster>();
    final data = context.watch<Data>();

    final List<Widget> l = [];
    final f = roster.faction.value;
    if (f != null) {
      data
          .unitList(f,
              role: this
                  .filters
                  .entries
                  .where((element) => element.value)
                  .map((e) => e.key)
                  .toList())
          .forEach((element) {
        l.add(Text('${element.name}: ${element.role}'));
      });
    }

    return SingleChildScrollView(
      child: Column(
        children: l,
      ),
    );
  }
}

class SelectionFilters extends StatelessWidget {
  const SelectionFilters({
    Key? key,
    required this.filters,
    required this.onChanged,
  }) : super(key: key);

  final Map<RoleType, bool> filters;
  final void Function(RoleType, bool) onChanged;

  @override
  Widget build(BuildContext context) {
    final List<Widget> f = [];
    this.filters.forEach((key, value) {
      f.add(
        FilterSelection(
          isChecked: value,
          role: key,
          onChanged: this.onChanged,
        ),
      );
    });
    return Row(
      children: [
        Text(
          'Filters:  ',
          style: TextStyle(fontSize: 16),
        ),
        ...f
      ],
    );
  }
}

class FilterSelection extends StatelessWidget {
  const FilterSelection({
    Key? key,
    required this.isChecked,
    required this.onChanged,
    required this.role,
  }) : super(key: key);
  final bool isChecked;
  final void Function(RoleType, bool) onChanged;
  final RoleType role;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          this.role.toString().split('.').last,
          style: TextStyle(fontSize: 16),
        ),
        Checkbox(
          value: this.isChecked,
          onChanged: (bool? value) => onChanged(this.role, value!),
        )
      ],
    );
  }
}
