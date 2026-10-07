import 'package:equatable/equatable.dart';

import '../../domain/task.dart';
import '../../domain/task_filter.dart';

class TaskState extends Equatable {
  const TaskState({this.tasks = const [], this.filter = TaskFilter.all});

  final List<Task> tasks;
  final TaskFilter filter;

  List<Task> get visibleTasks => tasks.where(filter.matches).toList();

  int get doneCount => tasks.where((t) => t.isDone).length;

  String get summary => '$doneCount/${tasks.length} đã xong';

  TaskState copyWith({List<Task>? tasks, TaskFilter? filter}) =>
      TaskState(tasks: tasks ?? this.tasks, filter: filter ?? this.filter);

  @override
  List<Object?> get props => [tasks, filter];
}
