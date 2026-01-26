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
  Widget build(context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(DictKey.preferencesAboutTitle.s),
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
                style: textTheme.headlineSmall,
                textAlign: .center,
              ),
              Text(
                'Copyleft 🄯 YUKAI',
                style: textTheme.bodySmall,
                textAlign: .center,
              ),
              ListTile(
                title: Text(DictKey.preferencesApplicationVersionLabel.s),
                subtitle: Text(StaticString.appVersion),
              ),
              ListTile(
                title: Text(DictKey.preferencesApplicationVersionTagLabel.s),
                subtitle: Text(StaticString.appVersionTag),
              ),
              ListTile(
                title: Text(DictKey.preferencesAboutOpenSourceLibrariesLabel.s),
                subtitle: Text('${StaticString.appName} is Licensed under\nGNU General Public License v3.0'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => showLicensePage(
                  context: context,
                  applicationName: DictKey.preferencesAboutOpenSourceLibrariesLabel.s,
                ),
              ),
              ListTile(
                title: Text(DictKey.preferencesSourceCodeLabel.s),
                subtitle: Text(StaticString.sourceCodeLink),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Utils.openUrlInBrowser(StaticString.sourceCodeLink),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
