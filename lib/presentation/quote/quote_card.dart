import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'quote_cubit.dart';
import 'quote_state.dart';

class QuoteCard extends StatelessWidget {
  const QuoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocBuilder<QuoteCubit, QuoteState>(
          builder: (context, state) => switch (state.status) {
            QuoteStatus.loading => const Center(
              child: CircularProgressIndicator(),
            ),
            QuoteStatus.failure => Row(
              children: [
                Expanded(child: Text(state.errorMessage ?? 'Lỗi')),
                TextButton(
                  onPressed: () => context.read<QuoteCubit>().fetch(),
                  child: const Text('Thử lại'),
                ),
              ],
            ),
            QuoteStatus.success => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '“${state.quote!.content}”',
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 4),
                Text('— ${state.quote!.author}'),
              ],
            ),
          },
        ),
      ),
    );
  }
}
