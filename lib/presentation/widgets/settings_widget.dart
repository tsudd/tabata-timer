import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabata/common/setup.dart';
import 'package:tabata/data/repos/timers_local_storage.dart';
import 'package:tabata/presentation/blocs/app_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppSetup>(builder: (_, state) {
      return Center(
          child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () async => _setTheme(context),
                      child: Text(
                          AppLocalizations.of(context)!.toggle_theme_btn,
                          style: Theme.of(context).textTheme.button)),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(AppLocalizations.of(context)!.lang_selection_lbl,
                      style: Theme.of(context).textTheme.bodyText1),
                  DropdownButton<Locale>(
                      hint: Text(
                          AppLocalizations.of(context)!.lang_selection_lbl,
                          style: Theme.of(context).textTheme.bodyText1),
                      value: state.locale,
                      onChanged: (loc) async => _setLanguage(context, loc),
                      items: [
                        DropdownMenuItem(
                          child: Text("English",
                              style: Theme.of(context).textTheme.bodyText1),
                          value: const Locale('en', 'US'),
                        ),
                        DropdownMenuItem(
                          child: Text("Русский",
                              style: Theme.of(context).textTheme.bodyText1),
                          value: const Locale('ru', 'RU'),
                        ),
                      ]),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(AppLocalizations.of(context)!.font_sel_lbl,
                      style: Theme.of(context).textTheme.bodyText1),
                  DropdownButton(
                    value: state.fontSize,
                    onChanged: (size) async => _setFontSize(context, size),
                    items: [
                      DropdownMenuItem(
                          child: Text("0.5",
                              style: Theme.of(context).textTheme.bodyText1),
                          value: 0.5),
                      DropdownMenuItem(
                          child: Text("0.75",
                              style: Theme.of(context).textTheme.bodyText1),
                          value: 0.75),
                      DropdownMenuItem(
                          child: Text("1",
                              style: Theme.of(context).textTheme.bodyText1),
                          value: 1.0),
                      DropdownMenuItem(
                          child: Text("1.25",
                              style: Theme.of(context).textTheme.bodyText1),
                          value: 1.25),
                      DropdownMenuItem(
                          child: Text("1.5",
                              style: Theme.of(context).textTheme.bodyText1),
                          value: 1.5),
                    ],
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  ElevatedButton(
                      onPressed: () => _delete_all(),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red)),
                      child: Text(AppLocalizations.of(context)!.delete_all_btn,
                          style: Theme.of(context).textTheme.button)),
                ],
              )));
    });
  }

  void _setTheme(BuildContext context) {
    BlocProvider.of<AppCubit>(context).toggleTheme();
  }

  void _setLanguage(BuildContext context, Locale? loc) {
    BlocProvider.of<AppCubit>(context).setLocale(loc);
  }

  void _delete_all() {
    TimersLocalStorage.getInstance().removeAllTimersCached();
  }

  _setFontSize(BuildContext context, Object? size) {
    var fontSize = size as double;
    BlocProvider.of<AppCubit>(context).setFontSize(fontSize);
  }
}
