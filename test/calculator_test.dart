import 'package:flutter_test/flutter_test.dart';
import 'package:stock_app/core/utils/calculator.dart';
import 'package:stock_app/core/constants/api_constants.dart';

void main() {
  group('Calculator Tests', () {
    test('calculateCommission should calculate correct commission', () {
      // Test amount above minimum
      final commission1 = Calculator.calculateCommission(100000);
      expect(commission1, 142.5); // 100000 * 0.001425

      // Test amount below minimum (should return minimum)
      final commission2 = Calculator.calculateCommission(10000);
      expect(commission2, 20.0); // Minimum commission
    });

    test('calculateTax should calculate correct tax', () {
      final tax = Calculator.calculateTax(100000);
      expect(tax, 300.0); // 100000 * 0.003
    });

    test('calculateTotalBuyCost should include commission', () {
      // Buy 10 lots (10,000 shares) at 100 per share
      final cost = Calculator.calculateTotalBuyCost(100, 10);
      final expectedAmount = 100 * 10 * 1000; // 1,000,000
      final expectedCommission = expectedAmount * 0.001425; // 1,425
      expect(cost, expectedAmount + expectedCommission);
    });

    test('calculateTotalSellRevenue should deduct commission and tax', () {
      // Sell 10 lots (10,000 shares) at 100 per share
      final revenue = Calculator.calculateTotalSellRevenue(100, 10);
      final expectedAmount = 100 * 10 * 1000; // 1,000,000
      final expectedCommission = expectedAmount * 0.001425; // 1,425
      final expectedTax = expectedAmount * 0.003; // 3,000
      expect(revenue, expectedAmount - expectedCommission - expectedTax);
    });

    test('calculateMaxShares should calculate correct maximum shares', () {
      // With 100,000 investment and 50 per share
      final maxShares = Calculator.calculateMaxShares(100000, 50);
      // Should calculate how many lots can be bought considering commission
      expect(maxShares, greaterThan(0));
      
      // Verify the cost doesn't exceed investment
      final actualCost = Calculator.calculateTotalBuyCost(50, maxShares);
      expect(actualCost, lessThanOrEqualTo(100000));
    });

    test('calculateProfitLoss should calculate correct P&L', () {
      // Buy at 100, sell at 110, 10 lots
      final pl = Calculator.calculateProfitLoss(100, 110, 10);
      
      final buyCost = Calculator.calculateTotalBuyCost(100, 10);
      final sellRevenue = Calculator.calculateTotalSellRevenue(110, 10);
      
      expect(pl, sellRevenue - buyCost);
      expect(pl, greaterThan(0)); // Should be profit
    });

    test('calculateProfitLossPercent should calculate correct percentage', () {
      // Buy at 100, sell at 110, 10 lots
      final plPercent = Calculator.calculateProfitLossPercent(100, 110, 10);
      
      expect(plPercent, greaterThan(0)); // Should be positive
      expect(plPercent, lessThan(15)); // Should be less than 15%
    });

    test('calculateRiskRewardRatio should calculate correct ratio', () {
      final ratio = Calculator.calculateRiskRewardRatio(100, 95, 110);
      // Risk: 100 - 95 = 5
      // Reward: 110 - 100 = 10
      // Ratio: 10 / 5 = 2
      expect(ratio, 2.0);
    });
  });

  group('TradingConstants Tests', () {
    test('Trading constants should have correct values', () {
      expect(TradingConstants.commissionRate, 0.001425);
      expect(TradingConstants.minCommission, 20.0);
      expect(TradingConstants.transactionTax, 0.003);
      expect(TradingConstants.sharesPerLot, 1000);
    });
  });
}
