import 'package:gearforce/data/unit_filter.dart';

class SpecialUnitFilter {
  final String text;
  final List<UnitFilter> filters;
  final String id;
  const SpecialUnitFilter({
    required this.text,
    required this.filters,
    required this.id,
  });
}
