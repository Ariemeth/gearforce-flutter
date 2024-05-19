import 'package:gearforce/models/mods/standardUpgrades/standard_modification.dart';
import 'package:gearforce/models/mods/veteranUpgrades/veteran_modification.dart';
import 'package:gearforce/models/rules/rule.dart';
import 'package:gearforce/models/rules/rule_types.dart';

const String _baseRuleId = 'rule::alphaBeta::core';
const String _ruleSnipers = '$_baseRuleId::10';

final Rule ruleSnipers = Rule(
  name: 'Snipers',
  id: _ruleSnipers,
  ruleType: RuleType.AlphaBeta,
  availableStandardUpgrades: (roster, unit) =>
      [StandardModification.precisePlus(unit)],
  availableVeteranUpgrades: (roster, unit) =>
      [VeteranModification.vetPrecise(unit)],
  description: 'There is a difference noted in the lore between models which' +
      ' are issued a rifle and models which are specifically intended to be' +
      ' snipers. This leads to a question of how models which are intended' +
      ' to be snipers could gain a benefit over models that were simply issued' +
      ' a rifle',
);
