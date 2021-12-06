import 'package:shared_preferences/shared_preferences.dart';
import 'package:tabata/data/models/setup.dart';

import 'dart:convert';

import 'package:tabata/data/models/timer.dart';

class TimersLocalStorage {
  static TimersLocalStorage? instance;
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();

  static TimersLocalStorage get_instance() {
    instance ??= TimersLocalStorage();
    return instance!;
  }

  Map<String, dynamic> hotTimers = {};

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

  Future<List<TTimer>> getTimersCached() async {
    final jsonTimers = (await preferences).getString(timers);
    String tmrs = jsonTimers ?? '';
    if (tmrs.isNotEmpty) {
      hotTimers = json.decode(tmrs);
      List<TTimer> ans = [];
      hotTimers.forEach((key, value) {
        var tm = TTimer.fromJson(json.decode(value));
        ans.add(tm);
      });
      return Future.value(ans);
    } else {
      throw Error();
    }
  }

  Future<String> saveTimerCached(TTimer timer) async {
    final jsonTimer = json.encode(timer.toJson());
    var id = hotTimers.length.toString();
    hotTimers[id] = jsonTimer;
    return Future.value(id);
  }

  void removeTimerCached(String id) async {
    hotTimers.remove(id);
  }

  void updateTimerCached(String id, TTimer timer) async {
    final jsonTimer = json.encode(timer.toJson());
    hotTimers[id] = jsonTimer;
  }

  void removeAllTimersCached() async {
    hotTimers.clear();
  }

  void saveAllTimersCached() async {
    final jsonTimers = json.encode(hotTimers);
    (await preferences).setString(timers, jsonTimers);
  }
}
