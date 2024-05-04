import 'package:shared_preferences/shared_preferences.dart';

const _tooltipDelayKey = 'tooltipDelay';
const _isExtendedContentAllowedKey = 'isExtendedContentAllowed';

const _defaultTooltipDelayInMilliseconds = 1500;
const _defaultIsExtendedContentAllowed = false;

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

  Future<bool> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final int? tooltipDelay = prefs.getInt(_tooltipDelayKey);
    print('loading tooltipDelay: $tooltipDelay');
    if (tooltipDelay != null) {
      _tooltipDelay = Duration(milliseconds: tooltipDelay);
    }

    final bool? isExtendedContentAllowed =
        prefs.getBool(_isExtendedContentAllowedKey);
    if (isExtendedContentAllowed != null) {
      _isExtendedContentAllowed = isExtendedContentAllowed;
    }
    return true;
  }

  reset() {
    tooltipDelay = Duration(milliseconds: _defaultTooltipDelayInMilliseconds);
    isExtendedContentAllowed = _defaultIsExtendedContentAllowed;
  }
}
