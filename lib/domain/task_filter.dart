import 'task.dart';

enum TaskFilter {
  all('Tất cả'),
  active('Đang làm'),
  done('Đã xong');

  const TaskFilter(this.label);

  final String label;

  bool matches(Task task) => switch (this) {
    TaskFilter.all => true,
    TaskFilter.active => !task.isDone,
    TaskFilter.done => task.isDone,
  };
}
