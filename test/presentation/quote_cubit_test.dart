import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_tracker/domain/quote.dart';
import 'package:task_tracker/presentation/quote/quote_cubit.dart';
import 'package:task_tracker/presentation/quote/quote_state.dart';

import '../helpers/fakes.dart';

void main() {
  late MockQuoteRepository repository;

  const quote = Quote(content: 'Stay hungry', author: 'Steve Jobs');

  setUp(() => repository = MockQuoteRepository());

  blocTest<QuoteCubit, QuoteState>(
    'loading -> success khi API trả về quote',
    setUp: () => when(
      () => repository.fetchQuoteOfTheDay(),
    ).thenAnswer((_) async => quote),
    build: () => QuoteCubit(repository),
    act: (cubit) => cubit.fetch(),
    expect: () => [
      const QuoteState(status: QuoteStatus.loading),
      const QuoteState(status: QuoteStatus.success, quote: quote),
    ],
  );

  blocTest<QuoteCubit, QuoteState>(
    'loading -> failure khi API lỗi',
    setUp: () => when(
      () => repository.fetchQuoteOfTheDay(),
    ).thenThrow(const QuoteException('Mất mạng')),
    build: () => QuoteCubit(repository),
    act: (cubit) => cubit.fetch(),
    expect: () => [
      const QuoteState(status: QuoteStatus.loading),
      const QuoteState(status: QuoteStatus.failure, errorMessage: 'Mất mạng'),
    ],
  );
}
