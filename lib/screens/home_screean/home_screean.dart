import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/core/theme/theme_controller.dart';
import 'package:tasky/core/widgets/custom_svg_picture.dart';
import 'package:tasky/model/task_model.dart';
import 'package:tasky/screens/add_task_screen/add_task_screen.dart';

import '../../widgets/achieved_tasks.dart';
import '../../widgets/high_priority_tasks_widget.dart';
import '../../widgets/task_list_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? username = "Default";
  String? userImagePath;
  List<TaskModel> tasks = [];
  bool isLoading = false;
  int totalTasks = 0;
  int totalDoneTask = 0;
  double percent = 0;
  late final Function onEdit;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadTask();
    _calculatePercent();
  }

  void _loadUserName() async {
    setState(
      () {
        username = PreferencesManager().getString('username');
        userImagePath = PreferencesManager().getString('user_image');
      },
    ); // ما ينفع تخلي الدالة داخل setState تكون async ولا تخلي setState نفسها async.
    /* لماذا لا يجوز أن تكون setState async ؟

                    لأن:

                    setState لازم تنفّذ فورًا وبسرعة

                    وهي مسؤولة عن إعادة بناء الواجهة

                    ولو كانت async ستُرجع Future وليس void

                    وهذا يخالف تصميم Flutter

                    كما أن Flutter وثّق ذلك صراحة:

                    لا تجعل callback الخاص بـ setState async */
  }

  void _loadTask() async {
    setState(() => isLoading = true);
    try {
      final finalTask = PreferencesManager().getString("tasks");
      if (finalTask != null) {
        final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;
        setState(() {
          tasks = taskAfterDecode
              .map((element) => TaskModel.fromJson(element))
              .toList();
          _calculatePercent();
        });
      }
    } finally {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }

    /*setState(() {
                      isLoading = false;
                    });*/
  }

  _calculatePercent() {
    totalTasks = tasks.length;
    totalDoneTask = tasks.where((e) => e.isDone).length;
    percent = totalTasks == 0 ? 0 : totalDoneTask / totalTasks;
  }

  _doneTask(bool? value, int? index) async {
    setState(() {
      tasks[index!].isDone = value ?? false;
      _calculatePercent();
    });
    final updatedTask = tasks.map((element) => element.toJson()).toList();
    PreferencesManager().setString("tasks", jsonEncode(updatedTask));
  }

  _deleteTask(int? id) async {
    if (id == null) return;
    setState(() {
      tasks.removeWhere((tasks) => tasks.id == id);
      _calculatePercent();
    });
    final updatedTask = tasks.map((element) => element.toJson()).toList();
    PreferencesManager().setString("tasks", jsonEncode(updatedTask));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF181818), // خلفية الشريط العلوي سوداء
        statusBarIconBrightness: Brightness.light, // الأيقونات بيضاء ✨
      ),
    );
    return Scaffold(
      floatingActionButton: SizedBox(
        width: 170,
        height: 45,
        child: FloatingActionButton.extended(
          onPressed: () async {
            //print("task number = ${task.length}");
            final bool? result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => AddTaskScreen(),
              ),
            );
            if (result != null && result) {
              // result == true
              // إذا تم إضافة تاسك جديد (result == true) نعيد تحميل التاسكات
              _loadTask(); // 🔄 إعادة تحميل البيانات وتحديث ال UI
            }
          },
          backgroundColor: Color(0xFF15B86C),
          foregroundColor: ThemeController.isDark()
              ? Color(0xFFFFFCFC)
              : Color(0xFFFFFFFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(100),
          ),
          label: Text("Add New Task"),
          icon: Icon(
            Icons.add,
            color: ThemeController.isDark()
                ? Color(0xFFFFFCFC)
                : Color(0xFFFFFFFF),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: userImagePath == null
                          ? AssetImage("assets/images/joe.jpg")
                          : FileImage(File(userImagePath!)),
                      radius: 28,
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Good Evening ,$username ",
                          style: Theme.of(context).textTheme.titleMedium,
                          /*TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            color: Color(0xFFFFFCFC),
                                          ),*/
                        ),
                        Text(
                          "One task at a time.One step closer.",
                          style: Theme.of(context).textTheme.titleSmall,
                          /*TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: Color(0xFFC6C6C6),
                                          ),*/
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Yuhuu ,Your work Is ",
                      style: Theme.of(context).textTheme.displayLarge,
                      /*TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 32,
                                        color: Color(0xFFFFFCFC),
                                        wordSpacing: 0.5,
                                      ),*/
                    ),
                    Row(
                      children: [
                        Text(
                          "almost done ! ",
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        SizedBox(
                          width: 32,
                          //height: 32,
                          child: CustomSvgPicture.withoutColor(
                            path: "assets/images/waving-hand.svg",
                            width: 32,
                            height: 32,
                          ),
                          /*SvgPicture.asset(
                                            "assets/images/waving-hand.svg",
                                          ),*/
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    AchievedTasksWidget(
                      totalTasks: totalTasks,
                      totalDoneTask: totalDoneTask,
                      percent: percent,
                    ),
                    SizedBox(height: 8),
                    HighPriorityTasksWidget(
                      tasks: tasks,
                      onTap: (bool? value, int? index) {
                        _doneTask(value, index);
                      },
                      refresh: () {
                        _loadTask();
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 16),
                      child: Text(
                        "My Tasks",
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ],
                ),
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          //value: 1.0,
                        ),
                      )
                    : TaskListWidget(
                        tasks: tasks,
                        onTap: (bool? value, int? index) {
                          _doneTask(value, index);
                        },
                        onDelete: (int? id) {
                          _deleteTask(id);
                        },
                        onEdit: () => _loadTask(),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/*SingleChildScrollView(
                        //padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage("assets/images/joe.jpg"),
                                  radius: 28,
                                ),
                                SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Good Evening ,$name ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        color: Color(0xFFFFFCFC),
                                      ),
                                    ),
                                    Text(
                                      "One task at a time.One step\ncloser.",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Color(0xFFC6C6C6),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 16),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Yuhuu ,Your work Is ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 32,
                                    color: Color(0xFFFFFCFC),
                                    wordSpacing: 0.5,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "almost done ! ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 32,
                                        color: Color(0xFFFFFCFC),
                                        wordSpacing: 0.5,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 32,
                                      //height: 32,
                                      child: SvgPicture.asset("assets/images/waving-hand.svg"),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),

                                AchievedTasks(
                                  totalTasks: totalTasks,
                                  totalDoneTask: totalDoneTask,
                                  percent: percent,
                                ),
                                SizedBox(height: 8),
                                HighPriorityTasksWidget(
                                  tasks: tasks,
                                  onTap: (bool? value, int? index) {
                                    _doneTask(value, index);
                                  },
                                  refresh: () {
                                    _loadTask();
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 24, bottom: 16),
                                  child: Text(
                                    "My Tasks",
                                    style: TextStyle(
                                      color: Color(0xFFFFFCFC),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            isLoading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      value: 20,
                                    ),
                                  )
                                : TaskListWidget(
                                    tasks: tasks,
                                    onTap: (bool? value, int? index) {
                                      _doneTask(value, index);
                                    },
                                  ),
                          ],
                        ),
                      ),*/
