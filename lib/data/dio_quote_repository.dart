import 'package:dio/dio.dart';

import '../domain/quote.dart';
import '../domain/quote_repository.dart';

class DioQuoteRepository implements QuoteRepository {
  DioQuoteRepository(this._dio);
  //Sửa comment để test, sửa tiếp
  static const quoteUrl = 'https://dummyjson.com/quotes/random';

  final Dio _dio;

  @override
  Future<Quote> fetchQuoteOfTheDay() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(quoteUrl);
      final data = response.data;
      if (data == null) throw const QuoteException('Phản hồi rỗng');
      return Quote(
        content: data['quote'] as String,
        author: data['author'] as String,
      );
    } on DioException catch (e) {
      throw QuoteException('Không tải được trích dẫn: ${e.message}');
    }
  }
}
