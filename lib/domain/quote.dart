import 'package:equatable/equatable.dart';

class Quote extends Equatable {
  const Quote({required this.content, required this.author});

  final String content;
  final String author;

  @override
  List<Object?> get props => [content, author];
}

class QuoteException implements Exception {
  const QuoteException(this.message);

  final String message;

  @override
  String toString() => 'QuoteException: $message';
}
