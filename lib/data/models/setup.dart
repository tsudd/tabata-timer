import 'package:flutter/cupertino.dart';
import 'package:tabata/common/setup.dart';

class AppSetupModel extends AppSetup {
  static const dayAccessor = 'day';
  static const langAccessor = 'lang';
  static const countryAccessor = 'country';
  static const fontSizeAccessor = 'fontSize';

  AppSetupModel(
      {required bool day, required Locale locale, required double fontSize})
      : super(day: day, locale: locale, fontSize: fontSize);

  factory AppSetupModel.fromJson(Map<String, dynamic> json) {
    return AppSetupModel(
        day: json[dayAccessor],
        locale: Locale(json[langAccessor], json[countryAccessor]),
        fontSize: double.parse(json[fontSizeAccessor]));
  }

  Map<String, dynamic> toJson() {
    return {
      dayAccessor: day,
      langAccessor: locale.languageCode,
      countryAccessor: locale.countryCode,
      fontSizeAccessor: fontSize.toString()
    };
  }
}
