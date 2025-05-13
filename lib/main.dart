import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:watashi_qr/common/router.dart';
import 'package:watashi_qr/common/app_theme.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/pages/menu_navigation_bar.dart';
import 'package:watashi_qr/pages/menu_settings/settings_provider.dart';
import 'package:watashi_qr/locale/app_localizations.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:watashi_qr/common/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.hiveInit();
  await Utils.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MenuNavBarProvider()),
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
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
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached) {
      HiveService.hiveClose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic){
        return Consumer<SettingsProvider>(
            builder: (context, settings, child) {
              return MaterialApp(

                title: Language.appName,
                theme: appTheme(context, settings.selectedTheme, settings.selectedColor, lightDynamic, darkDynamic),
                debugShowCheckedModeBanner: false,

                locale: LocaleOption.localeFromName(settings.selectedLanguage),
                localizationsDelegates: LocaleOption.localizationsDelegates,
                supportedLocales: LocaleOption.supportedLocales,

                routes: MyRouter.ROUTES,
                navigatorKey: MyRouter.navigatorKey,
                onGenerateRoute: MyRouter.onGenerateRoute,

              );
            }
        );
      },
    );
  }
}