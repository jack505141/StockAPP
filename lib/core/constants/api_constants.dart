/// API constants for the application
class ApiConstants {
  /// Yahoo Finance base URL
  static const String yahooFinanceBaseUrl = 'https://query1.finance.yahoo.com';
  
  /// Yahoo Finance chart API endpoint
  static const String chartEndpoint = '/v8/finance/chart';
  
  /// Get chart URL for a stock
  static String getChartUrl(String stockId) {
    return '$yahooFinanceBaseUrl$chartEndpoint/$stockId.TW';
  }
  
  /// Default timeout duration in seconds
  static const int timeoutSeconds = 30;
  
  /// Connection timeout in milliseconds
  static const int connectionTimeout = 30000;
  
  /// Receive timeout in milliseconds
  static const int receiveTimeout = 30000;
}

/// Trading constants
class TradingConstants {
  /// 手續費率 (0.1425%)
  static const double commissionRate = 0.001425;
  
  /// 最低手續費 (NT$)
  static const double minCommission = 20.0;
  
  /// 證券交易稅率 (0.3%)
  static const double transactionTax = 0.003;
  
  /// 每張股數
  static const int sharesPerLot = 1000;
  
  /// 計算手續費
  static double calculateCommission(double amount) {
    final commission = amount * commissionRate;
    return commission < minCommission ? minCommission : commission;
  }
  
  /// 計算交易稅
  static double calculateTax(double amount) {
    return amount * transactionTax;
  }
  
  /// 計算總買入成本 (含手續費)
  static double calculateBuyCost(double price, int shares) {
    final amount = price * shares * sharesPerLot;
    final commission = calculateCommission(amount);
    return amount + commission;
  }
  
  /// 計算總賣出收入 (扣除手續費和交易稅)
  static double calculateSellRevenue(double price, int shares) {
    final amount = price * shares * sharesPerLot;
    final commission = calculateCommission(amount);
    final tax = calculateTax(amount);
    return amount - commission - tax;
  }
}

/// App storage keys
class StorageKeys {
  /// Favorite stocks key
  static const String favoriteStocks = 'favorite_stocks';
  
  /// Trade plans key
  static const String tradePlans = 'trade_plans';
  
  /// Trade positions key
  static const String tradePositions = 'trade_positions';
  
  /// Theme mode key
  static const String themeMode = 'theme_mode';
}
