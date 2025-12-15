/// Trade plan model for planned trades
class TradePlan {
  /// 計畫 ID
  final String planId;
  
  /// 股票代號
  final String stockId;
  
  /// 股票名稱
  final String stockName;
  
  /// 策略 ID
  final String strategyId;
  
  /// 策略名稱
  final String strategyName;
  
  /// 建立時間
  final DateTime createdAt;
  
  /// 投資金額
  final double investAmount;
  
  /// 風險百分比
  final double riskPercent;
  
  /// 建議買入價
  final double suggestedBuyPrice;
  
  /// 止損價
  final double stopLossPrice;
  
  /// 停利價格列表
  final List<double> takeProfitPrices;
  
  /// 最大可買張數
  final int maxShares;
  
  /// 總成本
  final double totalCost;
  
  /// 風險金額
  final double riskAmount;
  
  /// 風險報酬比
  final double riskRewardRatio;
  
  /// 預期報酬百分比
  final double expectedReturn;

  const TradePlan({
    required this.planId,
    required this.stockId,
    required this.stockName,
    required this.strategyId,
    required this.strategyName,
    required this.createdAt,
    required this.investAmount,
    required this.riskPercent,
    required this.suggestedBuyPrice,
    required this.stopLossPrice,
    required this.takeProfitPrices,
    required this.maxShares,
    required this.totalCost,
    required this.riskAmount,
    required this.riskRewardRatio,
    required this.expectedReturn,
  });

  /// Create TradePlan from JSON
  factory TradePlan.fromJson(Map<String, dynamic> json) {
    return TradePlan(
      planId: json['planId'] as String,
      stockId: json['stockId'] as String,
      stockName: json['stockName'] as String,
      strategyId: json['strategyId'] as String,
      strategyName: json['strategyName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      investAmount: (json['investAmount'] as num).toDouble(),
      riskPercent: (json['riskPercent'] as num).toDouble(),
      suggestedBuyPrice: (json['suggestedBuyPrice'] as num).toDouble(),
      stopLossPrice: (json['stopLossPrice'] as num).toDouble(),
      takeProfitPrices: (json['takeProfitPrices'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      maxShares: json['maxShares'] as int,
      totalCost: (json['totalCost'] as num).toDouble(),
      riskAmount: (json['riskAmount'] as num).toDouble(),
      riskRewardRatio: (json['riskRewardRatio'] as num).toDouble(),
      expectedReturn: (json['expectedReturn'] as num).toDouble(),
    );
  }

  /// Convert TradePlan to JSON
  Map<String, dynamic> toJson() {
    return {
      'planId': planId,
      'stockId': stockId,
      'stockName': stockName,
      'strategyId': strategyId,
      'strategyName': strategyName,
      'createdAt': createdAt.toIso8601String(),
      'investAmount': investAmount,
      'riskPercent': riskPercent,
      'suggestedBuyPrice': suggestedBuyPrice,
      'stopLossPrice': stopLossPrice,
      'takeProfitPrices': takeProfitPrices,
      'maxShares': maxShares,
      'totalCost': totalCost,
      'riskAmount': riskAmount,
      'riskRewardRatio': riskRewardRatio,
      'expectedReturn': expectedReturn,
    };
  }

  @override
  String toString() {
    return 'TradePlan(planId: $planId, stockId: $stockId, stockName: $stockName, '
        'buyPrice: $suggestedBuyPrice, shares: $maxShares)';
  }
}
