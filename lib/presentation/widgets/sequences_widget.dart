import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tabata/data/models/timer.dart';
import 'package:tabata/data/repos/timers_local_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SeqWidget extends StatefulWidget {
  const SeqWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SeqState();
  }
}

class _SeqState extends State<SeqWidget> {
  List<TTimer> timers = [];
  final store = TimersLocalStorage.get_instance();

  @override
  void initState() {
    super.initState();
    _load();
  }

  _load() async {
    try {
      timers = await store.getTimersCached();
    } on Error {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: _buildTimersCards(),
      ),
      appBar: AppBar(
        title: const Text("Tabata"),
        actions: [
          IconButton(
              onPressed: () => _pushSettings(context),
              icon: const Icon(Icons.settings))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {_createTimer(context)},
        tooltip: 'New',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _pushSettings(BuildContext context) async {
    Navigator.of(context).pushNamed('/settings').then((_) async => {
          if (await store.getTimersAmount() == 0)
            {
              setState(() {
                timers = [];
              })
            }
        });
  }

  void _createTimer(BuildContext context) {
    Navigator.of(context).pushNamed('/edit').then((newTimer) async => {
          if (newTimer != null && newTimer is TTimer)
            {
              newTimer.id = await store.saveTimerCached(newTimer),
              setState(() => {timers.add(newTimer)})
            }
        });
  }

  void _removeTimer(TTimer timer) {
    store.removeTimerCached(timer.id);
    setState(() {
      timers.remove(timer);
    });
  }

  List<Widget> _buildTimersCards() {
    List<Widget> ans = [];
    for (var element in timers) {
      ans.add(TimerItem(
        title: element.title,
        wormUp: element.wormUp.toString(),
        workout: element.workout.toString(),
        rest: element.rest.toString(),
        cycles: element.cycles.toString(),
        cooldown: element.cooldown.toString(),
        totalDuration: element.getTotalDuration().toString(),
        color: element.color,
        onRemove: () => _removeTimer(element),
        onEdit: () => {},
        onPlay: () => {},
      ));
    }
    return ans;
  }
}

class _TimerDescription extends StatelessWidget {
  const _TimerDescription(
      {Key? key,
      required this.title,
      required this.warmUp,
      required this.workout,
      required this.rest,
      required this.cycles,
      required this.cooldown,
      required this.totalDuration})
      : super(key: key);

  final String title;
  final String warmUp;
  final String workout;
  final String rest;
  final String cycles;
  final String cooldown;
  final String totalDuration;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 2.0)),
              Text("${AppLocalizations.of(context)!.warmup_lbl}: $warmUp",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption),
              Text("${AppLocalizations.of(context)!.workout_lbl}: $workout",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption),
              Text("${AppLocalizations.of(context)!.rest_lbl}: $rest",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption),
              Text("${AppLocalizations.of(context)!.cycles_lbl}: $cycles",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption),
              Text("${AppLocalizations.of(context)!.total_dur_lbl}: $warmUp",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption),
            ],
          ),
        )
      ],
    );
  }
}

class TimerItem extends StatelessWidget {
  const TimerItem(
      {Key? key,
      required this.title,
      required this.wormUp,
      required this.workout,
      required this.rest,
      required this.cycles,
      required this.cooldown,
      required this.totalDuration,
      required this.color,
      required this.onEdit,
      required this.onPlay,
      required this.onRemove})
      : super(key: key);

  final String title;
  final String wormUp;
  final String workout;
  final String rest;
  final String cycles;
  final String cooldown;
  final String totalDuration;
  final Color color;

  final Function onRemove;
  final Function onEdit;
  final Function onPlay;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 140,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 30,
              color: color,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                child: _TimerDescription(
                  title: title,
                  warmUp: wormUp,
                  workout: workout,
                  rest: rest,
                  cycles: cycles,
                  cooldown: cooldown,
                  totalDuration: totalDuration,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Icon(Icons.delete_forever),
                  onPressed: () => onRemove(),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Icon(Icons.edit),
                  onPressed: () => {},
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Icon(Icons.play_arrow),
                  onPressed: () => {},
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
