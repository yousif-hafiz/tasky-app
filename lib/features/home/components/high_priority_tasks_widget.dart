import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tasky/core/theme/theme_controller.dart';
import 'package:tasky/core/widgets/custom_check_box.dart';
import 'package:tasky/core/widgets/custom_svg_picture.dart';
import 'package:tasky/model/task_model.dart';
import 'package:tasky/features/tasks/high_priority_screen.dart';

class HighPriorityTasksWidget extends StatelessWidget {
  const HighPriorityTasksWidget({
    super.key,
    required this.onTap,
    required this.tasks,
    required this.refresh,
  });

  final List<TaskModel> tasks;
  final Function(bool?, int?) onTap;
  final Function refresh;

  @override
  Widget build(BuildContext context) {
    return Container(
      /*width: double.infinity,
      height: 180,*/
      //padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "High Priority Tasks",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xFF15B86C),
                    ),
                  ),
                ),
                // SizedBox(height: 12),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:
                      tasks.reversed.where((e) => e.isHighPriority).length > 3
                      ? 3
                      : tasks.reversed.where((e) => e.isHighPriority).length,
                  itemBuilder: (BuildContext context, int index) {
                    final highTasks = tasks.reversed
                        .where((e) => e.isHighPriority)
                        .toList()[index];
                    return Row(
                      children: [
                        CustomCheckBox(
                          value: highTasks.isDone,
                          onChanged: (bool? value) {
                            final index = tasks.indexWhere(
                              (e) => e.id == highTasks.id,
                            );
                            onTap(value, index);
                          },
                        ),

                        Flexible(
                          child: Text(
                            highTasks.taskName,
                            style: highTasks.isDone
                                ? Theme.of(context).textTheme.titleLarge
                                : Theme.of(context).textTheme.titleMedium,
                            /*style: TextStyle(
                              color: Color(0xFFC6C6C6), task.isDone ? Color(0xFFA0A0A0) : Color(0xFFFFFCFC)
                              fontSize: 16,
                              letterSpacing: 0.25,
                              decoration: highTasks.isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              overflow: TextOverflow.ellipsis,
                            ),*/
                            maxLines: 1,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => HighPriorityScreen(),
                ),
              );
              refresh();
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: EdgeInsets.all(8),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                  //borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: ThemeController.isDark()
                        ? Color(0xFF6E6E6E)
                        : Color(0xFFD1DAD6),
                    //color: Colors.white.withValues(alpha: 0.6)
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: SizedBox(
                    width: 15,
                    height: 15,
                    child: CustomSvgPicture(
                      path: "assets/images/arrow-up-right.svg",
                      colorFilter: ThemeController.isLight()
                          ? Color(0xFF3A4640)
                          : Color(0xFFC6C6C6),
                      width: 24,
                      height: 24,
                    ),
                    /*SvgPicture.asset(
                      "assets/images/arrow-up-right.svg",
                      colorFilter: ColorFilter.mode(
                        ThemeController.isLight()
                            ? Color(0xFF3A4640)
                            : Color(0xFFC6C6C6),
                        BlendMode.srcIn,
                      ),
                      //alignment: Alignment.center,
                    ),*/
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
