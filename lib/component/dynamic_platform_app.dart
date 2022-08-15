import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dynamic_platform_navigation_tab.dart';

class DynamicPlatformAppData {
  final DynamicPlatformNavigationTab? navigationTab;

  DynamicPlatformAppData({
    this.navigationTab,
  });

  bool get hasNavigationTab => navigationTab != null;

  bool diff(DynamicPlatformAppData old) {
    return old.navigationTab != navigationTab;
  }
}

class DynamicPlatformAppProvider extends InheritedWidget {
  late DynamicPlatformAppData appData;

  DynamicPlatformAppProvider({
    DynamicPlatformNavigationTab? navigationTab,
    required super.child,
  }) {
    appData = DynamicPlatformAppData(navigationTab: navigationTab);
  }

  static DynamicPlatformAppProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DynamicPlatformAppProvider>();
  }

  @override
  bool updateShouldNotify(covariant DynamicPlatformAppProvider oldProvider) {
    return appData.diff(oldProvider.appData);
  }
}

class DynamicPlatformApp extends StatelessWidget {
  final String title;
  late Map<String, WidgetBuilder> routes;
  CupertinoThemeData? iosTheme;
  ThemeData? androidTheme;
  DynamicPlatformNavigationTab? navigationTab;

  DynamicPlatformApp({
    Key? key,
    this.androidTheme,
    this.iosTheme,
    this.navigationTab,
    required this.title,
    required Map<String, WidgetBuilder> routes,
  }) : super(key: key) {
    if (navigationTab != null && routes.keys.contains("/")) {
      throw ("You can't declare a root path (/) with navigation tab");
    } else if (navigationTab == null && !routes.keys.contains("/")) {
      throw ("You must declare a root path (/) or use a navigation tab");
    }

    if (navigationTab != null) {
      routes.addAll({"/": (ctx) => navigationTab!});
    }

    this.routes = routes;
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return DynamicPlatformAppProvider(
        navigationTab: navigationTab,
        child: CupertinoApp(
          title: title,
          theme: iosTheme,
          routes: routes,
        ),
      );
    } else {
      return DynamicPlatformAppProvider(
        navigationTab: navigationTab,
        child: MaterialApp(
          title: title,
          theme: androidTheme,
          routes: routes,
        ),
      );
    }
  }
}
