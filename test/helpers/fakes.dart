import 'package:mocktail/mocktail.dart';
import 'package:task_tracker/domain/quote_repository.dart';
import 'package:task_tracker/domain/task.dart';
import 'package:task_tracker/domain/task_repository.dart';

class MockQuoteRepository extends Mock implements QuoteRepository {}

class MockTaskRepository extends Mock implements TaskRepository {}

/// Repository chạy hoàn toàn trong bộ nhớ, dùng cho widget test.
class InMemoryTaskRepository implements TaskRepository {
  InMemoryTaskRepository([List<Task> initial = const []])
    : saved = List.of(initial);

  List<Task> saved;

  @override
  Future<List<Task>> loadTasks() async => List.of(saved);

  @override
  Future<void> saveTasks(List<Task> tasks) async => saved = List.of(tasks);
}
