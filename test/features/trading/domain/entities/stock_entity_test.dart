import 'package:flutter_test/flutter_test.dart';
import 'package:trade_watch_tickers/features/trading/domain/entities/stock.dart';

void main() {
  group('Stock', () {
    test('should create a valid Stock instance', () {
      final Stock stock = const Stock(
        symbol: 'AAPL',
        description: 'Apple Inc.',
        currentPrice: 150.0,
        percentChange: 1.5,
      );

      expect(stock.symbol, 'AAPL');
      expect(stock.description, 'Apple Inc.');
      expect(stock.currentPrice, 150.0);
      expect(stock.percentChange, 1.5);
    });

    test('should create a valid Stock instance with null price and change', () {
      final Stock stock = const Stock(
        symbol: 'GOOGL',
        description: 'Alphabet Inc.',
        currentPrice: null,
        percentChange: null,
      );

      expect(stock.symbol, 'GOOGL');
      expect(stock.description, 'Alphabet Inc.');
      expect(stock.currentPrice, null);
      expect(stock.percentChange, null);
    });

    test('two stocks with the same properties should be equal', () {
      final Stock stock1 = const Stock(
        symbol: 'AAPL',
        description: 'Apple Inc.',
        currentPrice: 150.0,
        percentChange: 1.5,
      );

      final Stock stock2 = const Stock(
        symbol: 'AAPL',
        description: 'Apple Inc.',
        currentPrice: 150.0,
        percentChange: 1.5,
      );

      expect(stock1, equals(stock2));
    });

    test('copyWith should return a new Stock with updated values', () {
      final Stock stock = const Stock(
        symbol: 'AAPL',
        description: 'Apple Inc.',
        currentPrice: 150.0,
        percentChange: 1.5,
      );

      final Stock updatedStock = stock.copyWith(
        currentPrice: 160.0,
        percentChange: 2.0,
      );

      expect(updatedStock.symbol, 'AAPL');
      expect(updatedStock.description, 'Apple Inc.');
      expect(updatedStock.currentPrice, 160.0);
      expect(updatedStock.percentChange, 2.0);
    });
  });
}
