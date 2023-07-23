import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/unit/unit_core.dart';

class SpecialUnitFilter {
  final String text;
  final List<UnitFilter> filters;
  final String id;
  const SpecialUnitFilter({
    required this.text,
    required this.filters,
    required this.id,
  });
  bool anyMatch(UnitCore uc) => filters.any((filter) => filter.isMatch(uc));
}
