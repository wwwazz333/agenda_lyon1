import 'package:flutter/material.dart';

import 'card_event.dart';

class _CardEventTile extends State<CardEventTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => widget.controller.onTap(context).then((value) => setState(
              () {},
            )),
        child: Stack(
          children: [
            Card(
              color: widget.bgColor(),
              child: ListTile(
                visualDensity: const VisualDensity(vertical: 4),
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      widget.debut,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      widget.fin,
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  ],
                ),
                title: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.bodyText1,
                  softWrap: true,
                ),
                trailing: Text(
                  widget.subTitle,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
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
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ))
                : const SizedBox(),
          ],
        ));
  }
}

class CardEventTile extends CardEvent {
  const CardEventTile(
      {required super.title,
      required super.subTitle,
      required super.nbrTask,
      required super.debut,
      required super.fin,
      required super.bgColor,
      required super.controller,
      super.key});

  @override
  State<StatefulWidget> createState() {
    return _CardEventTile();
  }
}
