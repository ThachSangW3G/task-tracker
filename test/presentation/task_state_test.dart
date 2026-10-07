import 'package:flutter_test/flutter_test.dart';
import 'package:task_tracker/domain/task.dart';
import 'package:task_tracker/presentation/tasks/task_state.dart';

// 👉 BÀI TẬP: đây là test "dễ làm hỏng". Đổi '1/2 đã xong' thành '2/2 đã xong'
// rồi push lên một branch mới + mở PR để xem CI báo đỏ.
void main() {
  test('summary đếm số task đã xong', () {
    const state = TaskState(
      tasks: [
        Task(id: '1', title: 'Mua cà phê sữa đá', isDone: true),
        Task(id: '2', title: 'Tập thể dục'),
      ],
    );

    expect(state.summary, '1/2 đã xong');
  });
}
