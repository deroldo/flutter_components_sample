import 'dart:io';

import 'package:flutter/widgets.dart';

class AppDrawer {
  final String title;
  final List<AppDrawerItem> items;

  AppDrawer({
    required this.title,
    required this.items,
  });
}

class AppDrawerItem {
  final String title;
  final IconData _androidIconName;
  final IconData _iosIconName;
  final String navigationPath;

  const AppDrawerItem(
    this._androidIconName,
    this._iosIconName, {
    required this.title,
    required this.navigationPath,
  });

  Icon get icon {
    if (Platform.isIOS) {
      return Icon(_androidIconName);
    } else {
      return Icon(_iosIconName);
    }
  }
}
