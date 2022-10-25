import 'dart:developer';

import 'package:agenda_lyon1/data/stockage.dart';
import 'package:agenda_lyon1/network/file_downolader.dart';
import 'package:flutter/foundation.dart';

import '../model/calendrier/calendrier.dart';
import '../model/changements/changement.dart';
import '../model/settings/settingsapp.dart';
import 'event_controller.dart';

class DataController {
  Calendrier _calendrier = Calendrier([]);
  Calendrier get calendrier => _calendrier;

  set calendrier(Calendrier newCal) {
    _calendrier = newCal;
    Stockage().calendrierBox.put("default", _calendrier);
  }

  Map<String, void Function()> updateListeners = {};

  static DataController? _instance;

  DataController._();

  factory DataController() {
    _instance ??= DataController._();
    return _instance!;
  }
  void informeUpdate() {
    log("Task: informeUpdate size = ${updateListeners.length} for $hashCode");
    updateListeners.forEach((key, fun) {
      fun();
    });
  }

  Future<void> update() async {
    log("start update");
    final url = SettingsApp().urlCalendar;
    log("url = $url");
    final resUpdate =
        await compute(updateCalendrier, {"url": url, "oldCal": calendrier});
    if (resUpdate.isNotEmpty) {
      log("start writing in file");
      calendrier = resUpdate["newCal"];

      Stockage()
          .changementsBox
          .addAll(resUpdate["changes"] as List<Changement>);
    }
    informeUpdate();

    log("end writing in file");
  }

  @pragma('vm:entry-point')
  static Future<Map<String, dynamic>> updateCalendrier(
      Map<String, dynamic> data) async {
    try {
      log("downloading....");
      String content = await FileDownloader.downloadFile(data["url"]);
      log("end download");
      final newCal = Calendrier([])..loadFromString(content);
      final changes = (data["oldCal"] as Calendrier).getChangementTo(newCal);

      return {"newCal": newCal, "changes": changes};
    } catch (e) {
      log("Error: update Cal error $e");
    }
    return {};
  }

  bool _dataLoaded = false;
  Future<bool> load() async {
    if (!_dataLoaded) {
      await loadCalendrier();
      _dataLoaded = true;
    }
    log("fin load");
    return true;
  }

  Future<bool> loadCalendrier() async {
    final Calendrier? temp = Stockage().calendrierBox.get("default");
    bool res = temp != null;
    calendrier = temp ?? Calendrier([]);

    return res;
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
    Stockage().calendrierBox.clear();
  }

  void addListenerUpdate(String uniquKey, void Function() fun) {
    updateListeners[uniquKey] = fun;
    log("Task: ajout listener size = ${updateListeners.length} for $hashCode");
  }
}
