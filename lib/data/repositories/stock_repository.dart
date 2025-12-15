import '../data_sources/yahoo_finance_data_source.dart';
import '../models/stock.dart';

/// Repository for stock data operations
class StockRepository {
  final YahooFinanceDataSource _dataSource;

  StockRepository({YahooFinanceDataSource? dataSource})
      : _dataSource = dataSource ?? YahooFinanceDataSource();

  /// Get stock quote for a single stock
  Future<Stock> getStockQuote(String stockId, String stockName) async {
    try {
      return await _dataSource.fetchStockQuote(stockId, stockName);
    } catch (e) {
      throw Exception('Repository: Failed to get stock quote: $e');
    }
  }

  /// Get stock quotes for multiple stocks
  Future<List<Stock>> getMultipleStockQuotes(
    Map<String, String> stockMap,
  ) async {
    try {
      return await _dataSource.fetchMultipleStockQuotes(stockMap);
    } catch (e) {
      throw Exception('Repository: Failed to get multiple stock quotes: $e');
    }
  }

  /// Get default stock list (popular Taiwan stocks)
  Future<List<Stock>> getDefaultStockList() async {
    final defaultStocks = {
      '2330': '台積電',
      '2454': '聯發科',
      '2317': '鴻海',
      '2412': '中華電',
      '2308': '台達電',
    };

    try {
      return await getMultipleStockQuotes(defaultStocks);
    } catch (e) {
      throw Exception('Repository: Failed to get default stock list: $e');
    }
  }

  /// Get historical data for a stock
  Future<Map<String, dynamic>> getHistoricalData({
    required String stockId,
    String interval = '1d',
    String range = '1mo',
  }) async {
    try {
      return await _dataSource.fetchHistoricalData(
        stockId: stockId,
        interval: interval,
        range: range,
      );
    } catch (e) {
      throw Exception('Repository: Failed to get historical data: $e');
    }
  }

  /// Refresh stock data
  Future<Stock> refreshStockData(Stock stock) async {
    try {
      return await getStockQuote(stock.stockId, stock.stockName);
    } catch (e) {
      throw Exception('Repository: Failed to refresh stock data: $e');
    }
  }
}
