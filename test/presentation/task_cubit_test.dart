import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_tracker/domain/task.dart';
import 'package:task_tracker/domain/task_filter.dart';
import 'package:task_tracker/presentation/tasks/task_cubit.dart';
import 'package:task_tracker/presentation/tasks/task_state.dart';

import '../helpers/fakes.dart';

void main() {
  late MockTaskRepository repository;

  const coffee = Task(id: '1', title: 'Mua cà phê sữa đá');

  setUp(() {
    repository = MockTaskRepository();
    when(() => repository.saveTasks(any())).thenAnswer((_) async {});
  });

  TaskCubit buildCubit() => TaskCubit(repository, idGenerator: () => '1');

  blocTest<TaskCubit, TaskState>(
    'load() phát ra các task đã lưu',
    setUp: () =>
        when(() => repository.loadTasks()).thenAnswer((_) async => [coffee]),
    build: buildCubit,
    act: (cubit) => cubit.load(),
    expect: () => [
      const TaskState(tasks: [coffee]),
    ],
  );

  blocTest<TaskCubit, TaskState>(
    'add() thêm task (đã trim) và lưu xuống repository',
    build: buildCubit,
    act: (cubit) => cubit.add('  Mua cà phê sữa đá  '),
    expect: () => [
      const TaskState(tasks: [coffee]),
    ],
    verify: (_) => verify(() => repository.saveTasks([coffee])).called(1),
  );

  blocTest<TaskCubit, TaskState>(
    'add() bỏ qua tiêu đề rỗng',
    build: buildCubit,
    act: (cubit) => cubit.add('   '),
    expect: () => <TaskState>[],
  );

  blocTest<TaskCubit, TaskState>(
    'toggle() đảo trạng thái hoàn thành',
    build: buildCubit,
    seed: () => const TaskState(tasks: [coffee]),
    act: (cubit) => cubit.toggle('1'),
    expect: () => [
      TaskState(tasks: [coffee.copyWith(isDone: true)]),
    ],
  );

  blocTest<TaskCubit, TaskState>(
    'delete() xóa task',
    build: buildCubit,
    seed: () => const TaskState(tasks: [coffee]),
    act: (cubit) => cubit.delete('1'),
    expect: () => [const TaskState()],
  );

  blocTest<TaskCubit, TaskState>(
    'setFilter() chỉ hiển thị task đang làm',
    build: buildCubit,
    seed: () => const TaskState(
      tasks: [
        coffee,
        Task(id: '2', title: 'Đọc sách', isDone: true),
      ],
    ),
    act: (cubit) => cubit.setFilter(TaskFilter.active),
    verify: (cubit) => expect(cubit.state.visibleTasks, [coffee]),
  );
}
