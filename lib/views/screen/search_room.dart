import 'dart:developer';

import 'package:agenda_lyon1/controller/data_controller.dart';
import 'package:agenda_lyon1/model/calendrier/calendrier.dart';
import 'package:agenda_lyon1/model/date.dart';
import 'package:agenda_lyon1/model/settings/settingsapp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../model/settings/settings.dart';
import '../custom_widgets/loading_widget.dart';

import '../../network/file_downolader.dart';

class SearchRoom extends StatefulWidget {
  const SearchRoom({super.key});

  @override
  State<SearchRoom> createState() => _SearchRoomState();
}

class _SearchRoomState extends State<SearchRoom> {
  List<String> _rooms = [];
  List<String> get rooms => _rooms;
  late Calendrier calendrier;
  late Future<String> url;

  set rooms(List<String> newVal) {
    _rooms = newVal;
    _rooms.sort((a, b) => a.compareTo(b));
  }

  @override
  void initState() {
    url = FileDownloader.downloadFile(SettingsApp().urlCalendarRoom);
    try {
      url.then((value) {
        calendrier = Calendrier.load(value);
        rooms = calendrier.getAvaliableRoomsAt(DateTime.now());
      });
    } catch (_) {}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recherche salle")),
      body: FutureBuilder(
        future: url,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            log(snapshot.error.toString());

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                    "Erreur : url des salle incorrecte ou problème de connexion. ${snapshot.error}",
                    textAlign: TextAlign.center),
              ),
            );
          } else if (snapshot.hasData) {
            log("here");
            return Column(
              children: [
                SearchBar((dateTime) {
                  rooms = calendrier.getAvaliableRoomsAt(dateTime);
                  setState(() {});
                }),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: rooms.length,
                    itemBuilder: (context, index) => Text(rooms[index]),
                  ),
                )
              ],
            );
          }
          return const LoadingWidget();
        },
      ),
    );
  }
}

class SearchBar extends ConsumerStatefulWidget {
  final void Function(DateTime dateTime) search;
  const SearchBar(this.search, {super.key});

  @override
  ConsumerState<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends ConsumerState<SearchBar> {
  DateTime dateSelected = DateTime.now();

  void setDateSelected(DateTime dateTime, TimeOfDay timeOfDay) {
    dateSelected = DateTime(dateTime.year, dateTime.month, dateTime.day,
        timeOfDay.hour, timeOfDay.minute);
    widget.search(dateSelected);
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(SettingsProvider.languageAppProvider);
    final monthFormatter = DateFormat.MMMEd(language.languageCode);

    return Container(
      margin: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                    onPressed: () async {
                      DateTime? date = DateTime.now();
                      date = await showDatePicker(
                        locale: language,
                        initialDate: date,
                        firstDate: date,
                        lastDate: date.add(const Duration(days: 365 * 100)),
                        context: context,
                      );
                      if (date != null) {
                        setDateSelected(
                            date, TimeOfDay.fromDateTime(dateSelected));
                        setState(() {});
                      }
                    },
                    child: Text(monthFormatter.format(dateSelected))),
                TextButton(
                    onPressed: () async {
                      final timeOfDay = await showTimePicker(
                          helpText: "Sélectionner une heure",
                          builder: (context, child) => MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(alwaysUse24HourFormat: true),
                                child: child ?? const LoadingWidget(),
                              ),
                          context: context,
                          initialTime: TimeOfDay.now());
                      if (timeOfDay != null) {
                        setDateSelected(dateSelected, timeOfDay);
                        setState(() {});
                      }
                    },
                    child: Text(dateSelected.affichageHeure())),
              ],

              // IconButton(
              //     onPressed: () {
              //       widget.search(dateSelected);
              //     },
              //     icon: const Icon(Icons.search))
            ),
          ),
        ),
      ),
    );
  }
}
