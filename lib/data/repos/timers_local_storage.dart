import 'package:shared_preferences/shared_preferences.dart';
import 'package:tabata/data/models/setup.dart';

import 'dart:convert';

class TimersLocalStorage {
  static TimersLocalStorage? instance;
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();

  static TimersLocalStorage get_instance() {
    instance ??= TimersLocalStorage();
    return instance!;
  }

  static const userSetup = 'USER_SETUP';
  static const timers = 'TIMERS';

  void setupToCache(AppSetupModel setup) async {
    final jsonSetup = json.encode(setup.toJson());

    await (await preferences).setString(userSetup, jsonSetup);
  }

  Future<AppSetupModel> getSetupCached() async {
    final jsonSetup = (await preferences).getString(userSetup);
    String setup = jsonSetup ?? '';
    if (setup.isNotEmpty) {
      return Future.value(AppSetupModel.fromJson(json.decode(setup)));
    } else {
      throw NullThrownError();
    }
  }
}
