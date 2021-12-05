import 'dart:core';

import 'package:flutter/material.dart';

class Timer {
  final Color color;
  final int wormUp;
  final int workout;
  final int rest;
  final int cycles;
  final int cooldown;
  final String title;

  static const String colorAccessor = 'color';
  static const String wormUpAccessor = 'wormUp';
  static const String workoutAccessor = 'workout';
  static const String restAccessor = 'rest';
  static const String cyclesAccessor = 'cycles';
  static const String cooldownAccessor = 'cooldown';
  static const String titleAccessor = 'title';

  Timer(
      {required this.title,
      required this.color,
      required this.wormUp,
      required this.workout,
      required this.rest,
      required this.cycles,
      required this.cooldown});

  factory Timer.fromJson(Map<String, dynamic> json) {
    return Timer(
        color: Color(json[colorAccessor]),
        cooldown: json[cooldownAccessor],
        cycles: json[cyclesAccessor],
        rest: json[restAccessor],
        title: json[titleAccessor],
        workout: json[workoutAccessor],
        wormUp: json[wormUpAccessor]);
  }

  Map<String, dynamic> toJson() {
    return {
      titleAccessor: title,
      colorAccessor: color.toString(),
      wormUpAccessor: wormUp,
      workoutAccessor: workout,
      restAccessor: rest,
      cyclesAccessor: cycles,
      cooldownAccessor: cooldown
    };
  }
}
