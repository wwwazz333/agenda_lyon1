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
    const primaryColor = Colors.red;
    const secondaryColor = Colors.white;
    const bgColor = Colors.black;

    return Builder(
      builder: (context) => FabCircularMenu(
        key: fabKey,
        alignment: Alignment.bottomRight,
        ringColor: bgColor.withAlpha(25),
        ringDiameter: 300.0,
        ringWidth: 100.0,
        fabSize: 64.0,
        fabElevation: 8.0,
        fabIconBorder: const CircleBorder(),
        fabColor: secondaryColor,
        fabOpenIcon: const Icon(Icons.menu, color: primaryColor),
        fabCloseIcon: const Icon(Icons.close, color: primaryColor),
        fabMargin: const EdgeInsets.all(16.0),
        animationDuration: const Duration(milliseconds: 250),
        animationCurve: Curves.easeInOutCirc,
        onDisplayChange: (isOpen) {},
        children: <Widget>[
          _genButton(context, const Icon(Icons.settings), () {
            Navigator.pushNamed(context, "/settings");
            fabKey.currentState?.close();
          }),
          _genButton(context, const Icon(Icons.search), () {
            Navigator.pushNamed(context, "/listscreen");
            fabKey.currentState?.close();
          }),
          _genButton(context, const Icon(Icons.history), () {
            Navigator.pushNamed(context, "/timeline");
            fabKey.currentState?.close();
          }),
        ],
      ),
    );
  }
}
