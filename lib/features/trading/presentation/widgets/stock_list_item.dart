import 'package:flutter/material.dart';
import 'package:trade_watch_tickers/features/trading/domain/entities/stock.dart';

class StockListItem extends StatelessWidget {
  final Stock stock;

  const StockListItem({Key? key, required this.stock}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(stock.symbol),
      subtitle: Text(stock.description),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text('\$${stock.currentPrice?.toStringAsFixed(2) ?? '-'}'),
          Text(
            '${stock.percentChange?.toStringAsFixed(2) ?? '-'}%',
            style: TextStyle(
              color: (stock.percentChange ?? 0.0) >= 0 ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
