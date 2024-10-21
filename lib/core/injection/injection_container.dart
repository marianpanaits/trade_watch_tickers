import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:trade_watch_tickers/config/app_config.dart';
import 'package:trade_watch_tickers/features/trading/data/datasources/stock_remote_data_source.dart';
import 'package:trade_watch_tickers/features/trading/data/datasources/stock_websocket_data_source.dart';
import 'package:trade_watch_tickers/features/trading/data/repositories/stock_repository_impl.dart';
import 'package:trade_watch_tickers/features/trading/domain/repositories/stock_repository.dart';
import 'package:trade_watch_tickers/features/trading/domain/usecases/get_stock_list.dart';
import 'package:trade_watch_tickers/features/trading/domain/usecases/get_stock_price.dart';
import 'package:trade_watch_tickers/features/trading/domain/usecases/subscribe_to_stock_updates.dart';
import 'package:trade_watch_tickers/features/trading/domain/usecases/subscribe_to_symbol.dart';
import 'package:trade_watch_tickers/features/trading/domain/usecases/unsubscribe_from_symbol.dart';
import 'package:trade_watch_tickers/features/trading/presentation/bloc/stock_list_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final GetIt di = GetIt.instance;

void setupDependencies() {
  // Data sources
  di.registerLazySingleton(() => StockRemoteDataSource(http.Client()));
  di.registerLazySingleton<StockWebsocketDataSource>(() => StockWebsocketDataSource(
      () => WebSocketChannel.connect(Uri.parse(AppConfig.getWebSocketUrl()))));

  // Repository
  di.registerLazySingleton(() => StockRepositoryImpl(
        remoteDataSource: di(),
        websocketDataSource: di(),
      ));
  di.registerFactory<StockRepository>(() => di<StockRepositoryImpl>());

  // Use cases
  di.registerLazySingleton(() => GetStockList(di()));
  di.registerLazySingleton(() => GetStockPrice(di()));
  di.registerLazySingleton(() => SubscribeToStockUpdates(di()));
  di.registerLazySingleton(() => SubscribeToSymbol(di()));
  di.registerLazySingleton(() => UnsubscribeFromSymbol(di()));

  // BLoC
  di.registerFactory(() => StockListBloc(
        getStockList: di(),
        getStockPrice: di(),
        subscribeToStockUpdates: di(),
        subscribeToSymbol: di(),
        unsubscribeFromSymbol: di(),
      ));
}
