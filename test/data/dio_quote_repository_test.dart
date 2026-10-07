import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_tracker/data/dio_quote_repository.dart';
import 'package:task_tracker/domain/quote.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late DioQuoteRepository repository;

  setUp(() {
    dio = MockDio();
    repository = DioQuoteRepository(dio);
  });

  test('chuyển JSON từ API thành Quote', () async {
    when(() => dio.get<Map<String, dynamic>>(any())).thenAnswer(
      (_) async => Response(
        data: {'id': 1, 'quote': 'Stay hungry', 'author': 'Steve Jobs'},
        requestOptions: RequestOptions(),
      ),
    );

    final quote = await repository.fetchQuoteOfTheDay();

    expect(quote, const Quote(content: 'Stay hungry', author: 'Steve Jobs'));
    verify(
      () => dio.get<Map<String, dynamic>>(DioQuoteRepository.quoteUrl),
    ).called(1);
  });

  test('bọc lỗi mạng thành QuoteException', () async {
    when(() => dio.get<Map<String, dynamic>>(any())).thenThrow(
      DioException(requestOptions: RequestOptions(), message: 'timeout'),
    );

    expect(repository.fetchQuoteOfTheDay, throwsA(isA<QuoteException>()));
  });
}
