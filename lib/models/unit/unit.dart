import 'package:gearforce/models/unit/modification.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/unit/unit_core.dart';

class Unit {
  Unit({
    required this.core,
  });

  final UnitCore core;
  final List<Modification> _unitMods = [];

  dynamic attribute(UnitAttribute att) {
    var value = this.core.attribute(att);

    for (var mod in this._unitMods) {
      value = mod.applyMods(att, value);
    }

    return value;
  }

  void addUnitMod(Modification mod) => _unitMods.add(mod);
  void removeUnitMod(String modName) =>
      _unitMods.removeWhere((mod) => mod.name == modName);
  int numUnitMods() => _unitMods.length;
  void clearUnitMods() => _unitMods.clear();
}
