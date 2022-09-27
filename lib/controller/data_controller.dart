import 'dart:convert';

import 'package:agenda_lyon1/data/file_manager.dart';
import 'package:agenda_lyon1/data/shared_pref.dart';
import 'package:agenda_lyon1/network/file_downolader.dart';

import '../model/calendrier.dart';
import 'event_controller.dart';

class DataController {
  Calendrier calendrier = Calendrier([]);
  List<void Function()> updateListeners = [];

  static DataController? _instance;

  DataController._() {
    loadCalendrier();
    DataReader.getString("urlCalendar", "").then(
      (value) => updateCalendrier(value),
    );
  }

  factory DataController() {
    _instance ??= DataController._();
    return _instance!;
  }
  void informeUpdate() {
    for (var fun in updateListeners) {
      fun();
    }
  }

  void updateCalendrier(String urlPath) async {
    try {
      String content = await FileDownloader.downloadFile(urlPath);
      calendrier = Calendrier.load(content);

      FileManager.writeObject(
          FileManager.calendrierFile, jsonEncode(calendrier));
      informeUpdate();
    } catch (_) {}
  }

  void loadCalendrier() async {
    final String? jsonCal =
        await FileManager.readObject(FileManager.calendrierFile);
    if (jsonCal != null) {
      calendrier = Calendrier.fromJson(jsonDecode(jsonCal));
      informeUpdate();
    }
  }

  DayController genDayController(DateTime date) {
    return DayController(calendrier.getEventsOfDay(date));
  }

  DateTime genDateIndex(int index) {
    return (calendrier.listDays.length > index)
        ? calendrier.listDays[index]
        : (calendrier.listDays.isNotEmpty)
            ? calendrier.listDays.last.add(const Duration(days: 1))
            : DateTime.now();
  }

  List<String> get listTab {
    List<String> tabs = [];
    for (var day in calendrier.listDays) {
      tabs.add(day.toString());
    }
    return tabs;
  }

  void addListenerUpdate(void Function() fun) {
    if (!updateListeners.contains(fun)) {
      updateListeners.add(fun);
    }
  }
}
