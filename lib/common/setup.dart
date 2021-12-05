import 'package:flutter/material.dart';

class AppSetup {
  static const standartFontStyleSize = 16;

  final bool day;
  final Locale locale;
  final double fontSize;
  double styleSize = 15;
  AppSetup({required this.day, required this.locale, required this.fontSize}) {
    styleSize = standartFontStyleSize * fontSize;
  }
  static const locales = [Locale('en', 'US'), Locale('ru', 'RU')];

  static AppSetup get_default() {
    return AppSetup(day: false, locale: const Locale('en', 'US'), fontSize: 1);
  }
}
