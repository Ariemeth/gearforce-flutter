import 'package:flutter/widgets.dart';
import 'package:gearforce/v3/models/combatGroups/combat_group.dart';
import 'package:gearforce/v3/models/combatGroups/group.dart';
import 'package:gearforce/v3/models/factions/faction.dart';
import 'package:gearforce/v3/models/factions/faction_type.dart';
import 'package:gearforce/v3/models/mods/base_modification.dart';
import 'package:gearforce/v3/models/mods/saved_mod.dart';
import 'package:gearforce/v3/models/roster/roster.dart';
import 'package:gearforce/v3/models/rules/rulesets/rule_set.dart';
import 'package:gearforce/v3/models/traits/trait.dart';
import 'package:gearforce/v3/models/unit/command.dart';
import 'package:gearforce/v3/models/unit/model_type.dart';
import 'package:gearforce/v3/models/unit/movement.dart';
import 'package:gearforce/v3/models/unit/role.dart';
import 'package:gearforce/v3/models/unit/unit_attribute.dart';
import 'package:gearforce/v3/models/unit/unit_core.dart';
import 'package:gearforce/v3/models/validation/validations.dart';
import 'package:gearforce/v3/models/weapons/weapon.dart';

class Unit extends ChangeNotifier {
  final UnitCore core;
  Group? group;
  CombatGroup? get combatGroup => group?.combatGroup;
  UnitRoster? get roster => group?.combatGroup?.roster;
  RuleSet? get ruleset => group?.combatGroup?.roster?.rulesetNotifer.value;

  final List<BaseModification> _mods = [];

  CommandLevel _commandLevel = CommandLevel.none;

  FactionType? factionOverride;

  List<String> _special = [];
  Unit({
    required this.core,
  });

  factory Unit.from(Unit original) {
    final newUnit = Unit(core: original.core);
    newUnit._commandLevel = original._commandLevel;
    for (var m in original._mods) {
      newUnit.addUnitMod(m);
    }
    newUnit._special = original.special;
    newUnit.factionOverride = original.factionOverride;

    return newUnit;
  }

  factory Unit.fromJson(
    dynamic json,
    Faction faction,
    RuleSet ruleset,
    CombatGroup? cg,
    UnitRoster roster,
  ) {
    final apiVersion = json['version'] != null ? json['version'] as int : 1;

    final List<Unit> core = [];
    ruleset.availableUnitFilters(cg?.options).forEach((sfilter) {
      core.addAll(ruleset.availableUnits(specialUnitFilter: sfilter));
    });
    final loadVariant = json['variant'] as String;
    // account for any lists made with the units that had double spaces in their names
    final variant = loadVariant.replaceAll('  ', ' ');
    Unit u;
    try {
      u = core.firstWhere((unit) => unit.core.name == variant);
    } catch (e) {
      print('Unable to find unit variant [$variant], $e');
      rethrow;
    }

    u._commandLevel = CommandLevel.fromString(json['command']);

    final factionOver = json['factionOverride'];
    if (factionOver != null) {
      try {
        u.factionOverride = FactionType.fromName(factionOver);
      } catch (e) {
        print('Unable to parse faction override [$factionOver], $e');
      }
    }

    switch (apiVersion) {
      case 0:
      case 1:
        _loadV1UnitMods(json['mods'] as Map, u, faction, ruleset, cg, roster);
        break;
      // 2+
      default:
        _loadV2UnitMods(json['mods'] as List, u, faction, ruleset, cg, roster);
    }

    return u;
  }

  static bool _loadV2UnitMods(
    List<dynamic> modMap,
    Unit u,
    Faction faction,
    RuleSet ruleset,
    CombatGroup? cg,
    UnitRoster roster,
  ) {
    if (cg == null) {
      return false;
    }

    for (var modJson in modMap) {
      final savedMod = SavedMod.fromJson(modJson);
      BaseModification? mod;
      switch (ModificationTypeExtension.fromString(savedMod.type)) {
        case ModificationType.standard:
          mod = ruleset.getStandardUpgrade(savedMod.modId, u, cg, roster);
          break;
        case ModificationType.veteran:
          mod = ruleset.getVeteranUpgrade(savedMod.modId, u, cg);
          break;
        case ModificationType.duelist:
          mod = ruleset.getDuelistUpgrade(savedMod.modId, u, cg, roster);
          break;
        case ModificationType.faction:
          mod = ruleset.getFactionModFromId(savedMod.modId, roster, u);
          break;
        case ModificationType.unit:
          mod = ruleset
              .availableUnitMods(u)
              .firstWhere((unitMod) => unitMod.id == savedMod.modId);
          break;
        case ModificationType.custom:
          mod = ruleset.getCustomUpgrade(savedMod.modId);
          break;
      }
      if (mod != null) {
        final modOptions = savedMod.selected;
        if (modOptions != null) {
          mod.options?.selectedOption =
              mod.options?.optionByText(modOptions['text']);
          if (mod.options?.selectedOption != null) {
            final subOption = modOptions['selected'];
            if (subOption != null) {
              mod.options?.selectedOption?.selectedOption =
                  mod.options?.selectedOption?.optionByText(subOption['text']);
            }
          }
          mod.refreshData();
        }
        u.addUnitMod(mod);
      }
    }
    return true;
  }

  static bool _loadV1UnitMods(
    Map<dynamic, dynamic> modMap,
    Unit u,
    Faction faction,
    RuleSet ruleset,
    CombatGroup? cg,
    UnitRoster roster,
  ) {
    Map<BaseModification, Map<String, dynamic>> modsWithOptions = {};

    if (modMap['unit'] != null) {
      final mods = modMap['unit'] as List;
      var availableUnitMods = ruleset.availableUnitMods(u);
      for (var loadedMod in mods) {
        try {
          var mod = availableUnitMods
              .firstWhere((unitMod) => unitMod.id == loadedMod['id']);
          u.addUnitMod(mod);
          final selected = loadedMod['selected'];
          if (selected != null) {
            modsWithOptions[mod] = selected;
          }
        } catch (e) {
          print('unit mod $loadedMod not found in available mods, $e');
        }
      }
    }
    if (modMap['standard'] != null && cg != null) {
      final mods = modMap['standard'] as List;

      for (var loadedMod in mods) {
        try {
          final modId = loadedMod['id'];
          var mod = ruleset.getStandardUpgrade(modId, u, cg, roster);
          if (mod != null) {
            u.addUnitMod(mod);
            final selected = loadedMod['selected'];
            if (selected != null) {
              modsWithOptions[mod] = selected;
            }
          } else {
            print('Standard mod $modId not found');
          }
        } catch (e) {
          print('standard mod $loadedMod not found in available mods, $e');
        }
      }
    }
    if (modMap['vet'] != null && cg != null) {
      final mods = modMap['vet'] as List;

      for (var loadedMod in mods) {
        try {
          final modId = loadedMod['id'];
          var mod = ruleset.getVeteranUpgrade(modId, u, cg);
          if (mod != null) {
            u.addUnitMod(mod);
            final selected = loadedMod['selected'];
            if (selected != null) {
              modsWithOptions[mod] = selected;
            }
          } else {
            print('Vet mod $modId not found');
          }
        } catch (e) {
          print('vet mod $loadedMod not found in available mods, $e');
        }
      }
    }
    if (modMap['duelist'] != null && cg != null) {
      final mods = modMap['duelist'] as List;

      for (var loadedMod in mods) {
        try {
          final modId = loadedMod['id'];
          var mod = ruleset.getDuelistUpgrade(modId, u, cg, roster);
          if (mod != null) {
            u.addUnitMod(mod);
            final selected = loadedMod['selected'];
            if (selected != null) {
              modsWithOptions[mod] = selected;
            }
          } else {
            print('Duelist mod $modId not found');
          }
        } catch (e) {
          print('duelist mod $loadedMod not found in available mods, $e');
        }
      }
    }

    if (modMap['faction'] != null && cg != null) {
      final mods = modMap['faction'] as List;

      for (var loadedMod in mods) {
        try {
          final modId = loadedMod['id'];

          var mod = ruleset.getFactionModFromId(modId, roster, u);
          if (mod == null) {
            print('faction mod $modId could not be loaded');
            continue;
          }
          u.addUnitMod(mod);
          final selected = loadedMod['selected'];
          if (selected != null) {
            modsWithOptions[mod] = selected;
          }
        } catch (e) {
          print('faction mod $loadedMod not found in available mods, $e');
        }
      }
    }

    var loadAttempts = 0;
    while (modsWithOptions.isNotEmpty && loadAttempts < 5) {
      modsWithOptions = _loadOptionsFromJSON(modsWithOptions,
          refreshOptions: loadAttempts != 0);
      loadAttempts++;
    }
    return true;
  }

  int? get actions {
    var value = core.actions;
    for (var mod in _mods) {
      value = mod.applyMods(UnitAttribute.actions, value);
    }
    return value;
  }

  int? get armor {
    var value = core.armor;
    for (var mod in _mods) {
      value = mod.applyMods(UnitAttribute.armor, value);
    }
    return value;
  }

  CommandLevel get commandLevel => _commandLevel;

  set commandLevel(CommandLevel cl) {
    if (_commandLevel == cl) {
      return;
    }

    _commandLevel = cl;

    // Note: Setting the command level on other units directly using prviate
    // fields to prevent the notifier from running.
    switch (cl) {
      case CommandLevel.none:
        break;
      case CommandLevel.bc:
        break;
      case CommandLevel.po:
        break;
      case CommandLevel.cgl:
        // Only 1 cgl, tfc, co, or xo can exist within a single Combat Group
        final units = combatGroup?.units.where(
            (unit) => unit != this && unit.commandLevel >= CommandLevel.cgl);
        units?.forEach((unit) {
          unit.commandLevel = CommandLevel.none;
        });

        break;
      case CommandLevel.secic:
        // only 1 second in command per combat group
        final units = combatGroup?.units.where(
            (unit) => unit != this && unit.commandLevel == CommandLevel.secic);
        units?.forEach((unit) {
          unit.commandLevel = CommandLevel.none;
        });
        break;
      case CommandLevel.xo:
      case CommandLevel.co:
      case CommandLevel.tfc:
        // only 1 xo, co, tfc per task force
        final topUnits = roster
            ?.getAllUnits()
            .where((unit) => unit != this && unit.commandLevel == cl);
        topUnits?.forEach((unit) {
          unit.commandLevel = CommandLevel.none;
        });

        // only 1 of xo, co, tfc, or cgl per combat group
        final units = combatGroup?.units.where(
            (unit) => unit != this && unit.commandLevel >= CommandLevel.cgl);
        units?.forEach((unit) {
          unit.commandLevel = CommandLevel.none;
        });

        break;
    }

    final rs = roster?.rulesetNotifer.value;
    if (rs != null) {
      final onLeadershipRules = rs
          .allFactionRules(unit: this)
          .where((rule) => rule.onLeadershipChanged != null);
      for (var rule in onLeadershipRules) {
        rule.onLeadershipChanged!(roster!, this);
      }
    }

    notifyListeners();
  }

  int? get ew {
    var value = core.ew;
    for (var mod in _mods) {
      value = mod.applyMods(UnitAttribute.ew, value);
    }
    return value;
  }

  int? get gunnery {
    var value = core.gunnery;
    for (var mod in _mods) {
      value = mod.applyMods(UnitAttribute.gunnery, value);
    }
    return value;
  }

  String get height {
    return core.height;
  }

  int? get hull {
    var value = core.hull;
    for (var mod in _mods) {
      value = mod.applyMods(UnitAttribute.hull, value);
    }
    return value;
  }

  bool get isDuelist {
    return traits.any((t) => t.name == 'Duelist');
  }

  bool get isVeteran {
    return traits.any((t) => t.name == 'Vet');
  }

  List<String> get modNames => _mods.map((m) => m.name).toList();

  List<String> get modNamesWithCost => _mods
      .map((m) => '${m.name}(${m.applyMods(UnitAttribute.tv, 0)})')
      .toList();

  List<Weapon> get reactWeapons {
    return weapons.where((weapon) => weapon.hasReact).toList();
  }

  List<Weapon> get mountedWeapons {
    return weapons.where((weapon) => !weapon.hasReact).toList();
  }

  List<Weapon> get weapons {
    var newList =
        core.weapons.map((weapon) => Weapon.fromWeapon(weapon)).toList();

    for (var mod in _mods) {
      newList = mod.applyMods(UnitAttribute.weapons, newList);
    }

    ruleset?.unitWeaponsModifier(newList);

    return newList;
  }

  Movement? get movement {
    var value = core.movement;

    for (var mod in _mods) {
      value = mod.applyMods(UnitAttribute.movement, value);
    }

    return value;
  }

  String get name {
    var value = core.name;

    for (var mod in _mods) {
      value = mod.applyMods(UnitAttribute.name, value);
    }

    return value;
  }

  int? get piloting {
    var value = core.piloting;
    for (var mod in _mods) {
      value = mod.applyMods(UnitAttribute.piloting, value);
    }
    return value;
  }

  Roles? get role {
    var value = core.role;

    for (var mod in _mods) {
      value = mod.applyMods(UnitAttribute.roles, value);
    }

    return value;
  }

  List<String> get special {
    var value = _special.toList();
    for (var mod in _mods) {
      value = mod.applyMods(UnitAttribute.special, value);
    }
    return value;
  }

  int? get structure {
    var value = core.structure;
    for (var mod in _mods) {
      value = mod.applyMods(UnitAttribute.structure, value);
    }
    return value;
  }

  List<Trait> get traits {
    var newList = core.traits.map((trait) => Trait.fromTrait(trait)).toList();

    for (var mod in _mods) {
      newList = mod.applyMods(UnitAttribute.traits, newList);
    }

    ruleset?.unitTraitsModifier(newList, this);

    return newList;
  }

  int get tv {
    var value = core.tv;
    value += ruleset?.commandTVCost(_commandLevel) ?? 0;

    for (var mod in _mods) {
      value = mod.applyMods(UnitAttribute.tv, value);
    }

    return value;
  }

  ModelType get type {
    var value = core.type;

    for (var mod in _mods) {
      value = mod.applyMods(UnitAttribute.type, value);
    }

    return value;
  }

  FactionType get faction {
    var value = core.faction;

    return factionOverride ?? value;
  }

  int get commandPoints {
    var cp = 0;

    for (var mod in _mods) {
      cp = mod.applyMods(UnitAttribute.cp, cp);
    }

    if (commandLevel != CommandLevel.none) {
      // all commanders get 1 base cp
      cp = cp + 1;
      // commanders convert their sp to cp
      cp = cp + skillPoints;
    }

    return cp;
  }

  int get skillPoints {
    var sp = 0;

    for (var mod in _mods) {
      sp = mod.applyMods(UnitAttribute.sp, sp);
    }

    if (isVeteran) {
      sp += 1;
    }

    for (var trait in traits) {
      if (trait.isSameType(Trait.sp(0))) {
        sp += trait.level ?? 0;
      }
    }

    return sp;
  }

  void addUnitMod(BaseModification mod) {
    // Duplicate mods are not allowed on the same unit
    if (_mods.any((m) => m.id == mod.id)) {
      return;
    }
    _mods.add(mod);
    if (mod.onAdd != null) {
      mod.onAdd!(this);
    }

    final ruleOverrides = ruleset
        ?.allEnabledRules(combatGroup?.options)
        .where((rule) => rule.onModAdded != null);
    ruleOverrides?.forEach((rule) {
      rule.onModAdded!(this, mod.id);
    });

    for (var m in _mods) {
      final updatedMod = m.refreshData();
      updatedMod.options?.validate();
      if (updatedMod != m) {
        _mods[_mods.indexWhere((element) => element.id == updatedMod.id)];
      }
    }
    notifyListeners();
  }

  T attribute<T>(
    UnitAttribute att, {
    String? modIDToSkip,
  }) {
    assert(T == att.expectedType, 'Expected [${att.expectedType}], got [$T]');

    var value = core.attribute(att) as T;

    for (var mod in _mods
        .where((m) => modIDToSkip == null ? true : m.id != modIDToSkip)) {
      value = mod.applyMods(att, value);
    }

    return value;
  }

  void clearUnitMods() {
    _mods.clear();
    notifyListeners();
  }

  void forceNotify() {
    notifyListeners();
  }

  BaseModification? getMod(String id) {
    if (!hasMod(id)) {
      return null;
    }
    return _mods.firstWhere((mod) => mod.id == id);
  }

  List<BaseModification> getMods() {
    return _mods.toList();
  }

  bool hasMod(String id) => _mods.any((mod) => mod.name == id || mod.id == id);

  int numUnitMods() => _mods.length;

  void removeUnitMod(String id) {
    final mod = getMod(id);
    if (mod == null) {
      return;
    }
    _mods.remove(mod);
    if (mod.onRemove != null) {
      mod.onRemove!(this);
    }

    final ruleOverrides = ruleset
        ?.allEnabledRules(combatGroup?.options)
        .where((rule) => rule.onModRemoved != null);
    ruleOverrides?.forEach((rule) {
      rule.onModRemoved!(this, mod.id);
    });

    notifyListeners();
  }

  Validations validate({bool tryFix = false}) {
    Validations validationErrors = Validations();
    final g = group;
    if (g == null) {
      validationErrors.add(const Validation(
        false,
        issue: 'Unit does not have a group',
      ));
    }
    final cg = group?.combatGroup;
    if (cg == null) {
      validationErrors.add(const Validation(
        false,
        issue: 'Unit does not have a combat group',
      ));
    }
    final roster = cg?.roster;
    if (roster == null) {
      validationErrors.add(const Validation(
        false,
        issue: 'Unit does not have a roster',
      ));
    }

    if (validationErrors.isNotValid()) {
      print('Validation errors found validating $name, $validationErrors');
      return validationErrors;
    }

    if (tryFix) {
      final modsToRemove = _mods.where((mod) {
        return !mod.requirementCheck(
          roster!.rulesetNotifer.value,
          roster,
          cg,
          this,
        );
      }).toList();

      for (var mod in modsToRemove) {
        removeUnitMod(mod.id);
      }

      for (var m in _mods) {
        final updatedMod = m.refreshData();
        updatedMod.options?.validate();
        if (updatedMod != m) {
          print('replacing mod ${m.id}\n');
          _mods[_mods.indexWhere((mod) => mod.id == updatedMod.id)];
        }
      }

      if (commandLevel != CommandLevel.none) {
        final canBeCommand =
            roster?.rulesetNotifer.value.canBeCommand(this) ?? false;
        if (!canBeCommand) {
          commandLevel = CommandLevel.none;
        }
      }
    } else {
      for (var mod in _mods) {
        if (!mod.requirementCheck(
          roster!.rulesetNotifer.value,
          roster,
          cg,
          this,
        )) {
          validationErrors.add(Validation(
            false,
            issue:
                'mod ${mod.id} does not met its requirement check during validation',
          ));
        }
      }

      if (commandLevel != CommandLevel.none) {
        final canBeCommand =
            roster?.rulesetNotifer.value.canBeCommand(this) ?? false;
        if (!canBeCommand) {
          validationErrors.add(Validation(false,
              issue:
                  'Unit has a command level of $_commandLevel but is not allowed to be a commander'));
        }
      }
    }

    return validationErrors;
  }

  Map<String, dynamic> toJson() {
    List<SavedMod> mods2 = [];

    for (int i = 0; i < _mods.length; i++) {
      final mod = _mods[i];
      mods2.add(SavedMod(
        mod.modType.name,
        i,
        mod.toJson(),
      ));
    }

    return {
      'version': 2,
      'frame': core.frame,
      'variant': core.name,
      'mods': mods2,
      'command': _commandLevel.name,
      'factionOverride': factionOverride?.toString()
    };
  }

  @override
  String toString() {
    return 'Unit: $name, Hash: $hashCode, TV: $tv, Rank: ${commandLevel.name}, Mods: $modNames';
  }
}

Map<BaseModification, Map<String, dynamic>> _loadOptionsFromJSON(
    Map<BaseModification, Map<String, dynamic>> modsWithOptionsToLoad,
    {bool refreshOptions = false}) {
  /*
      {
        "text": "LAC",
        "selected": null
      }
      ////////////////////
      {
        "text": "LSG",
        "selected": {
          "text": "LCW",
          "selected": null
        }
      }
      */
  final Map<BaseModification, Map<String, dynamic>> failedToLoadOptions = {};
  modsWithOptionsToLoad.forEach((modWithOptions, modOptions) {
    final selectedOptionText = modOptions['text'];
    final seletedOptionSelection = modOptions['selected'];

    if (refreshOptions) {
      modWithOptions = modWithOptions.refreshData();
    }

    if (selectedOptionText != null) {
      final selectedOption =
          modWithOptions.options!.optionByText(selectedOptionText);
      if (selectedOption != null) {
        modWithOptions.options!.selectedOption = selectedOption;
        if (seletedOptionSelection != null) {
          final subOptionText = seletedOptionSelection['text'];
          if (subOptionText != null) {
            final selectedSubOption =
                selectedOption.optionByText(subOptionText);
            if (selectedSubOption != null) {
              selectedOption.selectedOption = selectedSubOption;
            } else {
              failedToLoadOptions[modWithOptions] = modOptions;
              print('was unable to find a sub option that matches the ' +
                  'selected text value of $subOptionText for mod ' +
                  modWithOptions.id);
            }
          }
        }
      } else {
        failedToLoadOptions[modWithOptions] = modOptions;
        print('was unable to find an option that matches the selected text' +
            ' value of $selectedOptionText for mod ${modWithOptions.id}');
      }
    }
  });

  return failedToLoadOptions;
}
