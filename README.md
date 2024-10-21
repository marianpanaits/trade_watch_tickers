# Trade Watch Tickers

Trade Watch Tickers is a Flutter application that provides real-time stock price updates. 
This app demonstrates the implementation of clean architecture principles, 
BLoC pattern for state management, and real-time data handling using WebSockets.

## Features

- Real-time stock price updates
- Search functionality for stocks
- Lazy loading of stock list
- 
## Architecture

This project follows Clean Architecture principles, separating the codebase into three main layers:

1. **Presentation Layer**: Contains the UI components and BLoCs for state management.
2. **Domain Layer**: Defines the core business logic and use cases of the application.
3. **Data Layer**: Handles data operations, including API calls and local storage.

## Getting Started

### Prerequisites

- Flutter SDK (version 2.5 or later)
- Dart SDK (version 2.14 or later)

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/trade_watch_tickers.git
   ```

2. Navigate to the project directory:
   ```
   cd trade_watch_tickers
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

4. Run the app:
   ```
   flutter run
   ```

## Configuration

To use the app with a real stock API, you need to configure the API endpoint and any required API keys. 
Update the `lib/config/app_config.dart` file with your API details.

## Testing

This project includes unit tests, widget tests, and integration tests. To run all tests:

```
flutter test
```

To run specific tests:

```
flutter test test/path/to/test_file.dart
```

## Dependencies

Key dependencies used in this project:

- `flutter_bloc`: For state management
- `get_it`: For dependency injection
- `equatable`: For value comparisons
- `http`: For making HTTP requests
- `web_socket_channel`: For WebSocket connections

For a full list of dependencies, see the `pubspec.yaml` file.