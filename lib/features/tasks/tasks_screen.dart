import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky/core/services/preferences_manager.dart';

import '../../model/task_model.dart';
import '../../core/components/task_list_widget.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<TaskModel> todoTasks = [];
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
      final finalTask = PreferencesManager().getString("tasks");
      if (finalTask != null) {
        final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;
        setState(() {
          todoTasks = taskAfterDecode
              .map((element) => TaskModel.fromJson(element))
              .where((element) => element.isDone == false)
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
    if (id == null) return;
    setState(() {
      todoTasks.removeWhere((tasks) => tasks.id == id);
    });
    final updatedTask = todoTasks.map((element) => element.toJson()).toList();
    PreferencesManager().setString("tasks", jsonEncode(updatedTask));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "To Do Tasks",
          style: Theme.of(context).textTheme.labelSmall,
          /*TextStyle(
            color: Color(0xFFFFFCFC),
            fontWeight: FontWeight.w400,
            fontSize: 20,
          ),*/
        ),
        SizedBox(height: 18),
        Expanded(
          child: isLoading
              ? Center(child: CircularProgressIndicator(color: Colors.white))
              : TaskListWidget(
                  tasks: todoTasks,
                  onTap: (bool? value, int? index) async {
                    setState(() {
                      todoTasks[index!].isDone = value ?? false;
                    });
                    final allData = PreferencesManager().getString("tasks");
                    if (allData != null) {
                      List<TaskModel> allDataList =
                          (jsonDecode(allData) as List)
                              .map((element) => TaskModel.fromJson(element))
                              .toList();
                      final newIndex = allDataList.indexWhere(
                        (e) => e.id == todoTasks[index!].id,
                      );
                      allDataList[newIndex] = todoTasks[index!];
                      PreferencesManager().setString(
                        "tasks",
                        jsonEncode(allDataList),
                      );
                      _loadTask();
                    }
                  },
                  emptyMessage: 'No Task Found',
                  onDelete: (int? id) {
                    _deleteTask(id);
                  },
                  onEdit: () => _loadTask(),
                ),
        ),
      ],
    );
  }
}
