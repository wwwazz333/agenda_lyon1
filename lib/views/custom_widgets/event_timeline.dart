import 'package:flutter/material.dart';
import 'card/card_timeline.dart';
import 'event_display.dart';

class EventTimeLine extends EventDisplay {
  const EventTimeLine(super.dayController,
      {required super.firstHour,
      required super.lastHour,
      super.oneHoureH,
      super.key});
  static const fontSize = 20.0;
  static const textStyle = TextStyle(fontSize: fontSize);

  //previously 25.0
  final maxWidthNumber = 0.0;

  int get nbrOfHour {
    return lastHour - firstHour;
  }

  Widget _genBackground(BuildContext context) {
    return SizedBox(
      height: (nbrOfHour * oneHoureH).abs(),
    );
  }

  List<Widget> stackedStuff(BuildContext context) {
    List<Widget> toStack = [];
    toStack.add(_genBackground(context));

    for (int i = 0; i < dayController.length; i++) {
      final infos = dayController.infoEvent(i);
      final infosOverlapping = dayController.getOverlapAndPosX(i);
      toStack.add(CardEventTimeLine(
        title: infos["title"],
        subTitle: (infos["subTitle"] as List<String>).join(", "),
        debut: infos["debut"],
        fin: infos["fin"],
        controller: infos["controller"],
        oneHoureH: oneHoureH,
        nbrOverlap: infosOverlapping["Overlap"],
        placeForOverlape: infosOverlapping["PosX"],
        startHour: firstHour,
        bgColor: infos["color"],
        nbrTask: infos["nbrTask"],
      ));
    }
    if (dayController.isCurrDate()) {
      toStack.add(Positioned(
          left: 0,
          top: oneHoureH * (DateTime.now().hour - firstHour) +
              oneHoureH / 60 * DateTime.now().minute,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 3,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.red,
            ),
          )));
    }

    return toStack;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 1.0,
        builder: (context, scrollController) => SingleChildScrollView(
              child: SizedBox(
                height: oneHoureH * nbrOfHour,
                child: Stack(
                  children: stackedStuff(context),
                ),
              ),
            ));
  }
}
