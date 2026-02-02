// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'ALTAR';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get chatbot => 'المساعد الذكي';

  @override
  String get settings => 'الإعدادات';

  @override
  String get dashboardComingSoon => 'لوحة تقدم الطلاب - قريباً';

  @override
  String get settingsComingSoon => 'المزيد من الإعدادات ستكون متاحة قريباً.';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'الإنجليزية';

  @override
  String get arabic => 'العربية (قريباً)';

  @override
  String get typeMessage => 'اكتب رسالة...';

  @override
  String get aiTyping => 'الذكاء الاصطناعي يكتب...';
}
