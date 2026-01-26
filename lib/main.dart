import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:watashi_locale/watashi_locale.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:watashi_qr/common/app_theme.dart';
import 'package:watashi_qr/locale/app_language.dart';
import 'package:watashi_qr/pages/menu_nav_bar.dart';
import 'package:watashi_qr/common/prefs.dart';
import 'package:watashi_qr/locale/app_localizations.dart';
import 'package:watashi_qr/common/database_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefsProvider.init();
  await DatabaseServices.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MenuNavBarProvider()),
        ChangeNotifierProvider(create: (context) => PrefsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WatashiLocale.register([LocaleOption.dictDelegate]);
  }

  @override
  void dispose() {
    DatabaseServices.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return Consumer<PrefsProvider>(
          builder: (context, prefs, child) {
            return MaterialApp(
              title: StaticString.appName,
              theme: appTheme(context, lightDynamic, darkDynamic),
              debugShowCheckedModeBanner: false,

              locale: prefs.get<LocaleOption>(.selectedLanguage).locale,
              localizationsDelegates: WatashiLocale.localizationsDelegates,
              supportedLocales: WatashiLocale.supportedLocales,

              navigatorKey: MyRouter.navigatorKey,
              routes: MyRouter.routes,
              onGenerateRoute: MyRouter.onGenerateRoute,
              onUnknownRoute: MyRouter.onUnknownRoute,
            );
          },
        );
      },
    );
  }
}
