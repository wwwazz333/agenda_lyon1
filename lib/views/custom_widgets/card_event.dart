import 'package:flutter/material.dart';

import '../../controller/event_controller.dart';

abstract class CardEvent extends StatelessWidget {
  final Color _bgColor;
  final String _title;
  final String _subTitle;
  final String _debut;
  final String _fin;
  final EventController _controller;
  const CardEvent(
      {required title,
      required subTitle,
      required debut,
      required fin,
      required controller,
      bgColor = Colors.blueGrey,
      super.key})
      : _title = title,
        _subTitle = subTitle,
        _debut = debut,
        _fin = fin,
        _bgColor = bgColor,
        _controller = controller;
}

class CardEventTimeLine extends CardEvent {
  final int nbrOverlap;
  final int placeForOverlape;
  final double _oneHoureH;
  final int _startHour;
  final double maxWidthNumber;
  const CardEventTimeLine(
      {super.title,
      super.subTitle,
      super.debut,
      super.fin,
      super.controller,
      required onHoureH,
      super.bgColor,
      this.nbrOverlap = 1,
      this.placeForOverlape = 0,
      startHour = 5,
      this.maxWidthNumber = 30,
      super.key})
      : _startHour = startHour,
        _oneHoureH = onHoureH;

  @override
  Widget build(BuildContext context) {
    final widthCard = MediaQuery.of(context).size.width - maxWidthNumber;
    const boldStyle = TextStyle(fontWeight: FontWeight.bold);
    const boxH = BoxConstraints(minHeight: 60);
    return Positioned(
      top:
          _controller.getPositionY(startHour: _startHour, oneHourH: _oneHoureH),
      left: maxWidthNumber + widthCard / nbrOverlap * placeForOverlape,
      child: GestureDetector(
        onTap: () => _controller.onTap(context),
        child: SizedBox(
          width: widthCard / nbrOverlap,
          height: _controller.getHeight(oneHourH: _oneHoureH),
          child: Card(
            color: _bgColor,
            child: Container(
              constraints: boxH,
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text(_debut), Text(_fin)],
                      ),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Center(
                                child: Text(
                              _title,
                            )),
                          ),
                          Expanded(
                              flex: 1,
                              child: Text(
                                _subTitle,
                                style: boldStyle,
                              ))
                        ],
                      ))
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}

class CardEventList extends CardEvent {
  const CardEventList(
      {super.title,
      super.subTitle,
      super.debut,
      super.fin,
      super.bgColor,
      super.controller,
      super.key});

  @override
  Widget build(BuildContext context) {
    const boldStyle =
        TextStyle(fontWeight: FontWeight.bold, color: Colors.white);
    const white = TextStyle(color: Colors.white);
    const boxH = BoxConstraints(minHeight: 60);
    return GestureDetector(
      onTap: () => _controller.onTap(context),
      child: Card(
        color: _bgColor,
        child: Container(
          constraints: boxH,
          child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    constraints: boxH,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          _debut,
                          style: white,
                        ),
                        Text(
                          _fin,
                          style: white,
                        )
                      ],
                    ),
                  ),
                  Text(
                    _title,
                    style: white,
                  ),
                  Text(
                    _subTitle,
                    style: boldStyle,
                  )
                ],
              )),
        ),
      ),
    );
  }
}
