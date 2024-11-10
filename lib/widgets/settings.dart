import 'package:shared_preferences/shared_preferences.dart';

const _tooltipDelayKey = 'tooltipDelay';
const _isExtendedContentAllowedKey = 'isExtendedContentAllowed';
const _isAlphaBetaAllowedKey = 'isAlphaBetaAllowed';
const _requireConfirmationToDeleteUnitKey = 'requireConfirmationToDeleteUnit';
const _requireConfirmationToResetRosterKey = 'requireConfirmationToResetRoster';
const _requireConfirmationToDeleteCGKey = 'requireConfirmationToDeleteCG';
const _allowCustomPointsKey = 'allowCustomPoints';

const _defaultTooltipDelayInMilliseconds = 750;
const _defaultIsExtendedContentAllowed = false;
const _defaultIsAlphaBetaAllowed = false;
const _defaultRequireConfirmationToDeleteUnit = true;
const _defaultRequireConfirmationToResetRoster = true;
const _defaultRequireConfirmationToDeleteCG = true;
const _defaultAllowCustomPoints = false;

class Settings {
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Duration _tooltipDelay =
      const Duration(milliseconds: _defaultTooltipDelayInMilliseconds);

  Duration get tooltipDelay => _tooltipDelay;
  set tooltipDelay(Duration value) {
    _tooltipDelay = value;
    // Save settings to storage
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      prefs.setInt(_tooltipDelayKey, value.inMilliseconds);
    });
  }

  bool _isExtendedContentAllowed = _defaultIsExtendedContentAllowed;

  bool get isExtendedContentAllowed => _isExtendedContentAllowed;
  set isExtendedContentAllowed(bool value) {
    _isExtendedContentAllowed = value;
    // Save settings to storage
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      prefs.setBool(_isExtendedContentAllowedKey, value);
    });
  }

  bool _isAlphaBetaAllowed = _defaultIsAlphaBetaAllowed;

  bool get isAlphaBetaAllowed => _isAlphaBetaAllowed;
  set isAlphaBetaAllowed(bool value) {
    _isAlphaBetaAllowed = value;
    // Save settings to storage
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      prefs.setBool(_isAlphaBetaAllowedKey, value);
    });
  }

  bool _requireConfirmationToDeleteUnit =
      _defaultRequireConfirmationToDeleteUnit;

  bool get requireConfirmationToDeleteUnit => _requireConfirmationToDeleteUnit;
  set requireConfirmationToDeleteUnit(bool value) {
    _requireConfirmationToDeleteUnit = value;
    // Save settings to storage
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      prefs.setBool(_requireConfirmationToDeleteUnitKey, value);
    });
  }

  bool _requireConfirmationToResetRoster =
      _defaultRequireConfirmationToResetRoster;

  bool get requireConfirmationToResetRoster =>
      _requireConfirmationToResetRoster;
  set requireConfirmationToResetRoster(bool value) {
    _requireConfirmationToResetRoster = value;
    // Save settings to storage
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      prefs.setBool(_requireConfirmationToResetRosterKey, value);
    });
  }

  bool _requireConfirmationToDeleteCG = _defaultRequireConfirmationToDeleteCG;

  bool get requireConfirmationToDeleteCG => _requireConfirmationToDeleteCG;
  set requireConfirmationToDeleteCG(bool value) {
    _requireConfirmationToDeleteCG = value;
    // Save settings to storage
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      prefs.setBool(_requireConfirmationToDeleteCGKey, value);
    });
  }

  bool _allowCustomPoints = _defaultAllowCustomPoints;

  bool get allowCustomPoints => _allowCustomPoints;
  set allowCustomPoints(bool value) {
    _allowCustomPoints = value;
    // Save settings to storage
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      prefs.setBool(_allowCustomPointsKey, value);
    });
  }

  Future<bool> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final int? tooltipDelay = prefs.getInt(_tooltipDelayKey);
    if (tooltipDelay != null) {
      _tooltipDelay = Duration(milliseconds: tooltipDelay);
    }

    final bool? isExtendedContentAllowed =
        prefs.getBool(_isExtendedContentAllowedKey);
    if (isExtendedContentAllowed != null) {
      _isExtendedContentAllowed = isExtendedContentAllowed;
    }

    final bool? isAlphaBetaAllowed = prefs.getBool(_isAlphaBetaAllowedKey);
    if (isAlphaBetaAllowed != null) {
      _isAlphaBetaAllowed = isAlphaBetaAllowed;
    }

    final bool? haveConfirmationToDeleteUnit =
        prefs.getBool(_requireConfirmationToDeleteUnitKey);
    if (haveConfirmationToDeleteUnit != null) {
      _requireConfirmationToDeleteUnit = haveConfirmationToDeleteUnit;
    }

    final bool? haveConfirmationToResetRoster =
        prefs.getBool(_requireConfirmationToResetRosterKey);
    if (haveConfirmationToResetRoster != null) {
      _requireConfirmationToResetRoster = haveConfirmationToResetRoster;
    }

    final bool? haveConfirmationToDeleteCG =
        prefs.getBool(_requireConfirmationToDeleteCGKey);
    if (haveConfirmationToDeleteCG != null) {
      _requireConfirmationToDeleteCG = haveConfirmationToDeleteCG;
    }

    final bool? allowCustomPoints = prefs.getBool(_allowCustomPointsKey);
    if (allowCustomPoints != null) {
      _allowCustomPoints = allowCustomPoints;
    }

    _isInitialized = true;
    return true;
  }

  reset() {
    tooltipDelay =
        const Duration(milliseconds: _defaultTooltipDelayInMilliseconds);
    isExtendedContentAllowed = _defaultIsExtendedContentAllowed;
    isAlphaBetaAllowed = _defaultIsAlphaBetaAllowed;
    requireConfirmationToDeleteUnit = _defaultRequireConfirmationToDeleteUnit;
    requireConfirmationToResetRoster = _defaultRequireConfirmationToResetRoster;
    requireConfirmationToDeleteCG = _defaultRequireConfirmationToDeleteCG;
    allowCustomPoints = _defaultAllowCustomPoints;
  }
}
