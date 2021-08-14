import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/mods/veteranUpgrades/veteran_modification.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:uuid/uuid.dart';

final duelistId = Uuid().v4();

class DuelistModification extends BaseModification {
  DuelistModification({
    required String name,
    required String id,
    this.requirementCheck = _defaultRequirementsFunction,
    this.unit,
    this.roster,
  }) : super(name: name, id: id);

  // function to ensure the modification can be applied to the unit
  final bool Function() requirementCheck;
  final Unit? unit;
  final UnitRoster? roster;

  static bool _defaultRequirementsFunction() => true;

  factory DuelistModification.makeDuelist(Unit u, UnitRoster roster) {
    final traits = u.traits.toList();
    final isVet = u.core.traits.contains('Vet') || u.hasMod(veteranId);
    var mod = DuelistModification(
        name: 'Duelist Upgrade',
        id: duelistId,
        requirementCheck: () {
          if (u.hasMod(duelistId)) {
            return false;
          }

          if (u.type != 'Gear') {
            return false;
          }

          for (final cg in roster.getCGs()) {
            if (cg.hasDuelist()) {
              return false;
            }
          }

          return !traits.contains('Duelist');
        });
    mod.addMod(
      UnitAttribute.tv,
      (value) {
        return createSimpleIntMod(
          u.core.traits.contains('Vet') || u.hasMod(veteranId) ? 0 : 2,
        )(value);
      },
      description: 'TV +${isVet ? 0 : 2}',
    );
    mod.addMod(
      UnitAttribute.traits,
      createAddToList('Duelist'),
      description: '+Duelist',
    );

    if (!isVet) {
      mod.addMod(
        UnitAttribute.traits,
        createAddToList('Vet'),
        description: '+Vet',
      );
    }
    return mod;
  }
}
