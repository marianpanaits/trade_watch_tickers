import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trade_watch_tickers/config/app_config.dart';
import 'package:trade_watch_tickers/core/error/failures.dart';
import 'package:trade_watch_tickers/features/trading/data/models/stock_model.dart';
import 'package:trade_watch_tickers/features/trading/data/models/stock_price_model.dart';

class StockRemoteDataSource {
  final http.Client client;

  StockRemoteDataSource(this.client);

  Future<List<StockModel>> getStockList() async {
    final http.Response response = await client.get(Uri.parse(AppConfig.getStockListEndpointUrl()));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((dynamic json) => StockModel.fromJson(json)).toList();
    } else {
      throw ServerFailure();
    }
  }

  Future<StockPriceModel> getStockPrice(String symbol) async {
    final http.Response response =
        await client.get(Uri.parse(AppConfig.getStockPriceEndpointUrl(symbol)));

    if (response.statusCode == 200) {
      return StockPriceModel.fromJson(json.decode(response.body));
    } else {
      throw ServerFailure();
    }
  }
}
