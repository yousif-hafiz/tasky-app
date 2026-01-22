import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/constans/storage_key.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/core/theme/theme_controller.dart';
import 'package:tasky/core/widgets/custom_svg_picture.dart';
import 'package:tasky/features/home/home_controller.dart';
import 'package:tasky/model/task_model.dart';
import 'package:tasky/features/add_task/add_task_screen.dart';

import '../../core/components/task_list_widget.dart';
import 'components/achieved_tasks.dart';
import 'components/high_priority_tasks_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF181818), // خلفية الشريط العلوي سوداء
        statusBarIconBrightness: Brightness.light, // الأيقونات بيضاء ✨
      ),
    );
    return ChangeNotifierProvider<HomeController>(
      create: (BuildContext context) => HomeController()..init(),
      child: Consumer(
        builder: (BuildContext context, HomeController value, Widget? child) {
          final HomeController controller = context.read<HomeController>();
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
                    value.loadTask(); // 🔄 إعادة تحميل البيانات وتحديث ال UI
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
                            backgroundImage: value.userImagePath == null
                                ? AssetImage("assets/images/joe.jpg")
                                : FileImage(File(value.userImagePath!)),
                            radius: 28,
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Good Evening ,${value.username} ",
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
                            totalTasks: value.totalTasks,
                            totalDoneTask: value.totalDoneTask,
                            percent: value.percent,
                          ),
                          SizedBox(height: 8),
                          HighPriorityTasksWidget(
                            tasks: value.tasks,
                            onTap: (bool? value, int? index) {
                              controller.doneTask(value, index);
                            },
                            refresh: () {
                              controller.loadTask();
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
                      value.isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                //value: 1.0,
                              ),
                            )
                          : TaskListWidget(
                              tasks: value.tasks,
                              onTap: (bool? value, int? index) {
                                controller.doneTask(value, index);
                              },
                              onDelete: (int? id) {
                                controller.deleteTask(id);
                              },
                              onEdit: () => controller.loadTask(),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
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
