import '../../data/models/stock.dart';
import '../../data/models/strategy.dart';

/// Strategy analysis use case
class StrategyAnalysis {
  /// Analyze which strategies are suitable for a given stock
  static List<Strategy> analyzeStrategies(Stock stock) {
    final suitableStrategies = <Strategy>[];

    // MA Support Strategy - suitable if MA data is available
    if (stock.ma20 != null && stock.currentPrice <= stock.ma20! * 1.05) {
      suitableStrategies.add(Strategy.getMaSupport());
    }

    // Breakout Strategy - suitable if near resistance
    if (stock.resistancePrice != null && 
        stock.currentPrice >= stock.resistancePrice! * 0.98) {
      suitableStrategies.add(Strategy.getBreakout());
    }

    // Chip Strong Strategy - always available
    suitableStrategies.add(Strategy.getChipStrong());

    // Fibonacci Strategy - suitable if high/low range is significant
    if ((stock.high - stock.low) / stock.currentPrice > 0.02) {
      suitableStrategies.add(Strategy.getFibonacci());
    }

    // Custom Strategy - always available
    suitableStrategies.add(Strategy.getCustom());

    return suitableStrategies;
  }

  /// Calculate strategy score based on current market conditions
  static double calculateStrategyScore(Stock stock, Strategy strategy) {
    double score = 50.0; // Base score

    switch (strategy.strategyType) {
      case StrategyType.maSupport:
        if (stock.ma20 != null) {
          final distanceFromMA = ((stock.currentPrice - stock.ma20!) / stock.ma20!).abs();
          score += (1 - distanceFromMA) * 50; // Closer to MA = higher score
        }
        break;
      
      case StrategyType.breakout:
        if (stock.resistancePrice != null) {
          if (stock.currentPrice >= stock.resistancePrice!) {
            score += 30;
          }
        }
        break;
      
      case StrategyType.chipStrong:
        // Score based on volume
        score += 20;
        break;
      
      case StrategyType.fibonacci:
        score += 15;
        break;
      
      case StrategyType.custom:
        score = 50.0;
        break;
    }

    return score.clamp(0, 100);
  }
}
