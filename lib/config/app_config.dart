class AppConfig {
  static const String apiBaseUrl = 'https://finnhub.io/api/v1';
  static const String apiToken = 'cs90je1r01qu0vk4jgagcs90je1r01qu0vk4jgb0';
  static const String websocketUrl = 'wss://ws.finnhub.io';
  static const String stockListEndpoint = '/stock/symbol';
  static const String stockPriceEndpoint = '/quote';
  static String getFullApiUrl(String endpoint) => '$apiBaseUrl$endpoint?token=$apiToken';
  static String getStockListEndpointUrl() =>
      '$apiBaseUrl$stockListEndpoint?token=$apiToken&exchange=US&currency=USD';
  static String getStockPriceEndpointUrl(String symbol) =>
      '$apiBaseUrl$stockPriceEndpoint?token=$apiToken&symbol=$symbol';
  static String getWebSocketUrl() => '$websocketUrl?token=$apiToken';
}
