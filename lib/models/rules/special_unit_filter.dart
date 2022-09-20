import 'package:gearforce/models/rules/rule_set.dart';

class SpecialUnitFilter {
  final String text;
  final List<UnitFilter> filters;
  const SpecialUnitFilter({
    required this.text,
    required this.filters,
  });
}
