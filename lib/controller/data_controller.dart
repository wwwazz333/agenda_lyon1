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
import '../model/settingsapp.dart';
import 'event_controller.dart';

class DataController {
  Calendrier calendrier = Calendrier([]);
  Map<String, void Function(List<int>)> updateListeners = {};

  static DataController? _instance;

  DataController._();

  factory DataController() {
    _instance ??= DataController._();
    return _instance!;
  }
  void informeUpdate(List<int> nbrChange) {
    log("Task: informeUpdate size = ${updateListeners.length} for $hashCode");
    updateListeners.forEach((key, fun) {
      fun(nbrChange);
    });
  }

  Future<void> update() async {
    log("start update");
    final url = await DataReader.getString("urlCalendar", "");
    log("url = $url");
    final resUpdate =
        await compute(updateCalendrier, {"url": url, "oldCal": calendrier});
    if (resUpdate.isNotEmpty) {
      log("start writing in file");
      calendrier = resUpdate["newCal"];
      FileManager.writeObject(
          FileManager.calendrierFile, jsonEncode(calendrier));

      List<Changement> changes = resUpdate["changes"];
      List<int> changeIds = [];
      if (changes.isNotEmpty) {
        changeIds = [0, 0];
        String where = "";
        List<Object?> whereArgs = [];
        for (Changement change in changes) {
          where +=
              "(name = ? and oldDate = ? and newDate = ? and typeChange = ?) or ";
          whereArgs.addAll([
            change.name,
            change.oldDate?.millisecondsSinceEpoch ?? 0,
            change.newDate?.millisecondsSinceEpoch ?? 0,
            change.changementType.toString()
          ]);
          DBManager.insertInto("History", {
            "name": change.name,
            "oldDate": change.oldDate?.millisecondsSinceEpoch ?? 0,
            "newDate": change.newDate?.millisecondsSinceEpoch ?? 0,
            "typeChange": change.changementType.toString()
          });
        }

        where = where.substring(0, where.length - 3);

        changeIds[1] = (await DBManager.getMaxId()) as int;
        changeIds[0] = changeIds[1] - changes.length;
      }
      SettingsApp().changeIds = changeIds;
      informeUpdate(changeIds);

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

  void addListenerUpdate(String uniquKey, void Function(List<int>) fun) {
    updateListeners[uniquKey] = fun;
    log("Task: ajout listener size = ${updateListeners.length} for $hashCode");
  }
}
