import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watashi_qr/locale/app_language.dart';
import 'package:watashi_qr/pages/menu_creator/main_creator_view.dart';
import 'package:watashi_qr/pages/menu_history/main_history_view.dart';
import 'package:watashi_qr/pages/menu_scanner/main_scanner_view.dart';
import 'package:watashi_qr/pages/menu_settings/main_settings_view.dart';
import 'package:watashi_qr/common/utils.dart';

class MenuNavBar extends StatefulWidget {
  const MenuNavBar({super.key});

  @override
  State<MenuNavBar> createState() => _MenuNavBarState();
}

class MenuNavBarProvider extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  bool get onScanner => _currentIndex == 0;

  void updateIndex(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }
  }
}

class _MenuNavBarState extends State<MenuNavBar> {
  final List<Widget> _pages = const [
    MainScannerView(),
    MainCreatorView(),
    MainHistoryView(),
    MainSettingsView(),
  ];

  @override
  Widget build(context) {
    DictKey.load(context);
    final bool isPortrait = Utils.isPortrait(context);
    return Consumer<MenuNavBarProvider>(
      builder: (context, state, child) => Scaffold(
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
    return NavigationBar(
      selectedIndex: state.currentIndex,
      onDestinationSelected: state.updateIndex,
      destinations: [
        NavigationDestination(
          selectedIcon: const Icon(Icons.qr_code_scanner),
          icon: const Icon(Icons.fullscreen),
          label: DictKey.navTitleScan.s
        ),
        NavigationDestination(
          selectedIcon: const Icon(Icons.edit),
          icon: const Icon(Icons.edit_outlined),
          label: DictKey.navTitleGenerate.s
        ),
        NavigationDestination(
          selectedIcon: const Icon(Icons.history),
          icon: const Icon(Icons.history),
          label: DictKey.navTitleHistory.s
        ),
        NavigationDestination(
          selectedIcon: const Icon(Icons.settings),
          icon: const Icon(Icons.settings_outlined),
          label: DictKey.navTitleSettings.s
        ),
      ],
    );
  }

  Widget _buildSideNavigationBar(MenuNavBarProvider state) {
    return NavigationRail(
      selectedIndex: state.currentIndex,
      onDestinationSelected: state.updateIndex,
      labelType: .all,
      groupAlignment: 1.0,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      destinations: [
        NavigationRailDestination(
          selectedIcon: const Icon(Icons.qr_code_scanner),
          icon: const Icon(Icons.fullscreen),
          label: Text(DictKey.navTitleScan.s)
        ),
        NavigationRailDestination(
          selectedIcon: const Icon(Icons.edit),
          icon: const Icon(Icons.edit_outlined),
          label: Text(DictKey.navTitleGenerate.s)
        ),
        NavigationRailDestination(
          selectedIcon: const Icon(Icons.history),
          icon: const Icon(Icons.history),
          label: Text(DictKey.navTitleHistory.s)
        ),
        NavigationRailDestination(
          selectedIcon: const Icon(Icons.settings),
          icon: const Icon(Icons.settings_outlined),
          label: Text(DictKey.navTitleSettings.s)
        ),
      ],
    );
  }
}
