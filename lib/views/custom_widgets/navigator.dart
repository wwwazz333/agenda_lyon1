import 'dart:io' show Platform;

import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';

class FloatingNavButton extends StatelessWidget {
  const FloatingNavButton({super.key});

  Widget _genButton(BuildContext context, Icon icon, Function onPressed) {
    return RawMaterialButton(
      onPressed: () => onPressed(),
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(24.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
    final secondaryColor = Theme.of(context).primaryColor;

    return Builder(
      builder: (context) => FabCircularMenu(
        key: fabKey,
        alignment: Alignment.bottomRight,
        ringColor: secondaryColor.withAlpha(45),
        ringDiameter: 300.0,
        ringWidth: 100.0,
        fabSize: 64.0,
        fabElevation: 8.0,
        fabIconBorder: const CircleBorder(),
        fabColor: secondaryColor,
        fabOpenIcon: const Icon(Icons.menu),
        fabCloseIcon: const Icon(Icons.close),
        fabMargin: const EdgeInsets.all(16.0),
        animationDuration: const Duration(milliseconds: 250),
        animationCurve: Curves.easeInOutCirc,
        onDisplayChange: (isOpen) {},
        children: <Widget>[
          _genButton(context, const Icon(Icons.settings), () {
            Navigator.pushNamed(context, "/settings");
            fabKey.currentState?.close();
          }),
          if (Platform.isAndroid)
            _genButton(context, const Icon(Icons.alarm), () {
              Navigator.pushNamed(context, "/list_alarms");
              fabKey.currentState?.close();
            }),
          _genButton(context, const Icon(Icons.history), () {
            Navigator.pushNamed(context, "/history");
            fabKey.currentState?.close();
          }),
        ],
      ),
    );
  }
}
