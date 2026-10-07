import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_tracker/data/shared_prefs_task_repository.dart';
import 'package:task_tracker/domain/task.dart';

void main() {
  late SharedPrefsTaskRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repository = SharedPrefsTaskRepository(
      await SharedPreferences.getInstance(),
    );
  });

  test('trả về danh sách rỗng khi chưa lưu gì', () async {
    expect(await repository.loadTasks(), isEmpty);
  });

  test('lưu rồi đọc lại giữ nguyên tiếng Việt và trạng thái', () async {
    const tasks = [
      Task(id: '1', title: 'Mua cà phê sữa đá'),
      Task(id: '2', title: 'Đọc sách', isDone: true),
    ];

    await repository.saveTasks(tasks);

    expect(await repository.loadTasks(), tasks);
  });
}
