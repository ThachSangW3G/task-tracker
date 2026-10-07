import 'quote.dart';

abstract interface class QuoteRepository {
  /// Ném [QuoteException] nếu không lấy được dữ liệu.
  Future<Quote> fetchQuoteOfTheDay();
}
