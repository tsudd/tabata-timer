import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tabata/presentation/widgets/settings_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SettingsWidget(),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings_title),
      ),
    );
  }
}
