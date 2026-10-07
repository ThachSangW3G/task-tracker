import 'package:equatable/equatable.dart';

class Task extends Equatable {
  const Task({required this.id, required this.title, this.isDone = false});

  final String id;
  final String title;
  final bool isDone;

  Task copyWith({bool? isDone}) =>
      Task(id: id, title: title, isDone: isDone ?? this.isDone);

  @override
  List<Object?> get props => [id, title, isDone];
}
