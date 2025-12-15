/// Position status enumeration
enum PositionStatus {
  /// 持有中
  holding,
  /// 已停利
  takeProfitClosed,
  /// 已停損
  stopLossClosed,
  /// 手動平倉
  manuallyClosed,
}

/// Take profit target model
class TakeProfit {
  /// 停利價格
  final double price;
  
  /// 停利百分比
  final double percent;
  
  /// 賣出比例 (0.0-1.0)
  final double sellRatio;
  
  /// 是否已達成
  final bool isAchieved;

  const TakeProfit({
    required this.price,
    required this.percent,
    required this.sellRatio,
    this.isAchieved = false,
  });

  factory TakeProfit.fromJson(Map<String, dynamic> json) {
    return TakeProfit(
      price: (json['price'] as num).toDouble(),
      percent: (json['percent'] as num).toDouble(),
      sellRatio: (json['sellRatio'] as num).toDouble(),
      isAchieved: json['isAchieved'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'percent': percent,
      'sellRatio': sellRatio,
      'isAchieved': isAchieved,
    };
  }

  TakeProfit copyWith({
    double? price,
    double? percent,
    double? sellRatio,
    bool? isAchieved,
  }) {
    return TakeProfit(
      price: price ?? this.price,
      percent: percent ?? this.percent,
      sellRatio: sellRatio ?? this.sellRatio,
      isAchieved: isAchieved ?? this.isAchieved,
    );
  }
}

/// Trade position model representing open positions
class TradePosition {
  /// 部位 ID
  final String positionId;
  
  /// 股票代號
  final String stockId;
  
  /// 股票名稱
  final String stockName;
  
  /// 策略 ID
  final String strategyId;
  
  /// 建立時間
  final DateTime createTime;
  
  /// 買入價格
  final double buyPrice;
  
  /// 持有張數
  final int shares;
  
  /// 投資金額
  final double investAmount;
  
  /// 總成本 (含手續費)
  final double totalCost;
  
  /// 止損價格
  final double stopLossPrice;
  
  /// 停利目標列表
  final List<TakeProfit> takeProfits;
  
  /// 是否使用移動止損
  final bool useTrailingStop;
  
  /// 移動止損百分比
  final double? trailingStopPercent;
  
  /// 當前價格
  final double currentPrice;
  
  /// 未實現損益
  final double unrealizedPL;
  
  /// 未實現損益百分比
  final double unrealizedPLPercent;
  
  /// 部位狀態
  final PositionStatus status;

  const TradePosition({
    required this.positionId,
    required this.stockId,
    required this.stockName,
    required this.strategyId,
    required this.createTime,
    required this.buyPrice,
    required this.shares,
    required this.investAmount,
    required this.totalCost,
    required this.stopLossPrice,
    required this.takeProfits,
    this.useTrailingStop = false,
    this.trailingStopPercent,
    required this.currentPrice,
    required this.unrealizedPL,
    required this.unrealizedPLPercent,
    required this.status,
  });

  /// Create TradePosition from JSON
  factory TradePosition.fromJson(Map<String, dynamic> json) {
    return TradePosition(
      positionId: json['positionId'] as String,
      stockId: json['stockId'] as String,
      stockName: json['stockName'] as String,
      strategyId: json['strategyId'] as String,
      createTime: DateTime.parse(json['createTime'] as String),
      buyPrice: (json['buyPrice'] as num).toDouble(),
      shares: json['shares'] as int,
      investAmount: (json['investAmount'] as num).toDouble(),
      totalCost: (json['totalCost'] as num).toDouble(),
      stopLossPrice: (json['stopLossPrice'] as num).toDouble(),
      takeProfits: (json['takeProfits'] as List)
          .map((e) => TakeProfit.fromJson(e as Map<String, dynamic>))
          .toList(),
      useTrailingStop: json['useTrailingStop'] as bool? ?? false,
      trailingStopPercent: json['trailingStopPercent'] != null
          ? (json['trailingStopPercent'] as num).toDouble()
          : null,
      currentPrice: (json['currentPrice'] as num).toDouble(),
      unrealizedPL: (json['unrealizedPL'] as num).toDouble(),
      unrealizedPLPercent: (json['unrealizedPLPercent'] as num).toDouble(),
      status: PositionStatus.values.firstWhere(
        (e) => e.toString() == 'PositionStatus.${json['status']}',
        orElse: () => PositionStatus.holding,
      ),
    );
  }

  /// Convert TradePosition to JSON
  Map<String, dynamic> toJson() {
    return {
      'positionId': positionId,
      'stockId': stockId,
      'stockName': stockName,
      'strategyId': strategyId,
      'createTime': createTime.toIso8601String(),
      'buyPrice': buyPrice,
      'shares': shares,
      'investAmount': investAmount,
      'totalCost': totalCost,
      'stopLossPrice': stopLossPrice,
      'takeProfits': takeProfits.map((e) => e.toJson()).toList(),
      'useTrailingStop': useTrailingStop,
      'trailingStopPercent': trailingStopPercent,
      'currentPrice': currentPrice,
      'unrealizedPL': unrealizedPL,
      'unrealizedPLPercent': unrealizedPLPercent,
      'status': status.toString().split('.').last,
    };
  }

  /// Update position with current price
  TradePosition updatePrice(double newPrice) {
    final sharesInUnits = shares * 1000; // 張轉股
    final currentValue = newPrice * sharesInUnits;
    final unrealized = currentValue - totalCost;
    final unrealizedPercent = (unrealized / totalCost) * 100;

    return TradePosition(
      positionId: positionId,
      stockId: stockId,
      stockName: stockName,
      strategyId: strategyId,
      createTime: createTime,
      buyPrice: buyPrice,
      shares: shares,
      investAmount: investAmount,
      totalCost: totalCost,
      stopLossPrice: stopLossPrice,
      takeProfits: takeProfits,
      useTrailingStop: useTrailingStop,
      trailingStopPercent: trailingStopPercent,
      currentPrice: newPrice,
      unrealizedPL: unrealized,
      unrealizedPLPercent: unrealizedPercent,
      status: status,
    );
  }

  @override
  String toString() {
    return 'TradePosition(positionId: $positionId, stockId: $stockId, '
        'buyPrice: $buyPrice, shares: $shares, unrealizedPL: $unrealizedPL)';
  }
}
