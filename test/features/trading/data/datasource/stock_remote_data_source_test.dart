import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:trade_watch_tickers/core/error/failures.dart';
import 'package:trade_watch_tickers/features/trading/data/datasources/stock_remote_data_source.dart';
import 'package:trade_watch_tickers/features/trading/data/models/stock_model.dart';
import 'package:trade_watch_tickers/features/trading/data/models/stock_price_model.dart';

import 'stock_remote_data_source_test.mocks.dart';

@GenerateMocks(<Type>[http.Client])
void main() {
  late StockRemoteDataSource dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = StockRemoteDataSource(mockHttpClient);
  });

  group('getStockList', () {
    final List<Map<String, String>> tStockListJson = [
      <String, String>{"symbol": "AAPL", "description": "Apple Inc", "currency": "USD"},
      <String, String>{"symbol": "GOOGL", "description": "Alphabet Inc", "currency": "USD"}
    ];

    test(
      'should return List<StockModel> when the response code is 200',
      () async {
        // arrange
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(json.encode(tStockListJson), 200),
        );

        // act
        final List<StockModel> result = await dataSource.getStockList();

        // assert
        expect(result, isA<List<StockModel>>());
        expect(result.length, equals(2));
        expect(result[0].symbol, equals('AAPL'));
        expect(result[1].symbol, equals('GOOGL'));
      },
    );

    test(
      'should throw a ServerException when the response code is not 200',
      () async {
        // arrange
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response('Something went wrong', 404),
        );

        // act
        final Future<List<StockModel>> call = dataSource.getStockList();

        // assert
        expect(() => call, throwsA(isA<ServerFailure>()));
      },
    );
  });

  group('getStockPrice', () {
    final String tSymbol = 'AAPL';
    final Map<String, dynamic> tStockPriceJson = <String, num>{
      "c": 150.0,
      "d": 1.5,
      "dp": 1.0,
      "h": 151.0,
      "l": 149.0,
      "o": 149.5,
      "pc": 148.5,
      "t": 1635724800
    };

    test(
      'should return StockPriceModel when the response code is 200',
      () async {
        // arrange
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(json.encode(tStockPriceJson), 200),
        );

        // act
        final StockPriceModel result = await dataSource.getStockPrice(tSymbol);

        // assert
        expect(result, isA<StockPriceModel>());
        expect(result.currentPrice, equals(150.0));
        expect(result.percentChange, equals(1.0));
      },
    );

    test(
      'should throw a ServerFailure when the response code is not 200',
      () async {
        // arrange
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response('Something went wrong', 404),
        );

        // act
        final Future<StockPriceModel> call = dataSource.getStockPrice(tSymbol);

        // assert
        expect(() => call, throwsA(isA<ServerFailure>()));
      },
    );
  });
}
