import 'package:gearforce/data/unit_filter.dart';

class SpecialUnitFilter {
  final String text;
  final List<UnitFilter> filters;
  const SpecialUnitFilter({
    required this.text,
    required this.filters,
  });
}
