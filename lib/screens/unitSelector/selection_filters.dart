import 'package:flutter/material.dart';
import 'package:gearforce/models/unit/role.dart';

const _filterHint = 'Filter using a comma separated list';

class SelectionFilters extends StatelessWidget {
  const SelectionFilters({
    Key? key,
    required this.roleFilter,
    required this.onChanged,
    required this.onFilterChanged,
  }) : super(key: key);

  final Map<RoleType, bool> roleFilter;
  final void Function(RoleType, bool) onChanged;
  final void Function(String) onFilterChanged;

  @override
  Widget build(BuildContext context) {
    var f = this
        .roleFilter
        .entries
        .map((e) => FilterSelection(
            isChecked: e.value, onChanged: this.onChanged, role: e.key))
        .toList();

    return Column(
      children: [
        Row(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Filters  ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: 400.0,
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 10, left: 5, top: 5, bottom: 5),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 5,
                    ),
                    hintText: _filterHint,
                  ),
                  onChanged: (String value) async {
                    onFilterChanged(value);
                  },
                  style: TextStyle(fontSize: 16),
                  strutStyle: StrutStyle.disabled,
                ),
              ),
            )
          ],
        ),
        Row(
          children: [
            Text(
              'Roles  ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ...f
          ],
        ),
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
