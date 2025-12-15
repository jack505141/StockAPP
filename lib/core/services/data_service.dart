import '../../data/models/stock.dart';
import '../../data/models/trade_plan.dart';
import '../../data/models/trade_position.dart';
import '../../data/repositories/stock_repository.dart';

/// Data service for managing application data
class DataService {
  final StockRepository _stockRepository;

  DataService({StockRepository? stockRepository})
      : _stockRepository = stockRepository ?? StockRepository();

  /// Get stock data
  Future<Stock> getStock(String stockId, String stockName) async {
    return await _stockRepository.getStockQuote(stockId, stockName);
  }

  /// Get multiple stocks
  Future<List<Stock>> getStocks(Map<String, String> stockMap) async {
    return await _stockRepository.getMultipleStockQuotes(stockMap);
  }

  /// Get default stock list
  Future<List<Stock>> getDefaultStocks() async {
    return await _stockRepository.getDefaultStockList();
  }

  /// Refresh stock data
  Future<Stock> refreshStock(Stock stock) async {
    return await _stockRepository.refreshStockData(stock);
  }
}
