import 'package:flutter/widgets.dart';
import 'package:flutter_components_sample/component/dynamic_platform_screen.dart';

class AppTabs {
  final List<AppTab> tabs;

  AppTabs(this.tabs) {
    if (tabs.length < 2) {
      throw ("You should add at least 2 and until 5 tabs");
    } else if (tabs.length > 5) {
      throw ("You can't add more than 5 tabs");
    }
  }
}

class AppTab {
  final Icon icon;
  final Icon? activeIcon;
  final String label;
  final DynamicPlatformScreen screen;

  AppTab({
    required this.icon,
    this.activeIcon,
    required this.label,
    required this.screen,
  });
}
