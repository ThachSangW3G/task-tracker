import 'package:equatable/equatable.dart';

import '../../domain/quote.dart';

enum QuoteStatus { loading, success, failure }

class QuoteState extends Equatable {
  const QuoteState({
    this.status = QuoteStatus.loading,
    this.quote,
    this.errorMessage,
  });

  final QuoteStatus status;
  final Quote? quote;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, quote, errorMessage];
}
