import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:trade_watch_tickers/features/trading/data/models/stock_price_model.dart';
import 'package:trade_watch_tickers/features/trading/domain/entities/stock_price.dart';

void main() {
  final StockPriceModel tStockPriceModel = StockPriceModel(
    currentPrice: 150.0,
    percentChange: 1.5,
  );

  final Map<String, double> tStockPriceJson = {
    'c': 150.0,
    'dp': 1.5,
  };

  group('StockPriceModel', () {
    test('should be a subclass of StockPrice entity', () {
      expect(tStockPriceModel, isA<StockPrice>());
    });

    test('fromJson should return a valid model', () {
      final StockPriceModel result = StockPriceModel.fromJson(tStockPriceJson);
      expect(result, tStockPriceModel);
    });

    test('toJson should return a JSON map containing proper data', () {
      final Map<String, dynamic> result = tStockPriceModel.toJson();
      expect(result, tStockPriceJson);
    });

    test('fromEntity should return a valid model', () {
      final StockPrice stockPrice = const StockPrice(
        currentPrice: 150.0,
        percentChange: 1.5,
      );
      final StockPriceModel result = StockPriceModel.fromEntity(stockPrice);
      expect(result, tStockPriceModel);
    });

    test('toEntity should return a StockPrice entity', () {
      final StockPrice result = tStockPriceModel.toEntity();
      expect(result, isA<StockPrice>());
      expect(result.currentPrice, tStockPriceModel.currentPrice);
      expect(result.percentChange, tStockPriceModel.percentChange);
    });

    test('JSON encoding and decoding should work correctly', () {
      final String jsonString = json.encode(tStockPriceModel.toJson());
      final dynamic decodedJson = json.decode(jsonString);
      final StockPriceModel result = StockPriceModel.fromJson(decodedJson);
      expect(result, tStockPriceModel);
    });
  });
}
