import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(MyAppTheme.systemOverlayStyle);
  await Future.wait([PrefsProvider.init(), DatabaseServices.init()]);
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

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WatashiLocale.register([LocaleOption.dictDelegate]);
  }

  @override
  Widget build(context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return ListenableBuilder(
          listenable: context.readPrefs.listens(const [.selectedColor, .selectedTheme, .selectedLanguage]),
          builder: (context, child) {
            return MaterialApp(
              title: StaticString.appName,
              theme: MyAppTheme.themeData(context, lightDynamic, darkDynamic),
              debugShowCheckedModeBanner: false,

              locale: context.readPrefs.get<LocaleOption>(.selectedLanguage).locale,
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
