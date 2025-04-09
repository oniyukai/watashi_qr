import 'package:flutter/material.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:watashi_qr/common/utils.dart';

class AppAboutPage extends StatefulWidget {
  const AppAboutPage({super.key});

  @override
  State<AppAboutPage> createState() => _AppAboutPageState();
}

class _AppAboutPageState extends State<AppAboutPage> {
  @override
  Widget build(BuildContext context) {
    final localeStr = Language.of(context)!;
    final theme = Theme.of(context);
    final trailingIcon = Icon((Directionality.of(context) == TextDirection.ltr)
      ? Icons.chevron_right
      : Icons.chevron_left
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(localeStr.preferencesAboutTitle),
      ),
      body: SafeArea(
        child: Scrollbar(
          child: ListView(
            children: [
              const SizedBox(
                width: 64,
                height: 64,
                child: Image(
                  image: AssetImage('assets/appicon.png'),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                Language.appName,
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              Text(
                'Copyleft 🄯 YUKAI',
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              ListTile(
                title: Text(localeStr.preferencesApplicationVersionLabel),
                subtitle: Text(Language.appVersion),
              ),
              ListTile(
                title: const Text('Version Code'),
                subtitle: Text(Language.appVersionCode),
              ),
              ListTile(
                title: Text(localeStr.preferencesAboutThirdPartyLibrariesLabel),
                trailing: trailingIcon,
                onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) => LicensePage(
                      applicationName: localeStr.preferencesAboutThirdPartyLibrariesLabel,
                    )
                  )
                ),
              ),
              ListTile(
                title: const Text('Licences'),
                subtitle: Text('The App is Licensed under \n${Language.gnuGeneralPublicLicenseV3} by YUKAI'),
                trailing: trailingIcon,
                onTap: () => Utils.openUrlInBrowser(Language.gnuGeneralPublicLicenseV3Url),
              ),
              ListTile(
                title: Text(localeStr.preferencesSourceCodeLabel),
                subtitle: Text(Language.sourceCodeLink),
                trailing: trailingIcon,
                onTap: () => Utils.openUrlInBrowser(Language.sourceCodeLink),
              ),
            ],
          )
        )
      )
    );
  }
}