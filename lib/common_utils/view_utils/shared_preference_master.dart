import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../common_strings.dart';

class SharedPreferenceMaster {
  SharedPreferenceMaster(StreamingSharedPreferences preferences)
      : userProfile = preferences.getString(CommonStrings.sharedPrefUserProfile,
            defaultValue: ''),
        currencySelected = preferences.getString(
            CommonStrings.sharedPrefSelectedCurrency,
            defaultValue: CommonStrings.usd),
        isCurrencySelected = preferences.getBool(
            CommonStrings.sharedPrefIsCurrencySelected,
            defaultValue: false);

  final Preference<String> userProfile;
  final Preference<String> currencySelected;
  final Preference<bool> isCurrencySelected;
}
