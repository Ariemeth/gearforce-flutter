import 'package:shared_preferences/shared_preferences.dart';

const _tooltipDelayKey = 'tooltipDelay';
const _isExtendedContentAllowedKey = 'isExtendedContentAllowed';
const _isAlphaBetaAllowedKey = 'isAlphaBetaAllowed';

const _defaultTooltipDelayInMilliseconds = 750;
const _defaultIsExtendedContentAllowed = false;
const _defaultIsAlphaBetaAllowed = false;

class Settings {
  Duration _tooltipDelay =
      Duration(milliseconds: _defaultTooltipDelayInMilliseconds);

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

    return true;
  }

  reset() {
    tooltipDelay = Duration(milliseconds: _defaultTooltipDelayInMilliseconds);
    isExtendedContentAllowed = _defaultIsExtendedContentAllowed;
    isAlphaBetaAllowed = _defaultIsAlphaBetaAllowed;
  }
}
