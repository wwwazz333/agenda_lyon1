import 'dart:convert';

import 'package:agenda_lyon1/common/global_data.dart';
import 'package:agenda_lyon1/data/file_manager.dart';
import 'package:agenda_lyon1/data/shared_pref.dart';
import 'package:agenda_lyon1/network/file_downolader.dart';

import '../common/colors.dart';
import '../common/tasks.dart';
import '../model/calendrier.dart';
import 'event_controller.dart';

class DataController {
  Calendrier calendrier = Calendrier([]);
  Map<String, void Function()> updateListeners = {};

  static DataController? _instance;

  DataController._() {
    DataReader.getString("urlCalendar", "").then(
      (value) => updateCalendrier(value),
    );
  }

  factory DataController() {
    _instance ??= DataController._();
    return _instance!;
  }
  void informeUpdate() {
    updateListeners.forEach((key, fun) {
      fun();
    });
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

  Future<bool> load() async {
    //fixme opimze not await for each

    await loadTasks();
    await loadColors();
    await loadCalendrier();

    return true;
  }

  Future<bool> loadCalendrier() async {
    final String? jsonCal =
        await FileManager.readObject(FileManager.calendrierFile);
    if (jsonCal != null) {
      calendrier = Calendrier.fromJson(jsonDecode(jsonCal));
      return true;
    }
    return false;
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

  void clear() {
    calendrier = Calendrier([]);
    FileManager.delFile(FileManager.calendrierFile);
  }

  void addListenerUpdate(String uniquKey, void Function() fun) {
    updateListeners[uniquKey] = fun;
  }
}
