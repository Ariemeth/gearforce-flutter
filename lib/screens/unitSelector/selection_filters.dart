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
    final filterSelectors = roleFilter.entries
        .map((e) => FilterSelection(
            isChecked: e.value, onChanged: onChanged, role: e.key))
        .toList();

    return Row(
      children: [
        Column(
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
                ...filterSelectors
              ],
            ),
          ],
        ),
        Column(
          children: [
            Container(
              //decoration: BoxDecoration(color: Colors.green),
              child: SpecialFilterSelector(),
            ),
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

class SpecialFilterSelector extends StatefulWidget {
  const SpecialFilterSelector({Key? key}) : super(key: key);

  @override
  State<SpecialFilterSelector> createState() => _SpecialFilterSelectorState();
}

class _SpecialFilterSelectorState extends State<SpecialFilterSelector> {
  String dropdownValue = 'One';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 16,
      elevation: 16,
      isExpanded: false,
      isDense: true,
      style: const TextStyle(color: Colors.blue),
      underline: SizedBox(),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>[
        'One',
        'Two',
        'Free',
        'The best men and women in the realm'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
