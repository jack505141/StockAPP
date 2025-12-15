import 'package:flutter_test/flutter_test.dart';
import 'package:stock_app/data/models/stock.dart';
import 'package:stock_app/data/models/strategy.dart';
import 'package:stock_app/domain/use_cases/trade_calculator.dart';

void main() {
  group('TradeCalculator Tests', () {
    late Stock testStock;

    setUp(() {
      testStock = Stock(
        stockId: '2330',
        stockName: '台積電',
        currentPrice: 580.0,
        changePrice: 5.0,
        changePercent: 0.87,
        volume: 25000000,
        open: 575.0,
        high: 582.0,
        low: 574.0,
        close: 580.0,
        yesterdayClose: 575.0,
        updateTime: DateTime.now(),
        ma20: 570.0,
        ma60: 560.0,
      );
    });

    test('calculateTradePlan should generate valid trade plan', () {
      final strategy = Strategy.getMaSupport();
      final plan = TradeCalculator.calculateTradePlan(
        stock: testStock,
        strategy: strategy,
        investAmount: 100000,
        riskPercent: 2.0,
      );

      expect(plan.stockId, '2330');
      expect(plan.stockName, '台積電');
      expect(plan.strategyId, strategy.strategyId);
      expect(plan.investAmount, 100000);
      expect(plan.riskPercent, 2.0);
      expect(plan.suggestedBuyPrice, greaterThan(0));
      expect(plan.stopLossPrice, lessThan(plan.suggestedBuyPrice));
      expect(plan.maxShares, greaterThan(0));
      expect(plan.totalCost, lessThanOrEqualTo(100000));
      expect(plan.takeProfitPrices.length, greaterThan(0));
    });

    test('calculateTradePlan with MA Support strategy', () {
      final strategy = Strategy.getMaSupport();
      final plan = TradeCalculator.calculateTradePlan(
        stock: testStock,
        strategy: strategy,
        investAmount: 100000,
        riskPercent: 2.0,
      );

      // MA Support strategy should suggest buy near MA20 or slightly below current price
      expect(plan.suggestedBuyPrice, lessThanOrEqualTo(testStock.currentPrice * 1.01));
      expect(plan.stopLossPrice, lessThan(plan.suggestedBuyPrice));
    });

    test('calculateTradePlan with Breakout strategy', () {
      final strategy = Strategy.getBreakout();
      final plan = TradeCalculator.calculateTradePlan(
        stock: testStock,
        strategy: strategy,
        investAmount: 100000,
        riskPercent: 3.0,
      );

      expect(plan.riskPercent, 3.0);
      expect(plan.stopLossPrice, lessThan(plan.suggestedBuyPrice));
    });

    test('validateTradePlan should return true for valid plan', () {
      final strategy = Strategy.getMaSupport();
      final plan = TradeCalculator.calculateTradePlan(
        stock: testStock,
        strategy: strategy,
        investAmount: 100000,
        riskPercent: 2.0,
      );

      final isValid = TradeCalculator.validateTradePlan(plan);
      expect(isValid, true);
    });

    test('calculatePositionSize should calculate correct size', () {
      final size = TradeCalculator.calculatePositionSize(
        accountSize: 1000000,
        buyPrice: 580.0,
        stopLossPrice: 570.0,
        riskPercent: 2.0,
      );

      expect(size, greaterThanOrEqualTo(0));
    });

    test('recalculateWithCustomPrices should update plan correctly', () {
      final strategy = Strategy.getMaSupport();
      final originalPlan = TradeCalculator.calculateTradePlan(
        stock: testStock,
        strategy: strategy,
        investAmount: 100000,
        riskPercent: 2.0,
      );

      final newPlan = TradeCalculator.recalculateWithCustomPrices(
        originalPlan: originalPlan,
        customBuyPrice: 575.0,
        customStopLoss: 565.0,
      );

      expect(newPlan.suggestedBuyPrice, 575.0);
      expect(newPlan.stopLossPrice, 565.0);
      expect(newPlan.planId, originalPlan.planId); // Should keep same ID
    });

    test('take profit prices should be in ascending order', () {
      final strategy = Strategy.getMaSupport();
      final plan = TradeCalculator.calculateTradePlan(
        stock: testStock,
        strategy: strategy,
        investAmount: 100000,
        riskPercent: 2.0,
      );

      for (int i = 0; i < plan.takeProfitPrices.length - 1; i++) {
        expect(
          plan.takeProfitPrices[i],
          lessThan(plan.takeProfitPrices[i + 1]),
        );
      }
    });

    test('risk reward ratio should be positive', () {
      final strategy = Strategy.getMaSupport();
      final plan = TradeCalculator.calculateTradePlan(
        stock: testStock,
        strategy: strategy,
        investAmount: 100000,
        riskPercent: 2.0,
      );

      expect(plan.riskRewardRatio, greaterThan(0));
    });
  });
}
