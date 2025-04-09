import 'package:flutter/material.dart';
import 'package:watashi_qr/pages/menu_creator/main_creator_page.dart';
import 'package:watashi_qr/pages/menu_history/main_history_page.dart';
import 'package:watashi_qr/pages/menu_indexed_stack.dart';
import 'package:watashi_qr/pages/menu_scanner/main_scanner_page.dart';
import 'package:watashi_qr/pages/menu_settings/main_settings_page.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:watashi_qr/common/utils.dart';

class MenuNavigationBar extends StatefulWidget {
  const MenuNavigationBar({super.key});

  @override
  State<MenuNavigationBar> createState() => _MenuNavigationBarState();
}

class _MenuNavigationBarState extends State<MenuNavigationBar> {

  final List<Widget> _pages = const <Widget>[
    MainScannerPage(),
    MainCreatorPage(),
    MainHistoryPage(),
    MainSettingsPage(),
  ];

  int currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() => currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final bool isPortrait = Utils.isPortrait(context);
    return Scaffold(
      bottomNavigationBar: (isPortrait) ? buildBottomNavigationBar() : null,
      body: Row(
        children: [
          (!isPortrait) ? buildSideNavigationBar() : const SizedBox.shrink(),
          Expanded(child: CustomIndexedStack(index: currentIndex, children: _pages,)),
        ],
      ),
    );
  }

  Widget buildBottomNavigationBar() {
    final localeStr = Language.of(context)!;
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (int index) => _onItemTapped(index),
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

  Widget buildSideNavigationBar() {
    final localeStr = Language.of(context)!;
    return NavigationRail(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) => _onItemTapped(index),
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