import 'package:flutter/material.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:watashi_qr/common/utils.dart';

class PageAboutView extends StatefulWidget {
  const PageAboutView({super.key});

  @override
  State<PageAboutView> createState() => _PageAboutViewState();
}

class _PageAboutViewState extends State<PageAboutView> {
  @override
  Widget build(BuildContext context) {
    final localeStr = Language.of(context);
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
                title: const Text('Version Tag'),
                subtitle: Text(Language.appVersionTag),
              ),
              ListTile(
                title: Text(localeStr.preferencesAboutOpenSourceLibrariesLabel),
                trailing: trailingIcon,
                onTap: () => showLicensePage(
                  context: context,
                  applicationName: localeStr.preferencesAboutOpenSourceLibrariesLabel,
                ),
              ),
              ListTile(
                title: const Text('Licence'),
                subtitle: Text('This App is Licensed under\nGNU General Public License v3.0'),
                trailing: trailingIcon,
                onTap: () => Utils.openUrlInBrowser('https://www.gnu.org/licenses/gpl-3.0.html'),
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