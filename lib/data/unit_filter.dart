import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/unit/unit_core.dart';

class UnitFilter {
  final FactionType faction;
  final bool Function(UnitCore uc)? filter;
  const UnitFilter(this.faction, this.filter);
}
