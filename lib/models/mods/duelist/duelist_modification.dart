import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/mods/veteranUpgrades/veteran_modification.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:uuid/uuid.dart';

final duelistId = Uuid().v4();
final aceGunnerId = Uuid().v4();
final advancedControlSystemId = Uuid().v4();
final crackShotId = Uuid().v4();
final defenderId = Uuid().v4();
final dualWieldId = Uuid().v4();
final gunslingerId = Uuid().v4();
final lungeId = Uuid().v4();
final pushTheEnvelopeId = Uuid().v4();
final quickDrawId = Uuid().v4();
final shieldBearerId = Uuid().v4();
final smashFestId = Uuid().v4();

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
    final isVet =
        traits.any((element) => element.name == 'Vet') || u.hasMod(veteranId);
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

          return !traits.any((element) => element.name == 'Duelist');
        });
    mod.addMod(
      UnitAttribute.tv,
      (value) {
        return createSimpleIntMod(
          u.core.traits.any((element) => element.name == 'Vet') ||
                  u.hasMod(veteranId)
              ? 0
              : 2,
        )(value);
      },
      description: 'TV +${isVet ? 0 : 2}',
    );
    mod.addMod(
      UnitAttribute.traits,
      createAddToList(Trait(name: 'Duelist')),
      description: '+Duelist',
    );

    if (!isVet) {
      mod.addMod(
        UnitAttribute.traits,
        createAddToList(Trait(name: 'Vet')),
        description: '+Vet',
      );
    }
    return mod;
  }

  /*
  ACE GUNNER 2–3 TV
  Add the Stable trait to any one weapon for 2 TV. Or, add
  the Stable trait to a combo weapon for 3 TV.
  */
  factory DuelistModification.aceGunner(Unit u) {
    return DuelistModification(
        name: 'Ace Gunner',
        id: aceGunnerId,
        requirementCheck: () {
          if (u.hasMod(aceGunnerId)) {
            return false;
          }
          return u.isDuelist;
        });
  }

  /*
  ADVANCED CONTROL SYSTEM 3 TV
  Gain +1 action point. All models have a maximum of
  3 actions.
  */
  factory DuelistModification.advancedControlSystem(Unit u) {
    return DuelistModification(
        name: 'Advanced Control System',
        id: advancedControlSystemId,
        requirementCheck: () {
          if (u.hasMod(advancedControlSystemId)) {
            return false;
          }
          return u.isDuelist;
        });
  }

  /*
  CRACK SHOT 2–3 TV
  Add the Precise trait to any one weapon for 2 TV. Or,
  add the Precise trait to a combo weapon for 3 TV.
  */
  factory DuelistModification.crackShot(Unit u) {
    return DuelistModification(
        name: 'Crack Shot',
        id: crackShotId,
        requirementCheck: () {
          if (u.hasMod(crackShotId)) {
            return false;
          }
          return u.isDuelist;
        });
  }

  /*
  DEFENDER 1 TV
  Add the Anti-Missile System (AMS) trait to any weapon
  with the Frag or Burst trait.
  */
  factory DuelistModification.defender(Unit u) {
    return DuelistModification(
        name: 'Defender',
        id: defenderId,
        requirementCheck: () {
          if (u.hasMod(defenderId)) {
            return false;
          }
          return u.isDuelist;
        });
  }

  /*
  DUAL WIELD 1 TV
  Add the Link trait to any melee weapon other than
  Shaped Explosives. This adds a second weapon of the
  same type to the model. For example, a linked medium
  vibroblade becomes two medium vibroblades (ideally
  one in each hand).
  */
  factory DuelistModification.dualWield(Unit u) {
    return DuelistModification(
        name: 'Dual Wield',
        id: dualWieldId,
        requirementCheck: () {
          if (u.hasMod(dualWieldId)) {
            return false;
          }
          return u.isDuelist;
        });
  }

  /*
  GUNSLINGER 1–2 TV
  Add the Link trait to one Pistol, Submachine Gun,
  Autocannon, Frag Cannon, Flamer or Grenade
  Launcher with the React trait for 1 TV. Or add the Link
  trait to a combo weapon with the React trait for 2 TV.
  For modeling purposes, this adds a second weapon of
  the same type to the model. For example, a LAC with
  the Link trait is represented on the miniature as 2 X
  LACs (ideally one in each hand).
  */
  factory DuelistModification.gunslinger(Unit u) {
    return DuelistModification(
        name: 'Gunslinger',
        id: gunslingerId,
        requirementCheck: () {
          if (u.hasMod(gunslingerId)) {
            return false;
          }
          return u.isDuelist;
        });
  }

  /*
  LUNGE 0 TV
  Add the Reach:1 trait to any Vibro Blade, Spike Gun
  or Combat Weapon with the React trait. If the weapon
  already has the Reach:X trait then this upgrade cannot
  be used.
  */
  factory DuelistModification.lunge(Unit u) {
    return DuelistModification(
        name: 'Lunge',
        id: lungeId,
        requirementCheck: () {
          if (u.hasMod(lungeId)) {
            return false;
          }
          return u.isDuelist;
        });
  }

  /*
  PUSH THE ENVELOPE 1 TV
  Add the Agile trait. Models with the Lumbering Trait
  cannot receive Agile.
  */
  factory DuelistModification.pushTheEnvelope(Unit u) {
    return DuelistModification(
        name: 'Push the Envelope',
        id: pushTheEnvelopeId,
        requirementCheck: () {
          if (u.hasMod(pushTheEnvelopeId)) {
            return false;
          }
          return u.isDuelist;
        });
  }

  /*
  QUICK DRAW 1 TV
  Add the Auto trait to one ranged weapon or combination
  weapon that has the React trait.
  */
  factory DuelistModification.quickDraw(Unit u) {
    return DuelistModification(
        name: 'Quick Draw',
        id: quickDrawId,
        requirementCheck: () {
          if (u.hasMod(quickDrawId)) {
            return false;
          }
          return u.isDuelist;
        });
  }

  /*
  SHIELD-BEARER 1–2 TV
  Add the Shield trait to a model. This upgrade costs 1
  TV for models with an Armor of 7 or lower and 2 TV for
  models with an Armor of 8 or higher.
  */
  factory DuelistModification.shieldBearer(Unit u) {
    return DuelistModification(
        name: 'Shield-Bearer',
        id: shieldBearerId,
        requirementCheck: () {
          if (u.hasMod(shieldBearerId)) {
            return false;
          }
          return u.isDuelist;
        });
  }

  /*
  SMASHFEST 1 TV
  Upgrade one melee weapon with the React trait to one
  of the following:
  Z M Vibroblade +React
  Z M Combat Weapon +React, Demo:4
  */
  factory DuelistModification.smashfest(Unit u) {
    return DuelistModification(
        name: 'Smashfest',
        id: smashFestId,
        requirementCheck: () {
          if (u.hasMod(smashFestId)) {
            return false;
          }
          return u.isDuelist;
        });
  }
}