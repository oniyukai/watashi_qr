import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watashi_qr/pages/menu_creator/main_creator_page.dart';
import 'package:watashi_qr/pages/menu_history/main_history_page.dart';
import 'package:watashi_qr/pages/menu_scanner/main_scanner_page.dart';
import 'package:watashi_qr/pages/menu_settings/main_settings_page.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:watashi_qr/common/utils.dart';

class MenuNavigationBar extends StatefulWidget {
  const MenuNavigationBar({super.key});

  @override
  State<MenuNavigationBar> createState() => _MenuNavigationBarState();
}

class MenuNavBarProvider extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void updateIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}

class _MenuNavigationBarState extends State<MenuNavigationBar> {

  final List<Widget> _pages = const <Widget>[
    MainScannerPage(),
    MainCreatorPage(),
    MainHistoryPage(),
    MainSettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isPortrait = Utils.isPortrait(context);
    return Consumer<MenuNavBarProvider>(
      builder: (context, state, _) => Scaffold(
        bottomNavigationBar: isPortrait ? _buildBottomNavigationBar(state) : null,
        body: Row(
          children: [
            if (!isPortrait) _buildSideNavigationBar(state),
            Expanded(child: IndexedStack(index: state.currentIndex, children: _pages)),
          ],
        ),
      )
    );
  }

  Widget _buildBottomNavigationBar(MenuNavBarProvider state) {
    final localeStr = Language.of(context);
    return NavigationBar(
      selectedIndex: state.currentIndex,
      onDestinationSelected: (int index) => state.updateIndex(index),
      destinations: <NavigationDestination>[
        NavigationDestination(
          selectedIcon: const Icon(Icons.qr_code_scanner),
          icon: const Icon(Icons.fullscreen),
          label: localeStr.titleScan),
        NavigationDestination(
          selectedIcon: const Icon(Icons.edit),
          icon: const Icon(Icons.edit_outlined),
          label: localeStr.titleGenerate),
        NavigationDestination(
          selectedIcon: const Icon(Icons.history),
          icon: const Icon(Icons.history),
          label: localeStr.titleHistory),
        NavigationDestination(
          selectedIcon: const Icon(Icons.settings),
          icon: const Icon(Icons.settings_outlined),
          label: localeStr.titleSettings),
      ],
    );
  }

  Widget _buildSideNavigationBar(MenuNavBarProvider state) {
    final localeStr = Language.of(context);
    return NavigationRail(
      selectedIndex: state.currentIndex,
      onDestinationSelected: (index) => state.updateIndex(index),
      labelType: NavigationRailLabelType.all,
      groupAlignment: 1.0,
      destinations: <NavigationRailDestination>[
        NavigationRailDestination(
          selectedIcon: const Icon(Icons.qr_code_scanner),
          icon: const Icon(Icons.fullscreen),
          label: Text(localeStr.titleScan)),
        NavigationRailDestination(
          selectedIcon: const Icon(Icons.edit),
          icon: const Icon(Icons.edit_outlined),
          label: Text(localeStr.titleGenerate)),
        NavigationRailDestination(
          selectedIcon: const Icon(Icons.history),
          icon: const Icon(Icons.history),
          label: Text(localeStr.titleHistory)),
        NavigationRailDestination(
          selectedIcon: const Icon(Icons.settings),
          icon: const Icon(Icons.settings_outlined),
          label: Text(localeStr.titleSettings)),
      ],
    );
  }
}