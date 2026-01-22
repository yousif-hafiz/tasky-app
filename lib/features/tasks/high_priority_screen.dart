import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky/core/services/preferences_manager.dart';

import '../../core/constans/storage_key.dart';
import '../../model/task_model.dart';
import '../../core/components/task_list_widget.dart';

class HighPriorityScreen extends StatefulWidget {
  const HighPriorityScreen({super.key});

  @override
  State<HighPriorityScreen> createState() => _HighPriorityScreenState();
}

class _HighPriorityScreenState extends State<HighPriorityScreen> {
  List<TaskModel> highPriorityTasks = [];
  late final Function onEdit;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  void _loadTask() async {
    setState(() => isLoading = true);
    try {
      final finalTask = PreferencesManager().getString(StorageKey.tasks);
      if (finalTask != null) {
        final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;
        setState(() {
          highPriorityTasks = taskAfterDecode
              .map((element) => TaskModel.fromJson(element))
              .where((element) => element.isHighPriority == true)
              .toList()
              .reversed
              .toList();
        });
      }
    } finally {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  _deleteTask(int? id) async {
    List<TaskModel> tasks = [];
    if (id == null) return;
    final finalTask = PreferencesManager().getString(StorageKey.tasks);
    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;
      tasks = taskAfterDecode
          .map((element) => TaskModel.fromJson(element))
          .toList();
      tasks.removeWhere((e) => e.id == id);
      setState(() {
        highPriorityTasks.removeWhere((tasks) => tasks.id == id);
      });
      final updatedTask = tasks.map((element) => element.toJson()).toList();
      PreferencesManager().setString(StorageKey.tasks, jsonEncode(updatedTask));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF181818),
      appBar: AppBar(
        title: Text(
          "High Priority Tasks",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.0,
            color: Color(0xFFFFFCFC),
          ),
        ),
        backgroundColor: Color(0xFF181818),
        iconTheme: IconThemeData(color: Color(0xFFFFFCFC)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator(color: Colors.white))
            : TaskListWidget(
                tasks: highPriorityTasks,
                onTap: (bool? value, int? index) async {
                  setState(() {
                    highPriorityTasks[index!].isDone = value ?? false;
                  });
                  final allData = PreferencesManager().getString(StorageKey.tasks);
                  if (allData != null) {
                    List<TaskModel> allDataList = (jsonDecode(allData) as List)
                        .map((element) => TaskModel.fromJson(element))
                        .toList();
                    final newIndex = allDataList.indexWhere(
                      (e) => e.id == highPriorityTasks[index!].id,
                    );
                    allDataList[newIndex] = highPriorityTasks[index!];
                    await PreferencesManager().setString(
                      StorageKey.tasks,
                      jsonEncode(allDataList),
                    );
                    _loadTask();
                  }
                },
                emptyMessage: 'No Task Found',
                onDelete: (int? id) {
                  _deleteTask(id);
                },
                onEdit: () {
                  _loadTask();
                },
              ),
      ),
    );
  }
}
