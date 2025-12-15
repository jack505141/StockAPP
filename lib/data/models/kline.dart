/// K-line (candlestick) data model
class KLine {
  /// 時間戳
  final DateTime timestamp;
  
  /// 開盤價
  final double open;
  
  /// 最高價
  final double high;
  
  /// 最低價
  final double low;
  
  /// 收盤價
  final double close;
  
  /// 成交量
  final int volume;

  const KLine({
    required this.timestamp,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  /// Create KLine from JSON
  factory KLine.fromJson(Map<String, dynamic> json) {
    return KLine(
      timestamp: DateTime.parse(json['timestamp'] as String),
      open: (json['open'] as num).toDouble(),
      high: (json['high'] as num).toDouble(),
      low: (json['low'] as num).toDouble(),
      close: (json['close'] as num).toDouble(),
      volume: json['volume'] as int,
    );
  }

  /// Convert KLine to JSON
  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'open': open,
      'high': high,
      'low': low,
      'close': close,
      'volume': volume,
    };
  }

  /// Check if this is a bullish candle
  bool get isBullish => close > open;

  /// Check if this is a bearish candle
  bool get isBearish => close < open;

  /// Get candle body size
  double get bodySize => (close - open).abs();

  /// Get upper shadow size
  double get upperShadow => high - (close > open ? close : open);

  /// Get lower shadow size
  double get lowerShadow => (close > open ? open : close) - low;

  @override
  String toString() {
    return 'KLine(timestamp: $timestamp, open: $open, high: $high, '
        'low: $low, close: $close, volume: $volume)';
  }
}
