import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/locale/app_language.dart';

class PageAboutView extends StatefulWidget {
  const PageAboutView({super.key});

  @override
  State<PageAboutView> createState() => _PageAboutViewState();
}

class _PageAboutViewState extends State<PageAboutView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trailingIcon = Icon((Directionality.of(context) == TextDirection.ltr)
      ? Icons.chevron_right
      : Icons.chevron_left
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.preferencesAboutTitle.s),
      ),
      body: SafeArea(
        child: Scrollbar(
          child: ListView(
            children: [
              SizedBox(
                width: 64,
                height: 64,
                child: Image(
                  image: AssetImage(p.join('assets/', 'appicon.png')),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                StaticString.appName,
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              Text(
                'Copyleft 🄯 YUKAI',
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              ListTile(
                title: Text(AppLocale.preferencesApplicationVersionLabel.s),
                subtitle: Text(StaticString.appVersion),
              ),
              ListTile(
                title: const Text('Version Tag'),
                subtitle: Text(StaticString.appVersionTag),
              ),
              ListTile(
                title: Text(AppLocale.preferencesAboutOpenSourceLibrariesLabel.s),
                trailing: trailingIcon,
                onTap: () => showLicensePage(
                  context: context,
                  applicationName: AppLocale.preferencesAboutOpenSourceLibrariesLabel.s,
                ),
              ),
              ListTile(
                title: const Text('Licence'),
                subtitle: Text('This App is Licensed under\nGNU General Public License v3.0'),
                trailing: trailingIcon,
                onTap: () => Utils.openUrlInBrowser('https://www.gnu.org/licenses/gpl-3.0.html'),
              ),
              ListTile(
                title: Text(AppLocale.preferencesSourceCodeLabel.s),
                subtitle: Text(StaticString.sourceCodeLink),
                trailing: trailingIcon,
                onTap: () => Utils.openUrlInBrowser(StaticString.sourceCodeLink),
              ),
            ],
          )
        )
      )
    );
  }
}