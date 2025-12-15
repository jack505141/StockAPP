import '../constants/api_constants.dart';

/// Utility class for financial calculations
class Calculator {
  /// Calculate moving average
  static double calculateMA(List<double> prices, int period) {
    if (prices.length < period) {
      throw Exception('Not enough data points for MA calculation');
    }
    
    final relevantPrices = prices.sublist(prices.length - period);
    final sum = relevantPrices.reduce((a, b) => a + b);
    return sum / period;
  }

  /// Calculate RSI (Relative Strength Index)
  static double calculateRSI(List<double> prices, int period) {
    if (prices.length < period + 1) {
      throw Exception('Not enough data points for RSI calculation');
    }

    double gainSum = 0;
    double lossSum = 0;

    for (int i = prices.length - period; i < prices.length; i++) {
      final change = prices[i] - prices[i - 1];
      if (change > 0) {
        gainSum += change;
      } else {
        lossSum += change.abs();
      }
    }

    final avgGain = gainSum / period;
    final avgLoss = lossSum / period;

    if (avgLoss == 0) return 100;

    final rs = avgGain / avgLoss;
    return 100 - (100 / (1 + rs));
  }

  /// Calculate support price based on recent lows
  static double calculateSupport(List<double> recentLows) {
    if (recentLows.isEmpty) return 0;
    return recentLows.reduce((a, b) => a < b ? a : b);
  }

  /// Calculate resistance price based on recent highs
  static double calculateResistance(List<double> recentHighs) {
    if (recentHighs.isEmpty) return 0;
    return recentHighs.reduce((a, b) => a > b ? a : b);
  }

  /// Calculate commission for a transaction
  static double calculateCommission(double amount) {
    return TradingConstants.calculateCommission(amount);
  }

  /// Calculate transaction tax for selling
  static double calculateTax(double amount) {
    return TradingConstants.calculateTax(amount);
  }

  /// Calculate total cost for buying stocks
  static double calculateTotalBuyCost(double price, int shares) {
    return TradingConstants.calculateBuyCost(price, shares);
  }

  /// Calculate total revenue for selling stocks
  static double calculateTotalSellRevenue(double price, int shares) {
    return TradingConstants.calculateSellRevenue(price, shares);
  }

  /// Calculate profit/loss
  static double calculateProfitLoss(
    double buyPrice,
    double sellPrice,
    int shares,
  ) {
    final buyCost = calculateTotalBuyCost(buyPrice, shares);
    final sellRevenue = calculateTotalSellRevenue(sellPrice, shares);
    return sellRevenue - buyCost;
  }

  /// Calculate profit/loss percentage
  static double calculateProfitLossPercent(
    double buyPrice,
    double sellPrice,
    int shares,
  ) {
    final buyCost = calculateTotalBuyCost(buyPrice, shares);
    final profitLoss = calculateProfitLoss(buyPrice, sellPrice, shares);
    return (profitLoss / buyCost) * 100;
  }

  /// Calculate maximum shares that can be bought with given amount
  static int calculateMaxShares(double investAmount, double pricePerShare) {
    if (pricePerShare <= 0) return 0;
    
    // Binary search for maximum shares
    int left = 0;
    int right = (investAmount / (pricePerShare * TradingConstants.sharesPerLot)).floor();
    int maxShares = 0;

    while (left <= right) {
      final mid = (left + right) ~/ 2;
      final cost = calculateTotalBuyCost(pricePerShare, mid);
      
      if (cost <= investAmount) {
        maxShares = mid;
        left = mid + 1;
      } else {
        right = mid - 1;
      }
    }

    return maxShares;
  }

  /// Calculate risk amount based on stop loss
  static double calculateRiskAmount(
    double buyPrice,
    double stopLossPrice,
    int shares,
  ) {
    final buyCost = calculateTotalBuyCost(buyPrice, shares);
    final stopLossRevenue = calculateTotalSellRevenue(stopLossPrice, shares);
    return buyCost - stopLossRevenue;
  }

  /// Calculate risk reward ratio
  static double calculateRiskRewardRatio(
    double buyPrice,
    double stopLossPrice,
    double takeProfitPrice,
  ) {
    final risk = (buyPrice - stopLossPrice).abs();
    final reward = (takeProfitPrice - buyPrice).abs();
    
    if (risk == 0) return 0;
    return reward / risk;
  }
}
