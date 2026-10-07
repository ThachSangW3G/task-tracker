import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'domain/quote_repository.dart';
import 'domain/task_repository.dart';
import 'presentation/quote/quote_cubit.dart';
import 'presentation/tasks/task_cubit.dart';
import 'presentation/tasks/task_page.dart';

class TaskTrackerApp extends StatelessWidget {
  const TaskTrackerApp({
    super.key,
    required this.taskRepository,
    required this.quoteRepository,
  });

  final TaskRepository taskRepository;
  final QuoteRepository quoteRepository;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TaskCubit(taskRepository)..load()),
        BlocProvider(create: (_) => QuoteCubit(quoteRepository)..fetch()),
      ],
      child: MaterialApp(
        title: 'Task Tracker',
        theme: ThemeData(colorSchemeSeed: Colors.teal),
        home: const TaskPage(),
      ),
    );
  }
}
