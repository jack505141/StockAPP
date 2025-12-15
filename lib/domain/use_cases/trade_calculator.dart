import 'package:uuid/uuid.dart';
import '../../data/models/stock.dart';
import '../../data/models/strategy.dart';
import '../../data/models/trade_plan.dart';
import '../../core/utils/calculator.dart';

/// Trade calculator for generating trade plans
class TradeCalculator {
  static const _uuid = Uuid();

  /// Calculate a complete trade plan based on stock, strategy, and investment parameters
  static TradePlan calculateTradePlan({
    required Stock stock,
    required Strategy strategy,
    required double investAmount,
    required double riskPercent,
  }) {
    // 1. Calculate suggested buy price based on strategy
    final buyPrice = _calculateBuyPrice(stock, strategy);

    // 2. Calculate stop loss price
    final stopLoss = _calculateStopLoss(
      buyPrice,
      riskPercent,
      strategy,
    );

    // 3. Calculate take profit prices (multiple levels)
    final takeProfits = _calculateTakeProfits(
      buyPrice,
      strategy,
    );

    // 4. Calculate maximum shares that can be bought
    final maxShares = Calculator.calculateMaxShares(investAmount, buyPrice);

    // 5. Calculate total cost
    final totalCost = Calculator.calculateTotalBuyCost(buyPrice, maxShares);

    // 6. Calculate risk amount
    final riskAmount = Calculator.calculateRiskAmount(
      buyPrice,
      stopLoss,
      maxShares,
    );

    // 7. Calculate risk reward ratio (using first take profit level)
    final riskRewardRatio = Calculator.calculateRiskRewardRatio(
      buyPrice,
      stopLoss,
      takeProfits.isNotEmpty ? takeProfits[0] : buyPrice,
    );

    // 8. Calculate expected return (using first take profit level)
    final expectedReturn = takeProfits.isNotEmpty
        ? ((takeProfits[0] - buyPrice) / buyPrice) * 100
        : 0.0;

    return TradePlan(
      planId: _uuid.v4(),
      stockId: stock.stockId,
      stockName: stock.stockName,
      strategyId: strategy.strategyId,
      strategyName: strategy.strategyName,
      createdAt: DateTime.now(),
      investAmount: investAmount,
      riskPercent: riskPercent,
      suggestedBuyPrice: buyPrice,
      stopLossPrice: stopLoss,
      takeProfitPrices: takeProfits,
      maxShares: maxShares,
      totalCost: totalCost,
      riskAmount: riskAmount,
      riskRewardRatio: riskRewardRatio,
      expectedReturn: expectedReturn,
    );
  }

  /// Calculate suggested buy price based on strategy type
  static double _calculateBuyPrice(Stock stock, Strategy strategy) {
    switch (strategy.strategyType) {
      case StrategyType.maSupport:
        // For MA support strategy, suggest buying near MA20 or current price
        return stock.ma20 ?? stock.currentPrice * 0.992; // Slightly below current price
      
      case StrategyType.breakout:
        // For breakout strategy, suggest buying at resistance level
        return stock.resistancePrice ?? stock.high * 1.002; // Slightly above high
      
      case StrategyType.chipStrong:
        // For chip strong strategy, buy at current price
        return stock.currentPrice;
      
      case StrategyType.fibonacci:
        // For Fibonacci strategy, suggest buying at 0.618 retracement
        final range = stock.high - stock.low;
        return stock.low + (range * 0.618);
      
      case StrategyType.custom:
      default:
        // Default to current price
        return stock.currentPrice;
    }
  }

  /// Calculate stop loss price
  static double _calculateStopLoss(
    double buyPrice,
    double riskPercent,
    Strategy strategy,
  ) {
    // Use the provided risk percent or strategy default
    final stopLossPercent = riskPercent > 0 
        ? riskPercent 
        : strategy.defaultStopLossPercent;
    
    return buyPrice * (1 - stopLossPercent / 100);
  }

  /// Calculate take profit prices based on strategy
  static List<double> _calculateTakeProfits(
    double buyPrice,
    Strategy strategy,
  ) {
    return strategy.defaultTakeProfitPercents
        .map((percent) => buyPrice * (1 + percent / 100))
        .toList();
  }

  /// Calculate position size based on risk management
  static int calculatePositionSize({
    required double accountSize,
    required double buyPrice,
    required double stopLossPrice,
    required double riskPercent,
  }) {
    // Calculate risk amount willing to lose
    final riskAmount = accountSize * (riskPercent / 100);
    
    // Calculate risk per share
    final riskPerShare = (buyPrice - stopLossPrice).abs();
    
    if (riskPerShare == 0) return 0;
    
    // Calculate maximum shares based on risk
    final maxSharesByRisk = (riskAmount / riskPerShare).floor();
    
    // Convert to lots (1 lot = 1000 shares)
    final lots = (maxSharesByRisk / 1000).floor();
    
    return lots > 0 ? lots : 0;
  }

  /// Validate trade plan
  static bool validateTradePlan(TradePlan plan) {
    // Check if stop loss is below buy price
    if (plan.stopLossPrice >= plan.suggestedBuyPrice) {
      return false;
    }

    // Check if take profit prices are above buy price
    for (final tp in plan.takeProfitPrices) {
      if (tp <= plan.suggestedBuyPrice) {
        return false;
      }
    }

    // Check if shares are positive
    if (plan.maxShares <= 0) {
      return false;
    }

    // Check if total cost doesn't exceed investment amount
    if (plan.totalCost > plan.investAmount * 1.1) {
      // Allow 10% buffer for rounding
      return false;
    }

    return true;
  }

  /// Recalculate trade plan with custom prices
  static TradePlan recalculateWithCustomPrices({
    required TradePlan originalPlan,
    double? customBuyPrice,
    double? customStopLoss,
    List<double>? customTakeProfits,
  }) {
    final buyPrice = customBuyPrice ?? originalPlan.suggestedBuyPrice;
    final stopLoss = customStopLoss ?? originalPlan.stopLossPrice;
    final takeProfits = customTakeProfits ?? originalPlan.takeProfitPrices;

    final maxShares = Calculator.calculateMaxShares(
      originalPlan.investAmount,
      buyPrice,
    );

    final totalCost = Calculator.calculateTotalBuyCost(buyPrice, maxShares);

    final riskAmount = Calculator.calculateRiskAmount(
      buyPrice,
      stopLoss,
      maxShares,
    );

    final riskRewardRatio = Calculator.calculateRiskRewardRatio(
      buyPrice,
      stopLoss,
      takeProfits.isNotEmpty ? takeProfits[0] : buyPrice,
    );

    final expectedReturn = takeProfits.isNotEmpty
        ? ((takeProfits[0] - buyPrice) / buyPrice) * 100
        : 0.0;

    return TradePlan(
      planId: originalPlan.planId,
      stockId: originalPlan.stockId,
      stockName: originalPlan.stockName,
      strategyId: originalPlan.strategyId,
      strategyName: originalPlan.strategyName,
      createdAt: originalPlan.createdAt,
      investAmount: originalPlan.investAmount,
      riskPercent: originalPlan.riskPercent,
      suggestedBuyPrice: buyPrice,
      stopLossPrice: stopLoss,
      takeProfitPrices: takeProfits,
      maxShares: maxShares,
      totalCost: totalCost,
      riskAmount: riskAmount,
      riskRewardRatio: riskRewardRatio,
      expectedReturn: expectedReturn,
    );
  }
}
