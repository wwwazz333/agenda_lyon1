import 'package:agenda_lyon1/common/colors.dart';
import 'package:flutter/material.dart';
import '../../../controller/event_controller.dart';

abstract class CardEvent extends StatefulWidget {
  final Color Function() bgColor;
  final String title;
  final String subTitle;
  final String debut;
  final String fin;
  final int Function() nbrTask;
  final EventController controller;
  const CardEvent(
      {required this.title,
      required this.subTitle,
      required this.debut,
      required this.fin,
      required this.controller,
      required this.nbrTask,
      required this.bgColor,
      super.key});

  Color? get fontColor => ColorsEvents().goodColorFontOnBackground(bgColor());
}
