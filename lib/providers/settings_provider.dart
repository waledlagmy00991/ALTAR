import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;

  void changeLanguage(String languageCode) {
    if (languageCode == 'ar') {
      // Arabic is coming soon, don't change yet
      return;
    }
    _currentLocale = Locale(languageCode);
    notifyListeners();
  }
}
