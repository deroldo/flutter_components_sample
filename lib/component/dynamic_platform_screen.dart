import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/drawer_item.dart';

abstract class DynamicPlatformScreen extends StatelessWidget {
  final String title;

  Widget get body;

  AppDrawer? get appDrawer {
    return null;
  }

  const DynamicPlatformScreen({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return _IosScreen(
        title: title,
        body: SafeArea(child: body),
        appDrawer: appDrawer,
      );
    } else {
      return _AndroidScreen(
        title: title,
        body: SafeArea(child: body),
        appDrawer: appDrawer,
      );
    }
  }
}

class _AndroidScreen extends StatelessWidget {
  final String title;
  final AppDrawer? appDrawer;
  final Widget body;

  const _AndroidScreen({
    required this.title,
    required this.appDrawer,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    Drawer? drawer;
    if (appDrawer != null) {
      List<Widget> cards = appDrawer!.items.map((item) {
        return ListTile(
          leading: item.icon,
          title: Text(item.title),
          onTap: () => Navigator.of(context).pushReplacementNamed(item.navigationPath),
        );
      }).toList();

      drawer = Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppBar(
              title: Text(appDrawer!.title),
              automaticallyImplyLeading: false,
            ),
            const Divider(),
            ...cards
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: drawer,
      body: body,
    );
  }
}

class _IosScreen extends StatefulWidget {
  final String title;
  final AppDrawer? appDrawer;
  final Widget body;

  const _IosScreen({
    required this.title,
    required this.appDrawer,
    required this.body,
  });

  bool get hasDrawer => appDrawer != null;

  @override
  State<_IosScreen> createState() => _IosScreenState();
}

class _IosScreenState extends State<_IosScreen> with SingleTickerProviderStateMixin {
  static const Duration _animationDuration = Duration(milliseconds: 300);

  bool openedMenu = false;
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );

    _opacityAnimation = Tween(
      begin: 0.0,
      end: 0.3,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    CupertinoButton? button;
    if (widget.hasDrawer) {
      button = CupertinoButton(
        child: openedMenu ? const Icon(CupertinoIcons.left_chevron) : const Icon(CupertinoIcons.bars),
        onPressed: () {
          setState(() {
            openedMenu = !openedMenu;
            if (openedMenu) {
              _controller.forward();
            } else {
              _controller.reverse();
            }
          });
        },
      );
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(openedMenu ? widget.appDrawer!.title : widget.title),
        leading: button,
      ),
      child: SafeArea(
        child: widget.hasDrawer
            ? Stack(
                children: [
                  widget.body,
                  FadeTransition(
                    opacity: _opacityAnimation,
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: const BoxDecoration(color: Colors.black),
                    ),
                  ),
                  AnimatedContainer(
                    duration: _animationDuration,
                    curve: Curves.linear,
                    height: double.infinity,
                    width: openedMenu ? deviceSize.width * 0.7 : 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                        boxShadow: openedMenu
                            ? [
                                const BoxShadow(
                                  color: Colors.black38,
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ]
                            : [],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: widget.appDrawer!.items.map((item) {
                            return GestureDetector(
                              onTap: () => Navigator.of(context).pushReplacementNamed(item.navigationPath),
                              child: Container(
                                color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 15,
                                      ),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: AlignmentDirectional.centerStart,
                                          child: Row(
                                            children: [
                                              item.icon,
                                              const SizedBox(width: 10),
                                              Text(item.title),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Divider()
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  )
                ],
              )
            : widget.body,
      ),
    );
  }
}
