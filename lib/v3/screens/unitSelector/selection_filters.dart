import 'package:flutter/material.dart';
import 'package:gearforce/v3/models/roster/roster.dart';
import 'package:gearforce/v3/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/v3/models/unit/role.dart';
import 'package:provider/provider.dart';

const _filterHint = 'Filter using a comma separated list';

class SelectionFilters extends StatelessWidget {
  const SelectionFilters({
    Key? key,
    required this.roleFilter,
    required this.onRoleFilterChanged,
    required this.onFilterChanged,
    required this.onSpecialUnitFilterChanged,
  }) : super(key: key);

  final Map<RoleType, bool> roleFilter;
  final void Function(RoleType, bool) onRoleFilterChanged;
  final void Function(String) onFilterChanged;
  final void Function(SpecialUnitFilter) onSpecialUnitFilterChanged;

  @override
  Widget build(BuildContext context) {
    final filterSelectors = roleFilter.entries
        .map((e) => FilterSelection(
            isChecked: e.value, onChanged: onRoleFilterChanged, role: e.key))
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
              child: SpecialFilterSelector(
                onChanged: this.onSpecialUnitFilterChanged,
              ),
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
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Row(
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
      ),
    );
  }
}

class SpecialFilterSelector extends StatefulWidget {
  const SpecialFilterSelector({
    Key? key,
    required this.onChanged,
  }) : super(key: key);
  final void Function(SpecialUnitFilter) onChanged;

  @override
  State<SpecialFilterSelector> createState() => _SpecialFilterSelectorState();
}

class _SpecialFilterSelectorState extends State<SpecialFilterSelector> {
  SpecialUnitFilter? dropdownValue;

  @override
  Widget build(BuildContext context) {
    final subFaction =
        context.select((UnitRoster roster) => roster.rulesetNotifer.value);
    final cgOptions =
        context.select((UnitRoster roster) => roster.activeCG()?.options);

    final availableSpecialFilters = subFaction.availableUnitFilters(cgOptions);
    assert(availableSpecialFilters.length != 0);

    if (!availableSpecialFilters.contains(dropdownValue)) {
      dropdownValue = availableSpecialFilters
          .firstWhere((sf) => sf.id == dropdownValue?.id, orElse: () {
        return availableSpecialFilters.first;
      });
    }

    return DropdownButton<SpecialUnitFilter>(
        value: dropdownValue,
        icon: const Icon(Icons.arrow_downward),
        iconSize: 16,
        elevation: 16,
        isExpanded: false,
        isDense: true,
        style: const TextStyle(color: Colors.blue),
        underline: SizedBox(),
        onChanged: (SpecialUnitFilter? newValue) {
          setState(() {
            dropdownValue = newValue!;
            widget.onChanged(newValue);
          });
        },
        items: availableSpecialFilters
            .map<DropdownMenuItem<SpecialUnitFilter>>((specialFilter) =>
                DropdownMenuItem<SpecialUnitFilter>(
                    value: specialFilter, child: Text(specialFilter.text)))
            .toList());
  }
}
