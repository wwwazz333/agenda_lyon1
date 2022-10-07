import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'card_event.dart';

class _CardEventTimeLine extends State<CardEventTimeLine> {
  @override
  Widget build(BuildContext context) {
    final widthCard = MediaQuery.of(context).size.width - widget.maxWidthNumber;
    const boxH = BoxConstraints(minHeight: 60);
    return Positioned(
      top: widget.controller.getPositionY(
          startHour: widget.startHour, oneHourH: widget.oneHoureH),
      left: widget.maxWidthNumber +
          widthCard / widget.nbrOverlap * widget.placeForOverlape,
      child: GestureDetector(
        onTap: () => widget.controller.onTap(context).then((value) => setState(
              () {},
            )),
        child: SizedBox(
            width: widthCard / widget.nbrOverlap,
            height: widget.controller.getHeight(oneHourH: widget.oneHoureH),
            child: Stack(
              children: [
                Card(
                  color: widget.bgColor(),
                  child: Container(
                    constraints: boxH,
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: AutoSizeText(
                                    widget.debut,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(color: widget.fontColor),
                                  ),
                                ),
                                AutoSizeText(
                                  widget.fin,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(color: widget.fontColor),
                                )
                              ],
                            ),
                            Expanded(
                                child: Column(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: AutoSizeText(
                                      widget.title,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(color: widget.fontColor),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: AutoSizeText(
                                    widget.subTitle,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(color: widget.fontColor),
                                  ),
                                )
                              ],
                            ))
                          ],
                        )),
                  ),
                ),
                (widget.nbrTask() != 0)
                    ? Positioned(
                        top: 0,
                        right: 5,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle),
                          child: Text(
                            widget.nbrTask().toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: widget.fontColor),
                          ),
                        ))
                    : const SizedBox(),
              ],
            )),
      ),
    );
  }
}

class CardEventTimeLine extends CardEvent {
  final int nbrOverlap;
  final int placeForOverlape;
  final double oneHoureH;
  final int startHour;
  final double maxWidthNumber;
  const CardEventTimeLine(
      {required super.title,
      required super.subTitle,
      required super.debut,
      required super.fin,
      required super.controller,
      required super.nbrTask,
      required this.oneHoureH,
      required super.bgColor,
      this.nbrOverlap = 1,
      this.placeForOverlape = 0,
      this.startHour = 5,
      this.maxWidthNumber = 30,
      super.key});

  @override
  State<StatefulWidget> createState() {
    return _CardEventTimeLine();
  }
}
