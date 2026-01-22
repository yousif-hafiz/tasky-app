import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky/core/constans/storage_key.dart';

import 'package:tasky/core/services/preferences_manager.dart';
import '../../model/task_model.dart';
import '../../core/components/task_list_widget.dart';

class CompleteTasksScreen extends StatefulWidget {
  const CompleteTasksScreen({super.key});

  @override
  State<CompleteTasksScreen> createState() => _CompleteTasksScreenState();
}

class _CompleteTasksScreenState extends State<CompleteTasksScreen> {
  List<TaskModel> completeTasks = [];
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
          completeTasks = taskAfterDecode
              .map((element) => TaskModel.fromJson(element))
              .where((element) => element.isDone == true)
              .toList();
          //tasks = tasks.where((element) => element.isDone == false).toList();
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
    }
    setState(() {
      completeTasks.removeWhere((tasks) => tasks.id == id);
    });
    final updatedTask = completeTasks
        .map((element) => element.toJson())
        .toList();
    PreferencesManager().setString(StorageKey.tasks, jsonEncode(updatedTask));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Completed Tasks", style: Theme.of(context).textTheme.labelSmall),
        Expanded(
          child: Padding(
            padding: EdgeInsetsGeometry.all(16),
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      value: 20,
                    ),
                  )
                : TaskListWidget(
                    tasks: completeTasks,
                    onTap: (bool? value, int? index) async {
                      setState(() {
                        completeTasks[index!].isDone = value ?? false;
                      });

                      final allData = PreferencesManager().getString(StorageKey.tasks);

                      if (allData != null) {
                        List<TaskModel> allDataList =
                            (jsonDecode(allData) as List)
                                .map((element) => TaskModel.fromJson(element))
                                .toList();
                        final newIndex = allDataList.indexWhere(
                          (e) => e.id == completeTasks[index!].id,
                        );
                        allDataList[newIndex] = completeTasks[index!];
                        await PreferencesManager().setString(
                          'tasks',
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
        ),
      ],
    );
  }
}
