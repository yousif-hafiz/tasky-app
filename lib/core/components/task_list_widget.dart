import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky/core/enums/task_item_actions_enum.dart';
import 'package:tasky/core/theme/theme_controller.dart';
import 'package:tasky/core/widgets/custom_check_box.dart';
import 'package:tasky/core/widgets/custom_text_form_field.dart';

import '../services/preferences_manager.dart';
import '../../model/task_model.dart';

class TaskListWidget extends StatelessWidget {
  const TaskListWidget({
    super.key,
    required this.tasks,
    required this.onTap,
    this.emptyMessage,
    required this.onDelete,
    required this.onEdit,
  });

  final List<TaskModel> tasks;
  final Function(bool?, int?) onTap;
  final Function(int) onDelete;
  final Function onEdit;
  final String? emptyMessage;

  @override
  Widget build(BuildContext context) {
    return tasks.isEmpty
        ? Center(
            child: Text(
              emptyMessage ?? "No Data",
              style: Theme.of(context).textTheme.displayMedium,
            ),
          )
        : ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: 65),
            itemCount: tasks.length,
            itemBuilder: (BuildContext context, int index) => Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                width: double.infinity,
                //MediaQuery.of(context).size.width
                height: 55,
                //alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ThemeController.isLight()
                        ? Color(0xFFD1DAD6)
                        : Colors.transparent,
                  ),
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    CustomCheckBox(
                      value: tasks[index].isDone,
                      onChanged: (bool? value) {
                        onTap(value, index);
                      },
                    ),

                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tasks[index].taskName,
                            style: tasks[index].isDone
                                ? Theme.of(context).textTheme.titleLarge
                                : Theme.of(context).textTheme.titleMedium,
                            /*TextStyle(
                              color: tasks[index].isDone
                                  ? Color(0xFFA0A0A0)
                                  : Color(0xFFFFFCFC),
                              fontSize: 16,
                              letterSpacing: 0.5,
                              decoration: tasks[index].isDone
                                  ? TextDecoration.lineThrough
                                  : null,
                              decorationColor: Color(0xFFA0A0A0),
                              overflow: TextOverflow.ellipsis,
                            ),*/
                            maxLines: 1,
                          ),
                          if (tasks[index].taskDescription.isNotEmpty)
                            Text(
                              tasks[index].taskDescription,
                              style: TextStyle(
                                color: Color(0xFFC6C6C6),
                                fontSize: 14,
                                letterSpacing: 0.25,
                                decoration: tasks[index].isDone
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1,
                            ),
                        ],
                      ),
                    ),
                    PopupMenuButton<TaskItemActionsEnum>(
                      icon: Icon(
                        //size: 24,
                        Icons.more_vert,
                        color: ThemeController.isDark()
                            ? (tasks[index].isDone
                                  ? Color(0xFFA0A0A0)
                                  : Color(0xFFC6C6C6))
                            : (tasks[index].isDone
                                  ? Color(0xFF6A6A6A)
                                  : Color(0xFF3A4640)),
                      ),
                      onSelected: (value) async {
                        switch (value) {
                          case TaskItemActionsEnum.markAsDone:
                            onTap(!tasks[index].isDone, index);
                            /*if (!tasks[index].isDone) {
                              onTap(!tasks[index].isDone, index);
                            } else {
                              onTap(!tasks[index].isDone, index);
                            }*/
                            break;
                          case TaskItemActionsEnum.edit:
                            final result = await _showModelBottomSheet(
                              context,
                              tasks[index],
                            );
                            print(result);
                            if (result == true) {
                              onEdit();
                            }
                            break;
                          case TaskItemActionsEnum.delete:
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  _showAlertDialog(context, index),
                            );
                            break;
                          //onDelete(tasks[index].id);
                        }
                      },
                      itemBuilder: (context) =>
                          TaskItemActionsEnum.values.map((e) {
                            return PopupMenuItem<TaskItemActionsEnum>(
                              value: e,
                              child: Text(
                                e == TaskItemActionsEnum.markAsDone
                                    ? (tasks[index].isDone
                                          ? ("Mark as undone")
                                          : "Mark as done")
                                    : e.name,
                              ),
                            );
                          }).toList(),
                      /*[
                        PopupMenuItem(
                          value: TaskItemActionsEnum.edit,
                          child: Text("Edit"),
                        ),
                        PopupMenuItem(
                          value: TaskItemActionsEnum.delete,
                          child: Text("Delete"),
                        ),
                      ],*/
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  AlertDialog _showAlertDialog(BuildContext context, int index) {
    return AlertDialog(
      title: Center(child: Text("Delete Task")),
      content: Text(
        "Delete 1 Item?",
        style: Theme.of(context).textTheme.titleSmall,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel', style: Theme.of(context).textTheme.labelSmall),
        ),
        TextButton(
          onPressed: () {
            onDelete(tasks[index].id);
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: Text(
            'Delete',
            style: Theme.of(
              context,
            ).textTheme.labelSmall!.copyWith(color: Colors.red),
          ),
        ),
      ],
    );
  }

  Future<bool?> _showModelBottomSheet(BuildContext context, TaskModel model) {
    TextEditingController taskNameController = TextEditingController(
      text: model.taskName,
    );
    TextEditingController taskDescriptionController = TextEditingController(
      text: model.taskDescription,
    );
    GlobalKey<FormState> key = GlobalKey<FormState>();
    bool isHighPriority = model.isHighPriority;
    return showModalBottomSheet<bool>(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setState) {
          return Padding(
            padding: const EdgeInsets.all(16),

            // vertical: 16.0, horizontal: 8.0,
            child: Form(
              key: key,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFormField(
                      fontSize: 14,
                      title: "Task Name",
                      validator: (String? v) {
                        if (v == null || v.trim().isEmpty) {
                          return "please enter your task name";
                        } else {
                          return null;
                        }
                      },
                      controller: taskNameController,
                      hintText: 'Finish UI design for login screen',
                    ),

                    /// heeeeeeeeeeeeeeeeeeeere
                    Column(
                      children: [
                        SizedBox(height: 8),
                        CustomTextFormField(
                          fontSize: 14,
                          title: "Task Description",
                          controller: taskDescriptionController,
                          maxLines: 5,
                          hintText:
                              'Finish onboarding UI and hand off to devs by Thursday.',
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "High Priority",
                          style: Theme.of(context).textTheme.titleSmall!
                              .copyWith(fontWeight: FontWeight.w400),
                          /*TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Color(0xFFFFFCFC),
                            letterSpacing: 0.5,
                          ),*/
                        ),
                        //Spacer(),
                        Switch(
                          value: isHighPriority,
                          onChanged: (bool value) {
                            setState(() {
                              isHighPriority = value;
                            });
                          },
                          //activeColor: Color(0xFFFFFCFC),
                          //activeTrackColor: Color(0xFF15B86C),
                        ),
                      ],
                    ),
                    //Spacer(),
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (key.currentState?.validate() ?? false) {
                          final taskJson = PreferencesManager().getString(
                            'tasks',
                          );
                          List<dynamic> listTasks = [];
                          if (taskJson != null) {
                            listTasks = jsonDecode(taskJson);
                          }
                          TaskModel newModel = TaskModel(
                            id: model.id,
                            taskName: taskNameController.text,
                            taskDescription: taskDescriptionController.text,
                            isHighPriority: isHighPriority,
                            isDone: model.isDone,
                          );
                          //listTasks.add(newModel.toJson());
                          final item = listTasks.firstWhere(
                            (e) => e['id'] == model.id,
                          );
                          final int index = listTasks.indexOf(item);
                          listTasks[index] = newModel;
                          final taskEncode = jsonEncode(listTasks);
                          await PreferencesManager().setString(
                            'tasks',
                            taskEncode,
                          );
                          //await pref.setString("tasks", taskEncode);
                          Navigator.pop(context, true);
                          //Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(MediaQuery.of(context).size.width, 40),
                      ),
                      icon: Icon(Icons.edit),
                      label: Text("Edit Task"),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
