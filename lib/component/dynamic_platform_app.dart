import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DynamicPlatformApp extends StatelessWidget {
  final String title;
  final Map<String, WidgetBuilder> routes;
  CupertinoThemeData? iosTheme;
  ThemeData? androidTheme;

  DynamicPlatformApp({
    Key? key,
    this.androidTheme,
    this.iosTheme,
    required this.title,
    required this.routes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoApp(
        title: title,
        theme: iosTheme,
        routes: routes,
      );
    } else {
      return MaterialApp(
        title: title,
        theme: androidTheme,
        routes: routes,
      );
    }
  }
}
