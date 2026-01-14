import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/core/widgets/custom_text_form_field.dart';
import 'package:tasky/model/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  TextEditingController taskNameController = TextEditingController();

  TextEditingController taskDescriptionController = TextEditingController();

  bool isHighPriority = true;

  @override
  /*void dispose() {
    taskNameController.dispose();
    taskDescriptionController.dispose();
    super.dispose();
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text("New Task"),
        centerTitle: false,
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: ElevatedButton.icon(
          onPressed: () async {
            if (_key.currentState?.validate() ?? false) {
              final taskJson = PreferencesManager().getString('tasks');
              List<dynamic> listTasks = [];
              if (taskJson != null) {
                listTasks = jsonDecode(taskJson);
              }
              TaskModel taskModel = TaskModel(
                id: listTasks.length + 1,
                taskName: taskNameController.text,
                taskDescription: taskDescriptionController.text,
                isHighPriority: isHighPriority,
              );

              listTasks.add(taskModel.toJson());
              final taskEncode = jsonEncode(listTasks);
              await PreferencesManager().setString('tasks', taskEncode);
              //await pref.setString("tasks", taskEncode);
              Navigator.pop(context, true);
              //Navigator.of(context).pop();
            }
          },
          style: ElevatedButton.styleFrom(
            fixedSize: Size(MediaQuery.of(context).size.width, 40),
          ),
          icon: Icon(Icons.add),
          label: Text("Add Task"),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: Form(
            key: _key,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextFormField(
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
                        style: Theme.of(context).textTheme.titleMedium,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
