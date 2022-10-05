import 'dart:convert';
import 'dart:developer';

import 'package:agenda_lyon1/data/db_manager.dart';
import 'package:agenda_lyon1/data/file_manager.dart';
import 'package:agenda_lyon1/data/shared_pref.dart';
import 'package:agenda_lyon1/network/file_downolader.dart';
import 'package:flutter/foundation.dart';

import '../common/colors.dart';
import '../common/tasks.dart';
import '../model/calendrier.dart';
import 'event_controller.dart';

class DataController {
  Calendrier calendrier = Calendrier([]);
  Map<String, void Function()> updateListeners = {};

  static DataController? _instance;

  DataController._() {
    log("Task: hash = $hashCode");
  }

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
    final url = await DataReader.getString("urlCalendar", "");
    log("url = $url");
    final resUpdate =
        await compute(updateCalendrier, {"url": url, "oldCal": calendrier});
    log("end update res = $resUpdate");
    if (resUpdate != {}) {
      log("start writing in file");
      calendrier = resUpdate["newCal"];
      FileManager.writeObject(
          FileManager.calendrierFile, jsonEncode(resUpdate));
      for (Changement change in resUpdate["changes"]) {
        DBManager.insertInto("History", {
          "name": change.name,
          "oldDate": change.oldDate,
          "newDate": change.newDate
        });
      }
      informeUpdate();
      log("end writing in file");
    }
  }

  static Future<Map<String, dynamic>> updateCalendrier(
      Map<String, dynamic> data) async {
    try {
      String content = await FileDownloader.downloadFile(data["url"]);
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
      await Future.wait([
        loadCalendrier(),
        loadColors(),
        loadTasks(),
      ]);
      _dataLoaded = true;
    }
    log("fin load");
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
    log("Task: ajout listener size = ${updateListeners.length} for $hashCode");
  }
}
