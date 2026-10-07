import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_tracker/app.dart';
import 'package:task_tracker/domain/quote.dart';
import 'package:task_tracker/domain/task.dart';

import '../helpers/fakes.dart';

void main() {
  late MockQuoteRepository quoteRepository;

  setUp(() {
    quoteRepository = MockQuoteRepository();
    when(() => quoteRepository.fetchQuoteOfTheDay()).thenAnswer(
      (_) async => const Quote(content: 'Stay hungry', author: 'Steve Jobs'),
    );
  });

  Future<InMemoryTaskRepository> pumpApp(
    WidgetTester tester, [
    List<Task> initial = const [],
  ]) async {
    final taskRepository = InMemoryTaskRepository(initial);
    await tester.pumpWidget(
      TaskTrackerApp(
        taskRepository: taskRepository,
        quoteRepository: quoteRepository,
      ),
    );
    await tester.pumpAndSettle();
    return taskRepository;
  }

  testWidgets('thêm task mới hiển thị trong danh sách và được lưu', (
    tester,
  ) async {
    final repo = await pumpApp(tester);

    await tester.enterText(
      find.byKey(const Key('task-input')),
      'Mua cà phê sữa đá',
    );
    await tester.tap(find.byKey(const Key('add-button')));
    await tester.pumpAndSettle();

    expect(find.text('Mua cà phê sữa đá'), findsOneWidget);
    expect(find.text('0/1 đã xong'), findsOneWidget);
    expect(repo.saved.single.title, 'Mua cà phê sữa đá');
  });

  testWidgets('đánh dấu hoàn thành và lọc "Đang làm" ẩn task đó', (
    tester,
  ) async {
    await pumpApp(tester, const [Task(id: '1', title: 'Mua cà phê sữa đá')]);

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    expect(find.text('1/1 đã xong'), findsOneWidget);

    await tester.tap(find.text('Đang làm'));
    await tester.pumpAndSettle();
    expect(find.text('Mua cà phê sữa đá'), findsNothing);
  });

  testWidgets('hiển thị câu trích dẫn trong ngày', (tester) async {
    await pumpApp(tester);

    expect(find.text('— Steve Jobs'), findsOneWidget);
  });
}
