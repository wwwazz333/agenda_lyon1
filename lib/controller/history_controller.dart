import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

import '../data/db_manager.dart';

class HistoryController {
  late final AnimationController _controllerAnimation;
  AnimationController get controllerAnimation => _controllerAnimation;
  late Future<List<Map<String, dynamic>>> loadingDBHistory;

  HistoryController(TickerProvider tickerProvider) {
    loadingDBHistory = DBManager.readDB("History");
    _controllerAnimation = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: tickerProvider,
    );
  }

  void clearHistory() {
    DBManager.removeWhere("History", "1 = ?", [1]).then(
      (value) {
        loadingDBHistory = DBManager.readDB("History");
        _controllerAnimation.reset();
        _controllerAnimation.forward();
      },
    );
  }
}
