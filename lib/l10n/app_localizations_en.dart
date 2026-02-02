// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ALTAR';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get chatbot => 'Chatbot';

  @override
  String get settings => 'Settings';

  @override
  String get dashboardComingSoon => 'Student progress dashboard – Coming Soon';

  @override
  String get settingsComingSoon => 'More settings will be available soon.';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic (Coming Soon)';

  @override
  String get typeMessage => 'Type a message...';

  @override
  String get aiTyping => 'AI is typing...';
}
