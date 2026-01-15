import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tasky/core/theme/theme_controller.dart';

class AchievedTasksWidget extends StatelessWidget {
  const AchievedTasksWidget({
    super.key,
    required this.totalTasks,
    required this.totalDoneTask,
    required this.percent,
  });

  final int totalTasks;
  final int totalDoneTask;
  final double percent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      width: double.infinity,
      height: 85,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Achieved Tasks",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  "$totalDoneTask Out of $totalTasks Done",
                  style: Theme.of(context).textTheme.titleSmall,
                  /*TextStyle(
                    color: Color(0xFFC6C6C6),
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),*/
                ),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Transform.rotate(
                angle: -pi / 2,
                child: SizedBox(
                  width: 55,
                  height: 55,
                  child: CircularProgressIndicator(
                    //padding: EdgeInsets.all(16.0),
                    value: percent,
                    backgroundColor: ThemeController.isDark()
                        ? Color(0xFF6D6D6D)
                        : Color(0xFF9E9E9E),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF15B86C),
                    ),
                    strokeWidth: 4,
                  ),
                ),
              ),
              Text(
                "${(percent * 100).toInt()}%",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
