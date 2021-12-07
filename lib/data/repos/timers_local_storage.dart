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

  Future<int> getTimersAmount() async {
    return Future.value(hotTimers.length);
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
    var id = hotTimers.length.toString();
    timer.id = id;
    final jsonTimer = json.encode(timer.toJson());
    hotTimers[id] = jsonTimer;
    (await preferences).setString(timers, json.encode(hotTimers));
    return Future.value(id);
  }

  void removeTimerCached(String id) async {
    hotTimers.remove(id);
    (await preferences).setString(timers, json.encode(hotTimers));
  }

  void updateTimerCached(String id, TTimer timer) async {
    final jsonTimer = json.encode(timer.toJson());
    hotTimers[id] = jsonTimer;
    (await preferences).setString(timers, json.encode(hotTimers));
  }

  void removeAllTimersCached() async {
    hotTimers.clear();
    (await preferences).setString(timers, "");
  }

  void saveAllTimersCached() async {
    final jsonTimers = json.encode(hotTimers);
    (await preferences).setString(timers, jsonTimers);
  }
}
