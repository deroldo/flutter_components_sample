import 'package:flutter_components_sample/component/dynamic_platform_screen.dart';
import 'package:flutter_components_sample/model/drawer_item.dart';

import 'component/dynamic_platform_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(DynamicPlatformApp(
    title: 'Custom App',
    routes: {
      "/": (ctx) => Home(),
      "/cart": (ctx) => Cart(),
    },
  ));
}

class Home extends DynamicPlatformScreen {
  const Home() : super(title: "Home");

  @override
  Widget get body {
    return const SingleChildScrollView(child: Text("Home page"));
  }

  @override
  AppDrawer? get appDrawer => MyDrawer();
}

class Cart extends DynamicPlatformScreen {
  const Cart() : super(title: "Cart");

  @override
  Widget get body {
    return const SingleChildScrollView(child: Text("Cart page"));
  }

  @override
  AppDrawer? get appDrawer => MyDrawer();
}

class MyDrawer extends AppDrawer {
  MyDrawer()
      : super(
          title: "Drawer",
          items: [
            const AppDrawerItem(
              Icons.home,
              CupertinoIcons.home,
              title: "Home",
              navigationPath: "/",
            ),
            const AppDrawerItem(
              Icons.shopping_cart,
              CupertinoIcons.cart,
              title: "Carrinho",
              navigationPath: "/cart",
            ),
          ],
        );
}
