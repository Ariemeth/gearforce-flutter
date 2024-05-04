import 'package:shared_preferences/shared_preferences.dart';

const _tooltipDelayKey = 'tooltipDelay';

const _defaultTooltipDelayInMilliseconds = 1500;

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

  Future<bool> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final int? tooltipDelay = prefs.getInt(_tooltipDelayKey);
    print('loading tooltipDelay: $tooltipDelay');
    if (tooltipDelay != null) {
      _tooltipDelay = Duration(milliseconds: tooltipDelay);
    }
    return true;
  }

  reset() {
    tooltipDelay = Duration(milliseconds: _defaultTooltipDelayInMilliseconds);
  }
}
