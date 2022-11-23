import 'dart:io' show Platform;

import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';

class FloatingNavButton extends StatelessWidget {
  const FloatingNavButton({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
    final secondaryColor = Theme.of(context).primaryColor.withAlpha(50);

    return Builder(
      builder: (context) => FabCircularMenu(
        key: fabKey,
        alignment: Alignment.bottomRight,
        ringColor: secondaryColor,
        ringDiameter: 350.0,
        ringWidth: 100.0,
        fabSize: 64.0,
        fabElevation: 10.0,
        fabIconBorder: const CircleBorder(),
        fabColor: Theme.of(context).primaryColor,
        fabOpenIcon: const Icon(Icons.menu),
        fabCloseIcon: const Icon(Icons.close),
        fabMargin: const EdgeInsets.all(16.0),
        animationDuration: const Duration(milliseconds: 250),
        animationCurve: Curves.easeInOutCirc,
        onDisplayChange: (isOpen) {},
        children: <Widget>[
          NavButton(context, const Icon(Icons.settings), () {
            Navigator.pushNamed(context, "/settings");
            fabKey.currentState?.close();
          }),
          if (Platform.isAndroid)
            NavButton(context, const Icon(Icons.alarm), () {
              Navigator.pushNamed(context, "/list_alarms");
              fabKey.currentState?.close();
            }),
          NavButton(context, const Icon(Icons.search), () {
            Navigator.pushNamed(context, "/search_room");
            fabKey.currentState?.close();
          }),
          NavButton(context, const Icon(Icons.history), () {
            Navigator.pushNamed(context, "/history");
            fabKey.currentState?.close();
          }),
        ],
      ),
    );
  }
}

class NavButton extends StatelessWidget {
  final BuildContext context;
  final Icon icon;
  final Function onPressed;
  const NavButton(this.context, this.icon, this.onPressed, {super.key});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () => onPressed(),
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(16.0),
      fillColor: Theme.of(context).primaryColor,
      child: icon,
    );
  }
}
