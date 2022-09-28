import 'package:flutter/material.dart';

import '../../controller/event_controller.dart';
import 'card_event.dart';

class EventTimeLine extends StatelessWidget {
  final DayController _dayController;
  const EventTimeLine(this._dayController,
      {required this.firstHour,
      required this.lastHour,
      this.oneHoureH = 70,
      super.key});
  final double oneHoureH;
  final int firstHour;
  final int lastHour;
  static const fontSize = 20.0;
  static const textStyle = TextStyle(fontSize: fontSize);

  final maxWidthNumber = 25.0;

  int get nbrOfHour {
    return lastHour - firstHour;
  }

  Widget _genBackground(BuildContext context) {
    return CustomPaint(
      size: Size(MediaQuery.of(context).size.width, nbrOfHour * oneHoureH),
      painter: BackgroundPainter(
          heightOfOneHour: oneHoureH,
          firstHour: firstHour,
          lastHour: lastHour,
          maxWidthNumber: maxWidthNumber),
    );
  }

  List<Widget> stackedStuff(BuildContext context) {
    List<Widget> toStack = [];
    toStack.add(_genBackground(context));

    for (int i = 0; i < _dayController.length; i++) {
      final infos = _dayController.infoEvent(i);
      final infosOverlapping = _dayController.getOverlapAndPosX(i);

      toStack.add(CardEventTimeLine(
        title: infos["title"],
        subTitle: infos["subTitle"],
        debut: infos["debut"],
        fin: infos["fin"],
        controller: infos["controller"],
        onHoureH: oneHoureH,
        nbrOverlap: infosOverlapping["Overlap"],
        placeForOverlape: infosOverlapping["PosX"],
        maxWidthNumber: maxWidthNumber,
        startHour: firstHour,
      ));
    }
    if (_dayController.isCurrDate()) {
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

class BackgroundPainter extends CustomPainter {
  final double heightOfOneHour;
  final int firstHour;
  final int lastHour;
  final double maxWidthNumber;

  BackgroundPainter(
      {required this.firstHour,
      required this.lastHour,
      required this.heightOfOneHour,
      required this.maxWidthNumber});

  TextPainter _genText(String txt) {
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 20,
    );
    final textSpan = TextSpan(
      text: txt,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: maxWidthNumber,
    );
    return textPainter;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.strokeWidth = 1;

    for (int i = 0; i < lastHour - firstHour; i++) {
      canvas.drawLine(Offset(0, heightOfOneHour * i),
          Offset(size.width, heightOfOneHour * i), paint);

      _genText("${firstHour + i}")
          .paint(canvas, Offset(0, heightOfOneHour * i));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
