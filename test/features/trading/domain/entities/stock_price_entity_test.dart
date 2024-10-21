import 'package:flutter_test/flutter_test.dart';
import 'package:trade_watch_tickers/features/trading/domain/entities/stock_price.dart';

void main() {
  group('StockPrice', () {
    test('should create a valid StockPrice instance', () {
      final StockPrice stockPrice = const StockPrice(
        currentPrice: 150.0,
        percentChange: 1.5,
      );

      expect(stockPrice.currentPrice, 150.0);
      expect(stockPrice.percentChange, 1.5);
    });

    test('two stock prices with the same properties should be equal', () {
      final StockPrice stockPrice1 = const StockPrice(
        currentPrice: 150.0,
        percentChange: 1.5,
      );

      final StockPrice stockPrice2 = const StockPrice(
        currentPrice: 150.0,
        percentChange: 1.5,
      );

      expect(stockPrice1, equals(stockPrice2));
    });
  });
}
