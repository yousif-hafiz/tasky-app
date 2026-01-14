enum TaskItemActionsEnum {
  markAsDone(name: 'Mark as done'),
  edit(name: 'Edit'),
  delete(name: 'Delete');

  final String name;

  const TaskItemActionsEnum({required this.name});
}
