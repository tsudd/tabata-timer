import 'dart:core';

import 'package:flutter/material.dart';

class TTimer {
  final Color color;
  final int wormUp;
  final int workout;
  final int rest;
  final int cycles;
  final int cooldown;
  final String title;
  String id = "";

  static const String colorAccessor = 'color';
  static const String wormUpAccessor = 'wormUp';
  static const String workoutAccessor = 'workout';
  static const String restAccessor = 'rest';
  static const String cyclesAccessor = 'cycles';
  static const String cooldownAccessor = 'cooldown';
  static const String titleAccessor = 'title';
  static const String idAccessor = "id";

  TTimer(
      {required this.title,
      required this.color,
      required this.wormUp,
      required this.workout,
      required this.rest,
      required this.cycles,
      required this.cooldown,
      this.id = ""});

  int getTotalDuration() {
    return cycles * (wormUp + workout + rest + cooldown);
  }

  factory TTimer.fromJson(Map<String, dynamic> json) {
    return TTimer(
        color: Color(int.parse(json[colorAccessor], radix: 16)),
        cooldown: json[cooldownAccessor],
        cycles: json[cyclesAccessor],
        rest: json[restAccessor],
        title: json[titleAccessor],
        workout: json[workoutAccessor],
        wormUp: json[wormUpAccessor],
        id: json[idAccessor]);
  }

  Map<String, dynamic> toJson() {
    return {
      titleAccessor: title,
      colorAccessor: color.toString().split('(0x')[1].split(')')[0],
      wormUpAccessor: wormUp,
      workoutAccessor: workout,
      restAccessor: rest,
      cyclesAccessor: cycles,
      cooldownAccessor: cooldown,
      idAccessor: id
    };
  }
}
