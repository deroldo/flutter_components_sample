import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/app_tabs.dart';

class DynamicPlatformNavigationTab extends StatelessWidget {
  final AppTabs appTabs;

  const DynamicPlatformNavigationTab({
    required this.appTabs,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: appTabs.tabs.map((tab) {
            return BottomNavigationBarItem(
              icon: tab.icon,
              label: tab.label,
              activeIcon: tab.activeIcon,
            );
          }).toList(),
        ),
        tabBuilder: (ctx, i) {
          return CupertinoTabView(builder: (ctx) => appTabs.tabs[i].screen);
        },
      );
    } else {
      return _AndroidNavigationBar(appTabs: appTabs);
    }
  }
}

class _AndroidNavigationBar extends StatefulWidget {
  final AppTabs appTabs;

  _AndroidNavigationBar({
    required this.appTabs,
  });

  @override
  State<_AndroidNavigationBar> createState() => _AndroidNavigationBarState();
}

class _AndroidNavigationBarState extends State<_AndroidNavigationBar> {
  int _selectedIndex = 0;
  Drawer? drawer;

  @override
  Widget build(BuildContext context) {
    drawer = widget.appTabs.tabs[_selectedIndex].screen.appDrawer?.toDrawer(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appTabs.tabs[_selectedIndex].label),
      ),
      body: widget.appTabs.tabs[_selectedIndex].screen,
      drawer: drawer,
      bottomNavigationBar: BottomNavigationBar(
        items: widget.appTabs.tabs.map((tab) {
          return BottomNavigationBarItem(icon: tab.icon, label: tab.label);
        }).toList(),
        currentIndex: _selectedIndex,
        onTap: (i) {
          setState(() {
            _selectedIndex = i;
          });
        },
      ),
    );
  }
}
