import 'package:flutter_test/flutter_test.dart';
import 'package:trade_watch_tickers/features/trading/data/models/stock_model.dart';
import 'package:trade_watch_tickers/features/trading/domain/entities/stock.dart';

void main() {
  final StockModel tStockModel = StockModel(
    symbol: 'AAPL',
    description: 'Apple Inc.',
    currentPrice: 150.0,
    percentChange: 1.5,
  );

  final StockModel tStockModelWithNulls = StockModel(
    symbol: 'GOOGL',
    description: 'Alphabet Inc.',
    currentPrice: null,
    percentChange: null,
  );

  final Map<String, Object> tStockJson = <String, Object>{
    'symbol': 'AAPL',
    'description': 'Apple Inc.',
    'currentPrice': 150.0,
    'percentChange': 1.5,
  };

  final Map<String, String?> tStockJsonWithNulls = <String, String?>{
    'symbol': 'GOOGL',
    'description': 'Alphabet Inc.',
    'currentPrice': null,
    'percentChange': null,
  };

  group('StockModel', () {
    test('should be a subclass of Stock entity', () {
      expect(tStockModel, isA<Stock>());
    });

    test('fromJson should return a valid model', () {
      final StockModel result = StockModel.fromJson(tStockJson);
      expect(result, tStockModel);
    });

    test('fromJson should handle null values', () {
      final StockModel result = StockModel.fromJson(tStockJsonWithNulls);
      expect(result, tStockModelWithNulls);
    });

    test('toJson should return a JSON map containing proper data', () {
      final Map<String, dynamic> result = tStockModel.toJson();
      expect(result, tStockJson);
    });

    test('toJson should handle null values', () {
      final Map<String, dynamic> result = tStockModelWithNulls.toJson();
      expect(result, tStockJsonWithNulls);
    });

    test('fromEntity should return a valid model', () {
      final Stock stock = const Stock(
        symbol: 'AAPL',
        description: 'Apple Inc.',
        currentPrice: 150.0,
        percentChange: 1.5,
      );
      final StockModel result = StockModel.fromEntity(stock);
      expect(result, tStockModel);
    });

    test('toEntity should return a Stock entity', () {
      final Stock result = tStockModel.toEntity();
      expect(result, isA<Stock>());
      expect(result.symbol, tStockModel.symbol);
      expect(result.description, tStockModel.description);
      expect(result.currentPrice, tStockModel.currentPrice);
      expect(result.percentChange, tStockModel.percentChange);
    });
  });
}
