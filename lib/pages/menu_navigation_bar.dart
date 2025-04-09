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
      body: Row(children: [
        (!isPortrait) ? buildSideNavigationBar() : const SizedBox.shrink(),
        Expanded(
          child: CustomIndexedStack(index: currentIndex, children: _pages,)
        ),
      ],),
    );
  }

  Widget buildBottomNavigationBar() {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) => _onItemTapped(index),
      destinations: _bottomBarDestinations(context),
    );
  }
  List<NavigationDestination> _bottomBarDestinations(BuildContext context) {
    final localeStr = Language.of(context)!;
    return [
      NavigationDestination(
          selectedIcon: Icon(Icons.qr_code_scanner),
          icon: Icon(Icons.fullscreen),
          label: localeStr.titleScan),
      NavigationDestination(
          selectedIcon: Icon(Icons.edit),
          icon: Icon(Icons.edit_outlined),
          label: localeStr.titleGenerate),
      NavigationDestination(
          selectedIcon: Icon(Icons.history),
          icon: Icon(Icons.history),
          label: localeStr.titleHistory),
      NavigationDestination(
          selectedIcon: Icon(Icons.settings),
          icon: Icon(Icons.settings_outlined),
          label: localeStr.titleSettings),
    ];
  }

  Widget buildSideNavigationBar() {
    return NavigationRail(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) => _onItemTapped(index),
      labelType: NavigationRailLabelType.all,
      groupAlignment: 1.0,
      destinations: _sideBarDestinations(context),
    );
  }
  List<NavigationRailDestination> _sideBarDestinations(BuildContext context) {
    final localeStr = Language.of(context)!;
    return [
      NavigationRailDestination(
          selectedIcon: Icon(Icons.qr_code_scanner),
          icon: Icon(Icons.fullscreen),
          label: Text(localeStr.titleScan)),
      NavigationRailDestination(
          selectedIcon: Icon(Icons.edit),
          icon: Icon(Icons.edit_outlined),
          label: Text(localeStr.titleGenerate)),
      NavigationRailDestination(
          selectedIcon: Icon(Icons.history),
          icon: Icon(Icons.history),
          label: Text(localeStr.titleHistory)),
      NavigationRailDestination(
          selectedIcon: Icon(Icons.settings),
          icon: Icon(Icons.settings_outlined),
          label: Text(localeStr.titleSettings)),
    ];
  }
}