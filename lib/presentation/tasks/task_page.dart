import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/task_filter.dart';
import '../quote/quote_card.dart';
import 'task_cubit.dart';
import 'task_state.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    context.read<TaskCubit>().add(_controller.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Tracker')),
      body: Column(
        children: [
          const QuoteCard(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('task-input'),
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Thêm việc cần làm...',
                    ),
                    onSubmitted: (_) => _submit(),
                  ),
                ),
                IconButton(
                  key: const Key('add-button'),
                  icon: const Icon(Icons.add),
                  onPressed: _submit,
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<TaskCubit, TaskState>(
              builder: (context, state) {
                final cubit = context.read<TaskCubit>();
                return Column(
                  children: [
                    const SizedBox(height: 8),
                    SegmentedButton<TaskFilter>(
                      segments: [
                        for (final f in TaskFilter.values)
                          ButtonSegment(value: f, label: Text(f.label)),
                      ],
                      selected: {state.filter},
                      onSelectionChanged: (s) => cubit.setFilter(s.first),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(state.summary, key: const Key('summary')),
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          for (final task in state.visibleTasks)
                            ListTile(
                              key: ValueKey(task.id),
                              leading: Checkbox(
                                value: task.isDone,
                                onChanged: (_) => cubit.toggle(task.id),
                              ),
                              title: Text(
                                task.title,
                                style: TextStyle(
                                  decoration: task.isDone
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline),
                                tooltip: 'Xóa',
                                onPressed: () => cubit.delete(task.id),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
