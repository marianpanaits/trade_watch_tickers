import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../models/stock_model.dart';

class StockWebsocketDataSource {
  final WebSocketChannel Function() _channelFactory;
  WebSocketChannel? _channel;
  final StreamController<StockModel> _controller;
  final Set<String> _subscribedSymbols = <String>{};
  Timer? _reconnectionTimer;
  static const int _maxReconnectDelay = 60000;

  StockWebsocketDataSource(this._channelFactory)
      : _controller = StreamController<StockModel>.broadcast() {
    _connect();
  }

  Stream<StockModel> get updates => _controller.stream;

  void _connect() {
    _channel = _channelFactory();
    _channel!.stream.listen(_onData, onError: _onError, onDone: _onDone);

    // Resubscribe to all symbols after reconnection
    for (final String symbol in _subscribedSymbols) {
      _sendSubscription(symbol);
    }
  }

  void _sendSubscription(String symbol) {
    _channel?.sink.add(jsonEncode(<String, String>{"type": "subscribe", "symbol": symbol}));
  }

  void subscribeToSymbol(String symbol) {
    if (!_subscribedSymbols.contains(symbol)) {
      _sendSubscription(symbol);
      _subscribedSymbols.add(symbol);
    }
  }

  void unsubscribeFromSymbol(String symbol) {
    if (_subscribedSymbols.contains(symbol)) {
      _channel?.sink.add(jsonEncode(<String, String>{"type": "unsubscribe", "symbol": symbol}));
      _subscribedSymbols.remove(symbol);
    }
  }

  void _onData(dynamic data) {
    final dynamic jsonData = jsonDecode(data);
    if (jsonData['type'] == 'trade') {
      final StockModel stockUpdate = StockModel(
        symbol: jsonData['data'][0]['s'],
        currentPrice: double.parse(jsonData['data'][0]['p']),
        description: '',
      );
      _controller.add(stockUpdate);
    }
  }

  void _onError(dynamic error) {
    log('WebSocket Error: $error');
    _scheduleReconnection();
  }

  void _onDone() {
    log('WebSocket connection closed');
    _scheduleReconnection();
  }

  void _scheduleReconnection() {
    _reconnectionTimer?.cancel();

    final Duration delay = const Duration(milliseconds: _maxReconnectDelay);
    log('Scheduling reconnection in ${delay.inSeconds} seconds');

    _reconnectionTimer = Timer(delay, () {
      log('Attempting to reconnect...');
      _connect();
    });
  }

  void dispose() {
    _reconnectionTimer?.cancel();
    _channel?.sink.close();
    _controller.close();
  }
}
