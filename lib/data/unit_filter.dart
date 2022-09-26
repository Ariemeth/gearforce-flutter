import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/unit/unit_core.dart';

class UnitFilter {
  final FactionType faction;
  final bool Function(UnitCore uc) matcher;
  const UnitFilter(this.faction, {this.matcher = _matchAll});
  static bool _matchAll(UnitCore uc) => true;
}
