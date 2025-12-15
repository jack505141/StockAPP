/// Stock model representing stock quote data
class Stock {
  /// 股票代號 (e.g., "2330")
  final String stockId;
  
  /// 股票名稱
  final String stockName;
  
  /// 現價
  final double currentPrice;
  
  /// 漲跌
  final double changePrice;
  
  /// 漲跌幅%
  final double changePercent;
  
  /// 成交量
  final int volume;
  
  /// 開盤價
  final double open;
  
  /// 最高價
  final double high;
  
  /// 最低價
  final double low;
  
  /// 收盤價
  final double close;
  
  /// 昨收
  final double yesterdayClose;
  
  /// 更新時間
  final DateTime updateTime;
  
  /// 技術分析數據 (可選)
  final double? ma5;
  final double? ma10;
  final double? ma20;
  final double? ma60;
  final double? rsi;
  
  /// 關鍵價位 (可選)
  final double? supportPrice;
  final double? resistancePrice;

  const Stock({
    required this.stockId,
    required this.stockName,
    required this.currentPrice,
    required this.changePrice,
    required this.changePercent,
    required this.volume,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.yesterdayClose,
    required this.updateTime,
    this.ma5,
    this.ma10,
    this.ma20,
    this.ma60,
    this.rsi,
    this.supportPrice,
    this.resistancePrice,
  });

  /// Create Stock from Yahoo Finance API response
  factory Stock.fromYahooJson(Map<String, dynamic> json, String stockId, String stockName) {
    try {
      final chart = json['chart'] as Map<String, dynamic>;
      final result = (chart['result'] as List).first as Map<String, dynamic>;
      final meta = result['meta'] as Map<String, dynamic>;
      
      final currentPrice = (meta['regularMarketPrice'] ?? meta['previousClose'] ?? 0.0).toDouble();
      final yesterdayClose = (meta['chartPreviousClose'] ?? meta['previousClose'] ?? currentPrice).toDouble();
      final open = (meta['regularMarketOpen'] ?? currentPrice).toDouble();
      final high = (meta['regularMarketDayHigh'] ?? currentPrice).toDouble();
      final low = (meta['regularMarketDayLow'] ?? currentPrice).toDouble();
      final volume = (meta['regularMarketVolume'] ?? 0);
      
      final changePrice = currentPrice - yesterdayClose;
      final changePercent = yesterdayClose != 0 ? (changePrice / yesterdayClose) * 100 : 0.0;
      
      return Stock(
        stockId: stockId,
        stockName: stockName,
        currentPrice: currentPrice,
        changePrice: changePrice,
        changePercent: changePercent,
        volume: volume is int ? volume : (volume as num).toInt(),
        open: open,
        high: high,
        low: low,
        close: currentPrice,
        yesterdayClose: yesterdayClose,
        updateTime: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to parse Yahoo Finance data: $e');
    }
  }

  /// Create Stock from JSON
  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      stockId: json['stockId'] as String,
      stockName: json['stockName'] as String,
      currentPrice: (json['currentPrice'] as num).toDouble(),
      changePrice: (json['changePrice'] as num).toDouble(),
      changePercent: (json['changePercent'] as num).toDouble(),
      volume: json['volume'] as int,
      open: (json['open'] as num).toDouble(),
      high: (json['high'] as num).toDouble(),
      low: (json['low'] as num).toDouble(),
      close: (json['close'] as num).toDouble(),
      yesterdayClose: (json['yesterdayClose'] as num).toDouble(),
      updateTime: DateTime.parse(json['updateTime'] as String),
      ma5: json['ma5'] != null ? (json['ma5'] as num).toDouble() : null,
      ma10: json['ma10'] != null ? (json['ma10'] as num).toDouble() : null,
      ma20: json['ma20'] != null ? (json['ma20'] as num).toDouble() : null,
      ma60: json['ma60'] != null ? (json['ma60'] as num).toDouble() : null,
      rsi: json['rsi'] != null ? (json['rsi'] as num).toDouble() : null,
      supportPrice: json['supportPrice'] != null ? (json['supportPrice'] as num).toDouble() : null,
      resistancePrice: json['resistancePrice'] != null ? (json['resistancePrice'] as num).toDouble() : null,
    );
  }

  /// Convert Stock to JSON
  Map<String, dynamic> toJson() {
    return {
      'stockId': stockId,
      'stockName': stockName,
      'currentPrice': currentPrice,
      'changePrice': changePrice,
      'changePercent': changePercent,
      'volume': volume,
      'open': open,
      'high': high,
      'low': low,
      'close': close,
      'yesterdayClose': yesterdayClose,
      'updateTime': updateTime.toIso8601String(),
      'ma5': ma5,
      'ma10': ma10,
      'ma20': ma20,
      'ma60': ma60,
      'rsi': rsi,
      'supportPrice': supportPrice,
      'resistancePrice': resistancePrice,
    };
  }

  /// Create a copy of Stock with updated fields
  Stock copyWith({
    String? stockId,
    String? stockName,
    double? currentPrice,
    double? changePrice,
    double? changePercent,
    int? volume,
    double? open,
    double? high,
    double? low,
    double? close,
    double? yesterdayClose,
    DateTime? updateTime,
    double? ma5,
    double? ma10,
    double? ma20,
    double? ma60,
    double? rsi,
    double? supportPrice,
    double? resistancePrice,
  }) {
    return Stock(
      stockId: stockId ?? this.stockId,
      stockName: stockName ?? this.stockName,
      currentPrice: currentPrice ?? this.currentPrice,
      changePrice: changePrice ?? this.changePrice,
      changePercent: changePercent ?? this.changePercent,
      volume: volume ?? this.volume,
      open: open ?? this.open,
      high: high ?? this.high,
      low: low ?? this.low,
      close: close ?? this.close,
      yesterdayClose: yesterdayClose ?? this.yesterdayClose,
      updateTime: updateTime ?? this.updateTime,
      ma5: ma5 ?? this.ma5,
      ma10: ma10 ?? this.ma10,
      ma20: ma20 ?? this.ma20,
      ma60: ma60 ?? this.ma60,
      rsi: rsi ?? this.rsi,
      supportPrice: supportPrice ?? this.supportPrice,
      resistancePrice: resistancePrice ?? this.resistancePrice,
    );
  }

  @override
  String toString() {
    return 'Stock(stockId: $stockId, stockName: $stockName, currentPrice: $currentPrice, '
        'changePrice: $changePrice, changePercent: $changePercent%)';
  }
}
