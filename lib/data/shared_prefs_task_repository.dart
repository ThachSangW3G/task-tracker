import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/task.dart';
import '../domain/task_repository.dart';

class SharedPrefsTaskRepository implements TaskRepository {
  SharedPrefsTaskRepository(this._prefs);

  static const storageKey = 'tasks';

  final SharedPreferences _prefs;

  @override
  Future<List<Task>> loadTasks() async {
    final raw = _prefs.getString(storageKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => _fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> saveTasks(List<Task> tasks) async {
    await _prefs.setString(storageKey, jsonEncode(tasks.map(_toJson).toList()));
  }

  static Map<String, dynamic> _toJson(Task task) => {
    'id': task.id,
    'title': task.title,
    'isDone': task.isDone,
  };

  static Task _fromJson(Map<String, dynamic> json) => Task(
    id: json['id'] as String,
    title: json['title'] as String,
    isDone: json['isDone'] as bool? ?? false,
  );
}
