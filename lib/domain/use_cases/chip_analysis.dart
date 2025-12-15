import '../../data/models/chip_data.dart';

/// Chip analysis use case for analyzing institutional trading
class ChipAnalysis {
  /// Analyze chip strength based on recent chip data
  static bool isChipStrong(List<ChipData> recentChipData) {
    if (recentChipData.isEmpty) return false;

    // Check if institutional investors are net buyers in recent days
    int strongDays = 0;
    for (final chip in recentChipData) {
      if (chip.isChipStrong) {
        strongDays++;
      }
    }

    // Consider chip strong if more than 60% of recent days are strong
    return strongDays > (recentChipData.length * 0.6);
  }

  /// Calculate average institutional net buy
  static double calculateAverageInstitutionalNetBuy(List<ChipData> chipData) {
    if (chipData.isEmpty) return 0;

    final total = chipData
        .map((chip) => chip.totalInstitutionalNetBuy)
        .reduce((a, b) => a + b);

    return total / chipData.length;
  }

  /// Get chip trend (positive, negative, or neutral)
  static ChipTrend getChipTrend(List<ChipData> chipData) {
    if (chipData.length < 2) return ChipTrend.neutral;

    final recentAvg = calculateAverageInstitutionalNetBuy(
      chipData.sublist((chipData.length / 2).floor()),
    );
    
    final olderAvg = calculateAverageInstitutionalNetBuy(
      chipData.sublist(0, (chipData.length / 2).floor()),
    );

    if (recentAvg > olderAvg * 1.2) {
      return ChipTrend.positive;
    } else if (recentAvg < olderAvg * 0.8) {
      return ChipTrend.negative;
    } else {
      return ChipTrend.neutral;
    }
  }

  /// Analyze foreign investor sentiment
  static InvestorSentiment analyzeForeignInvestorSentiment(
    List<ChipData> chipData,
  ) {
    if (chipData.isEmpty) return InvestorSentiment.neutral;

    final avgNetBuy = chipData
        .map((chip) => chip.foreignInvestorNetBuy)
        .reduce((a, b) => a + b) / chipData.length;

    if (avgNetBuy > 100) {
      return InvestorSentiment.bullish;
    } else if (avgNetBuy < -100) {
      return InvestorSentiment.bearish;
    } else {
      return InvestorSentiment.neutral;
    }
  }
}

/// Chip trend enumeration
enum ChipTrend {
  positive,
  negative,
  neutral,
}

/// Investor sentiment enumeration
enum InvestorSentiment {
  bullish,
  bearish,
  neutral,
}
