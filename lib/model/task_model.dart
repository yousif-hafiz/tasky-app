class TaskModel {
  final int id;
  final String taskName;
  final String taskDescription;
  final bool isHighPriority;
  bool isDone;

  TaskModel({

    required this.id,
    required this.taskName,
    required this.taskDescription,
    required this.isHighPriority,
    this.isDone = false,
  });

  factory TaskModel.fromJson(Map<String, dynamic> map) {
    //تحول Map إلى Object من نوع TaskModel يعني: Map → Object
    return TaskModel(
      id: map["id"],
      taskName: map["taskName"],
      taskDescription: map["taskDescription"],
      isHighPriority: map["isHighPriority"],
      isDone: map["isDone"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    // toJson الدالة تحول Object إلى Map  (object => Map)
    return {
      "id": id,
      "taskName": taskName,
      "taskDescription": taskDescription,
      "isHighPriority": isHighPriority,
      "isDone": isDone,
    };
  }
}
