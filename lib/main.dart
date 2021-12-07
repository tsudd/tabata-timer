import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tabata/common/setup.dart';
import 'package:tabata/presentation/pages/edit_seq_page.dart';
import 'package:tabata/presentation/pages/sequences_page.dart';
import 'package:tabata/presentation/pages/tabata_page.dart';
import 'presentation/blocs/app_bloc.dart';
import 'presentation/pages/settings_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => _loadCubit(), child: const AppView());
  }

  AppCubit _loadCubit() {
    var cub = AppCubit(AppSetup.getDefault());
    cub.tryLoadSetup();
    return cub;
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppSetup>(builder: (_, state) {
      ThemeData selTheme = ThemeData();
      if (state.day) {
        var light = ThemeData.light();
        selTheme = light.copyWith(
            textTheme: light.textTheme.copyWith(
                caption: light.textTheme.caption!
                    .copyWith(fontSize: state.styleSize * 0.7),
                bodyText1: light.textTheme.bodyText1!
                    .copyWith(fontSize: state.styleSize),
                button: light.textTheme.button!
                    .copyWith(fontSize: state.styleSize)));
      } else {
        var dark = ThemeData.dark();
        selTheme = dark.copyWith(
            textTheme: dark.textTheme.copyWith(
                caption: dark.textTheme.caption!
                    .copyWith(fontSize: state.styleSize * 0.7),
                bodyText1: dark.textTheme.bodyText1!
                    .copyWith(fontSize: state.styleSize),
                button: dark.textTheme.button!
                    .copyWith(fontSize: state.styleSize)));
      }
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: AppSetup.locales,
        theme: selTheme,
        initialRoute: '/',
        locale: state.locale,
        routes: {
          '/': (context) => const SeqPage(),
          '/edit': (context) => const EditSeqPage(),
          '/tabata': (context) => TabataPage(),
          '/settings': (context) => const SettingsPage()
        },
      );
    });
  }
}
