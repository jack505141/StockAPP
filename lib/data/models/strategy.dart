/// Strategy type enumeration
enum StrategyType {
  /// 均線支撐策略
  maSupport,
  /// 突破策略
  breakout,
  /// 籌碼轉強策略
  chipStrong,
  /// 費波那契策略
  fibonacci,
  /// 自訂策略
  custom,
}

/// Strategy model for trading strategies
class Strategy {
  /// 策略 ID
  final String strategyId;
  
  /// 策略名稱
  final String strategyName;
  
  /// 策略類型
  final StrategyType strategyType;
  
  /// 策略描述
  final String description;
  
  /// 止損百分比 (預設值)
  final double defaultStopLossPercent;
  
  /// 停利百分比列表 (預設值)
  final List<double> defaultTakeProfitPercents;
  
  /// 是否使用移動止損
  final bool useTrailingStop;
  
  /// 移動止損百分比
  final double? trailingStopPercent;
  
  /// 建議風險百分比
  final double suggestedRiskPercent;

  const Strategy({
    required this.strategyId,
    required this.strategyName,
    required this.strategyType,
    required this.description,
    required this.defaultStopLossPercent,
    required this.defaultTakeProfitPercents,
    this.useTrailingStop = false,
    this.trailingStopPercent,
    this.suggestedRiskPercent = 2.0,
  });

  /// Create Strategy from JSON
  factory Strategy.fromJson(Map<String, dynamic> json) {
    return Strategy(
      strategyId: json['strategyId'] as String,
      strategyName: json['strategyName'] as String,
      strategyType: StrategyType.values.firstWhere(
        (e) => e.toString() == 'StrategyType.${json['strategyType']}',
        orElse: () => StrategyType.custom,
      ),
      description: json['description'] as String,
      defaultStopLossPercent: (json['defaultStopLossPercent'] as num).toDouble(),
      defaultTakeProfitPercents: (json['defaultTakeProfitPercents'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      useTrailingStop: json['useTrailingStop'] as bool? ?? false,
      trailingStopPercent: json['trailingStopPercent'] != null
          ? (json['trailingStopPercent'] as num).toDouble()
          : null,
      suggestedRiskPercent: (json['suggestedRiskPercent'] as num?)?.toDouble() ?? 2.0,
    );
  }

  /// Convert Strategy to JSON
  Map<String, dynamic> toJson() {
    return {
      'strategyId': strategyId,
      'strategyName': strategyName,
      'strategyType': strategyType.toString().split('.').last,
      'description': description,
      'defaultStopLossPercent': defaultStopLossPercent,
      'defaultTakeProfitPercents': defaultTakeProfitPercents,
      'useTrailingStop': useTrailingStop,
      'trailingStopPercent': trailingStopPercent,
      'suggestedRiskPercent': suggestedRiskPercent,
    };
  }

  /// Predefined strategies
  static Strategy getMaSupport() {
    return const Strategy(
      strategyId: 'ma_support',
      strategyName: '均線支撐策略',
      strategyType: StrategyType.maSupport,
      description: '在均線支撐位建立多頭部位',
      defaultStopLossPercent: 2.0,
      defaultTakeProfitPercents: [3.0, 5.0, 8.0],
      suggestedRiskPercent: 2.0,
    );
  }

  static Strategy getBreakout() {
    return const Strategy(
      strategyId: 'breakout',
      strategyName: '突破策略',
      strategyType: StrategyType.breakout,
      description: '突破關鍵壓力位時買進',
      defaultStopLossPercent: 3.0,
      defaultTakeProfitPercents: [5.0, 8.0, 12.0],
      useTrailingStop: true,
      trailingStopPercent: 2.5,
      suggestedRiskPercent: 3.0,
    );
  }

  static Strategy getChipStrong() {
    return const Strategy(
      strategyId: 'chip_strong',
      strategyName: '籌碼轉強策略',
      strategyType: StrategyType.chipStrong,
      description: '籌碼面轉強時建立部位',
      defaultStopLossPercent: 2.5,
      defaultTakeProfitPercents: [4.0, 7.0, 10.0],
      suggestedRiskPercent: 2.5,
    );
  }

  static Strategy getFibonacci() {
    return const Strategy(
      strategyId: 'fibonacci',
      strategyName: '費波那契策略',
      strategyType: StrategyType.fibonacci,
      description: '根據費波那契回撤位建立部位',
      defaultStopLossPercent: 2.0,
      defaultTakeProfitPercents: [3.82, 6.18, 10.0],
      suggestedRiskPercent: 2.0,
    );
  }

  static Strategy getCustom() {
    return const Strategy(
      strategyId: 'custom',
      strategyName: '自訂策略',
      strategyType: StrategyType.custom,
      description: '自訂交易策略',
      defaultStopLossPercent: 2.0,
      defaultTakeProfitPercents: [3.0, 5.0],
      suggestedRiskPercent: 2.0,
    );
  }

  /// Get all predefined strategies
  static List<Strategy> getAllStrategies() {
    return [
      getMaSupport(),
      getBreakout(),
      getChipStrong(),
      getFibonacci(),
      getCustom(),
    ];
  }

  @override
  String toString() {
    return 'Strategy(strategyId: $strategyId, strategyName: $strategyName, '
        'strategyType: $strategyType)';
  }
}
