import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/quote.dart';
import '../../domain/quote_repository.dart';
import 'quote_state.dart';

class QuoteCubit extends Cubit<QuoteState> {
  QuoteCubit(this._repository) : super(const QuoteState());

  final QuoteRepository _repository;

  Future<void> fetch() async {
    emit(const QuoteState(status: QuoteStatus.loading));
    try {
      final quote = await _repository.fetchQuoteOfTheDay();
      emit(QuoteState(status: QuoteStatus.success, quote: quote));
    } on QuoteException catch (e) {
      emit(QuoteState(status: QuoteStatus.failure, errorMessage: e.message));
    }
  }
}
