import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky/model/task_model.dart';

import '../../core/constans/storage_key.dart';
import '../../core/services/preferences_manager.dart';

class HomeController with ChangeNotifier {
  List<TaskModel> taskList = [];
  String? username = "Default";
  String? userImagePath;
  List<TaskModel> tasks = [];
  bool isLoading = false;
  int totalTasks = 0;
  int totalDoneTask = 0;
  double percent = 0;
  late final Function onEdit;

  HomeController() {
    init();
  }

  void init() {
    loadUserName();
    loadTask();
    calculatePercent();
  }

  void loadUserName() async {
    username = PreferencesManager().getString(StorageKey.username);
    userImagePath = PreferencesManager().getString(StorageKey.userImage);
    notifyListeners();
  }

  void loadTask() async {
    isLoading = true;
    final finalTask = PreferencesManager().getString(StorageKey.tasks);
    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;
      tasks = taskAfterDecode
          .map((element) => TaskModel.fromJson(element))
          .toList();
      calculatePercent();
    }
    isLoading = false;
    notifyListeners();
  }

  calculatePercent() {
    totalTasks = tasks.length;
    totalDoneTask = tasks.where((e) => e.isDone).length;
    percent = totalTasks == 0 ? 0 : totalDoneTask / totalTasks;
    notifyListeners();
  }

  doneTask(bool? value, int? index) async {
    tasks[index!].isDone = value ?? false;
    calculatePercent();
    final updatedTask = tasks.map((element) => element.toJson()).toList();
    PreferencesManager().setString(StorageKey.tasks, jsonEncode(updatedTask));
    notifyListeners();
  }

  deleteTask(int? id) async {
    if (id == null) return;
    tasks.removeWhere((tasks) => tasks.id == id);
    calculatePercent();
    final updatedTask = tasks.map((element) => element.toJson()).toList();
    PreferencesManager().setString(StorageKey.tasks, jsonEncode(updatedTask));
    notifyListeners();
  }
}
