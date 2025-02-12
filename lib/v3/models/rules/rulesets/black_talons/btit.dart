import 'package:gearforce/v3/data/unit_filter.dart';
import 'package:gearforce/v3/models/rules/rule.dart';
import 'package:gearforce/v3/models/factions/faction_type.dart';
import 'package:gearforce/v3/models/mods/factionUpgrades/black_talon.dart';
import 'package:gearforce/v3/models/rules/rulesets/black_talons/black_talons.dart';
import 'package:gearforce/v3/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/v3/models/unit/command.dart';

const String _baseRuleId = 'rule::blackTalon::btit';
const String _ruleAlliesId = '$_baseRuleId::10';
const String _ruleAssymetryId = '$_baseRuleId::20';
const String _ruleRadioBlackoutId = '$_baseRuleId::30';
const String _ruleTheTalonsId = '$_baseRuleId::40';

/*
  BTIT - Black Talon Insertion Team
  A successful operation for BTITs is an operation that is over before the defenders even
  know what they’re fighting. BTITs have a diverse range of specially trained operatives that
  allow them to perform an assortment of missions including; unconventional warfare,
  foreign internal defense, direct action, counter-insurgency, special reconnaissance,
  counter-terrorism, information operations, counterproliferation of weapons of mass
  destruction, security force assistance and even manhunts.
  * Allies: You may select models from Caprice, Utopia or Eden (may include a mix).
  Commanders must choose a Black Talon model.
  * Asymmetry: Any combat group that can use the airdrop special deployment may
  use the special operations deployment instead.
  * Radio Blackout: One model per combat group with the ECM, or ECM+ trait may
  improve its EW skill by one for 1 TV each.
  * The Talons: Dark Jaguars and Dark Mambas may add +1 action for 2 TV each.
*/
class BTIT extends BlackTalons {
  BTIT(super.data, super.settings)
      : super(
          name: 'Black Talon Insertion Team',
          subFactionRules: [
            ruleAllies,
            ruleAsymmetry,
            ruleRadioBlackout,
            ruleTheTalons,
          ],
        );
}

final Rule ruleAllies = Rule(
  name: 'Allies',
  id: _ruleAlliesId,
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Allies',
      filters: [
        UnitFilter(FactionType.caprice),
        UnitFilter(FactionType.utopia),
        UnitFilter(FactionType.eden),
        UnitFilter(
          FactionType.universal,
          matcher: matchInfantry,
          factionOverride: FactionType.caprice,
        ),
      ],
      id: _ruleAlliesId),
  availableCommandLevelOverride: (u) {
    if (u.faction == FactionType.caprice ||
        u.faction == FactionType.utopia ||
        u.faction == FactionType.eden) {
      return [CommandLevel.none];
    }
    return null;
  },
  description: 'You may select models from Caprice, Utopia or Eden (may' +
      ' include a mix). Commanders must choose a Black Talon model.',
);

final Rule ruleAsymmetry = Rule(
  name: 'Asymmetry',
  id: _ruleAssymetryId,
  description: 'Any combat group that can use the airdrop special deployment' +
      ' may use the special operations deployment instead.',
);

final Rule ruleRadioBlackout = Rule(
  name: 'Radio Blackout',
  id: _ruleRadioBlackoutId,
  factionMods: (ur, cg, u) => [BlackTalonMods.radioBlackout()],
  description: 'One model per combat group with the ECM, or ECM+ trait may' +
      ' improve its EW skill by one for 1 TV each.',
);

final Rule ruleTheTalons = Rule(
  name: 'The Talons',
  id: _ruleTheTalonsId,
  factionMods: (ur, cg, u) => [BlackTalonMods.theTalons()],
  description: 'Dark Jaguars and Dark Mambas may add +1 action for 2 TV each.',
);
