import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabata/common/setup.dart';
import 'package:tabata/data/models/setup.dart';
import 'package:tabata/data/repos/timers_local_storage.dart';

class AppCubit extends Cubit<AppSetup> {
  AppCubit(AppSetup initialState) : super(initialState);

  final localStorage = TimersLocalStorage.getInstance();

  bool day = false;
  Locale locale = const Locale('en', 'US');
  double fontSize = 1;

  void tryLoadSetup() async {
    try {
      final setup = await localStorage.getSetupCached();
      day = setup.day;
      locale = setup.locale;
      fontSize = setup.fontSize;
      _doEmit();
    } on NullThrownError {
      return;
    }
  }

  void setLocale(Locale? loc) async {
    if (loc == null) return;
    locale = loc;
    _doEmit();
  }

  void setFontSize(double? size) async {
    if (size == null || size == fontSize) return;
    fontSize = size;
    _doEmit();
  }

  void toggleTheme() async {
    day = state.day ? false : true;
    _doEmit();
  }

  void _doEmit() async {
    var st = AppSetupModel(day: day, locale: locale, fontSize: fontSize);
    localStorage.setupToCache(st);
    emit(st);
  }
}
