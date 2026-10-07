import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/task.dart';
import '../../domain/task_filter.dart';
import '../../domain/task_repository.dart';
import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit(this._repository, {String Function()? idGenerator})
    : _newId = idGenerator ?? _defaultId,
      super(const TaskState());

  final TaskRepository _repository;
  final String Function() _newId;

  static String _defaultId() =>
      DateTime.now().microsecondsSinceEpoch.toString();

  Future<void> load() async {
    emit(state.copyWith(tasks: await _repository.loadTasks()));
  }

  Future<void> add(String title) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return;
    await _update([...state.tasks, Task(id: _newId(), title: trimmed)]);
  }

  Future<void> toggle(String id) => _update([
    for (final t in state.tasks) t.id == id ? t.copyWith(isDone: !t.isDone) : t,
  ]);

  Future<void> delete(String id) =>
      _update(state.tasks.where((t) => t.id != id).toList());

  void setFilter(TaskFilter filter) => emit(state.copyWith(filter: filter));

  Future<void> _update(List<Task> tasks) async {
    emit(state.copyWith(tasks: tasks));
    await _repository.saveTasks(tasks);
  }
}
