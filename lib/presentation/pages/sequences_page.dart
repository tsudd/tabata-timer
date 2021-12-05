import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SeqPage extends StatelessWidget {
  const SeqPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Text("nice", style: Theme.of(context).textTheme.bodyText1),
        ),
        appBar: AppBar(
          title: const Text("Tabata"),
          actions: [
            IconButton(
                onPressed: () => _pushSettings(context),
                icon: const Icon(Icons.settings))
          ],
        ));
  }

  void _pushSettings(BuildContext context) {
    Navigator.of(context).pushNamed('/settings');
  }
}
