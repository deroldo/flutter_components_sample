import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppDrawer {
  final String title;
  final List<AppDrawerItem> items;

  AppDrawer({
    required this.title,
    required this.items,
  });

  Drawer toDrawer(BuildContext context) {
    List<Widget> cards = items.map((item) {
      return ListTile(
        leading: item.icon,
        title: Text(item.title),
        onTap: () => Navigator.of(context).pushReplacementNamed(item.navigationPath),
      );
    }).toList();

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppBar(
              title: Text(title),
              automaticallyImplyLeading: false,
            ),
            ...cards
          ],
        ),
      ),
    );
  }
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
