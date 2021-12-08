import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tabata/data/models/timer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TabataWidget extends StatefulWidget {
  const TabataWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TabataWidgetState();
  }
}

class _TabataWidgetState extends State<TabataWidget> {
  int time = 0;
  int current = 0;
  String step = "";
  Timer? timer;
  Duration dur = const Duration();

  List<_TabataStep> steps = [];
  int selectedStep = 0;

  void reset() {
    setState(() {
      dur = const Duration();
      selectedStep = 0;
    });
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => _addTime());
  }

  void _addTime() {
    setState(() {
      final seconds = dur.inSeconds - 1;
      if (steps.length == selectedStep && seconds < 0) {
        steps[selectedStep - 1] = _TabataStep(
            label: steps[selectedStep - 1].label,
            seconds: steps[selectedStep - 1].seconds);
        timer?.cancel();
        reset();
      } else if (seconds < 0) {
        dur = _nextStep();
      } else {
        dur = Duration(seconds: seconds);
      }
    });
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    setState(() => {timer?.cancel()});
  }

  Duration _nextStep() {
    setState(() {
      step = steps[selectedStep].label;
      steps[selectedStep] = _TabataStep(
        label: steps[selectedStep].label,
        seconds: steps[selectedStep].seconds,
        active: true,
      );
      if (selectedStep > 0) {
        steps[selectedStep - 1] = _TabataStep(
            label: steps[selectedStep - 1].label,
            seconds: steps[selectedStep - 1].seconds);
      }
      selectedStep++;
    });
    return Duration(seconds: steps[selectedStep - 1].seconds);
  }

  _moveNext() {
    var inProc = false;
    if (timer!.isActive) {
      stopTimer(resets: false);
      inProc = true;
    }

    if (selectedStep == steps.length) {
      reset();
      return;
    }
    setState(() {
      dur = _nextStep();
    });
    if (inProc) _startTimer();
  }

  _moveBack() {
    var inProc = false;
    if (timer!.isActive) {
      stopTimer(resets: false);
      inProc = true;
    }
    if (selectedStep < 2) {
      reset();
      return;
    }
    setState(() {
      steps[selectedStep - 1] = _TabataStep(
        label: steps[selectedStep - 1].label,
        seconds: steps[selectedStep - 1].seconds,
      );
      selectedStep -= 2;
      dur = _nextStep();
    });
    if (inProc) _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    if (steps.isEmpty) {
      setState(() {
        steps = _buildSteps(
            context, ModalRoute.of(context)!.settings.arguments as TTimer);
      });
    }
    final counting = timer == null ? false : timer!.isActive;
    return Scaffold(
        appBar: AppBar(title: const Text("Tabata")),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              SizedBox(
                height: 140,
                child: Center(
                  child: Column(
                    children: [
                      Text("${dur.inSeconds}",
                          style: const TextStyle(
                              fontSize: 60, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(step,
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: steps,
                ),
              )
            ],
          ),
        ),
        floatingActionButton:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
              child: ElevatedButton(
                  onPressed: () => _moveBack(),
                  child: const Icon(Icons.skip_previous))),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              child: counting
                  ? ElevatedButton(
                      onPressed: () => stopTimer(resets: false),
                      child: const Icon(Icons.pause))
                  : ElevatedButton(
                      onPressed: () => _startTimer(),
                      child: const Icon(Icons.play_arrow))),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              child: ElevatedButton(
                  onPressed: () => _moveNext(),
                  child: const Icon(Icons.skip_next)))
        ]));
  }

  List<_TabataStep> _buildSteps(BuildContext context, TTimer timer) {
    List<_TabataStep> stepses = [
      _TabataStep(
          label: AppLocalizations.of(context)!.warmup_lbl,
          seconds: timer.wormUp)
    ];
    for (int i = 0; i < timer.cycles; i++) {
      stepses.add(_TabataStep(
          label: AppLocalizations.of(context)!.workout_lbl,
          seconds: timer.workout));
      stepses.add(_TabataStep(
          label: AppLocalizations.of(context)!.rest_lbl, seconds: timer.rest));
    }
    stepses.add(_TabataStep(
        label: AppLocalizations.of(context)!.workout_lbl,
        seconds: timer.workout));
    stepses.add(_TabataStep(
        label: AppLocalizations.of(context)!.cooldown_lbl,
        seconds: timer.cooldown));
    return stepses;
  }
}

class _TabataStep extends StatefulWidget {
  final String label;
  final int seconds;
  final bool active;
  const _TabataStep(
      {Key? key,
      required this.label,
      required this.seconds,
      this.active = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TabataStepState();
  }
}

class _TabataStepState extends State<_TabataStep> {
  @override
  Widget build(BuildContext context) {
    return Card(
        color: widget.active
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.background,
        child: ListTile(
            title: Text(widget.label,
                style: Theme.of(context).textTheme.bodyText1),
            trailing: Text("${widget.seconds}",
                style: Theme.of(context).textTheme.bodyText1)));
  }
}
