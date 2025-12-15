# 使用範例

本文件提供股票策略分析 App 核心功能的使用範例。

## 1. 取得股票報價

### 單一股票查詢

```dart
import 'package:stock_app/data/repositories/stock_repository.dart';

void main() async {
  final repository = StockRepository();
  
  try {
    // 查詢台積電股價
    final stock = await repository.getStockQuote('2330', '台積電');
    
    print('股票代號: ${stock.stockId}');
    print('股票名稱: ${stock.stockName}');
    print('現價: ${stock.currentPrice}');
    print('漲跌: ${stock.changePrice}');
    print('漲跌幅: ${stock.changePercent}%');
    print('成交量: ${stock.volume}');
  } catch (e) {
    print('查詢失敗: $e');
  }
}
```

### 批次查詢多檔股票

```dart
import 'package:stock_app/data/repositories/stock_repository.dart';

void main() async {
  final repository = StockRepository();
  
  final stockMap = {
    '2330': '台積電',
    '2454': '聯發科',
    '2317': '鴻海',
  };
  
  try {
    final stocks = await repository.getMultipleStockQuotes(stockMap);
    
    for (final stock in stocks) {
      print('${stock.stockId} ${stock.stockName}: ${stock.currentPrice}');
    }
  } catch (e) {
    print('查詢失敗: $e');
  }
}
```

### 使用預設股票清單

```dart
import 'package:stock_app/data/repositories/stock_repository.dart';

void main() async {
  final repository = StockRepository();
  
  try {
    // 取得預設的5檔台股
    final stocks = await repository.getDefaultStockList();
    
    for (final stock in stocks) {
      print('${stock.stockId} ${stock.stockName}');
      print('現價: ${stock.currentPrice}');
      print('漲跌: ${stock.changePrice} (${stock.changePercent}%)');
      print('---');
    }
  } catch (e) {
    print('查詢失敗: $e');
  }
}
```

## 2. 建立交易計畫

### 基礎使用

```dart
import 'package:stock_app/data/models/stock.dart';
import 'package:stock_app/data/models/strategy.dart';
import 'package:stock_app/domain/use_cases/trade_calculator.dart';

void main() {
  // 建立股票物件
  final stock = Stock(
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
  );
  
  // 選擇策略
  final strategy = Strategy.getMaSupport();
  
  // 計算交易計畫
  final plan = TradeCalculator.calculateTradePlan(
    stock: stock,
    strategy: strategy,
    investAmount: 100000,  // 投資10萬元
    riskPercent: 2.0,      // 風險2%
  );
  
  // 顯示結果
  print('=== 交易計畫 ===');
  print('股票: ${plan.stockId} ${plan.stockName}');
  print('策略: ${plan.strategyName}');
  print('建議買入價: ${plan.suggestedBuyPrice}');
  print('止損價: ${plan.stopLossPrice}');
  print('停利目標: ${plan.takeProfitPrices}');
  print('可買張數: ${plan.maxShares}');
  print('總成本: ${plan.totalCost}');
  print('風險金額: ${plan.riskAmount}');
  print('風險報酬比: 1:${plan.riskRewardRatio.toStringAsFixed(2)}');
  print('預期報酬: ${plan.expectedReturn.toStringAsFixed(2)}%');
}
```

### 使用不同策略

```dart
import 'package:stock_app/data/models/strategy.dart';
import 'package:stock_app/domain/use_cases/trade_calculator.dart';

void compareStrategies(Stock stock, double investAmount) {
  final strategies = [
    Strategy.getMaSupport(),
    Strategy.getBreakout(),
    Strategy.getChipStrong(),
    Strategy.getFibonacci(),
  ];
  
  print('=== 策略比較 ===');
  for (final strategy in strategies) {
    final plan = TradeCalculator.calculateTradePlan(
      stock: stock,
      strategy: strategy,
      investAmount: investAmount,
      riskPercent: 2.0,
    );
    
    print('\n策略: ${strategy.strategyName}');
    print('建議買入價: ${plan.suggestedBuyPrice}');
    print('風險報酬比: 1:${plan.riskRewardRatio.toStringAsFixed(2)}');
    print('預期報酬: ${plan.expectedReturn.toStringAsFixed(2)}%');
  }
}
```

## 3. 交易費用計算

### 計算買入成本

```dart
import 'package:stock_app/core/utils/calculator.dart';

void main() {
  // 買入價格 580 元，10 張（10,000 股）
  final buyPrice = 580.0;
  final shares = 10;
  
  // 計算總成本（含手續費）
  final totalCost = Calculator.calculateTotalBuyCost(buyPrice, shares);
  
  print('買入價格: $buyPrice 元');
  print('買入張數: $shares 張');
  print('總成本: ${totalCost.toStringAsFixed(2)} 元');
  
  // 分解計算
  final amount = buyPrice * shares * 1000;
  final commission = Calculator.calculateCommission(amount);
  print('金額: ${amount.toStringAsFixed(2)} 元');
  print('手續費: ${commission.toStringAsFixed(2)} 元');
}
```

### 計算賣出收入

```dart
import 'package:stock_app/core/utils/calculator.dart';

void main() {
  // 賣出價格 600 元，10 張
  final sellPrice = 600.0;
  final shares = 10;
  
  // 計算實收金額（扣除手續費和交易稅）
  final revenue = Calculator.calculateTotalSellRevenue(sellPrice, shares);
  
  print('賣出價格: $sellPrice 元');
  print('賣出張數: $shares 張');
  print('實收金額: ${revenue.toStringAsFixed(2)} 元');
  
  // 分解計算
  final amount = sellPrice * shares * 1000;
  final commission = Calculator.calculateCommission(amount);
  final tax = Calculator.calculateTax(amount);
  print('金額: ${amount.toStringAsFixed(2)} 元');
  print('手續費: ${commission.toStringAsFixed(2)} 元');
  print('交易稅: ${tax.toStringAsFixed(2)} 元');
}
```

### 計算損益

```dart
import 'package:stock_app/core/utils/calculator.dart';

void main() {
  final buyPrice = 580.0;
  final sellPrice = 600.0;
  final shares = 10;
  
  // 計算絕對損益
  final pl = Calculator.calculateProfitLoss(buyPrice, sellPrice, shares);
  
  // 計算損益百分比
  final plPercent = Calculator.calculateProfitLossPercent(
    buyPrice,
    sellPrice,
    shares,
  );
  
  print('買入價格: $buyPrice 元');
  print('賣出價格: $sellPrice 元');
  print('交易張數: $shares 張');
  print('損益: ${pl.toStringAsFixed(2)} 元');
  print('損益%: ${plPercent.toStringAsFixed(2)}%');
}
```

## 4. 計算最大可買張數

```dart
import 'package:stock_app/core/utils/calculator.dart';

void main() {
  final investAmount = 100000.0;  // 投資金額 10 萬
  final stockPrice = 580.0;       // 股價 580 元
  
  // 計算最大可買張數（考慮手續費）
  final maxShares = Calculator.calculateMaxShares(investAmount, stockPrice);
  
  // 計算實際成本
  final actualCost = Calculator.calculateTotalBuyCost(stockPrice, maxShares);
  
  print('投資金額: ${investAmount.toStringAsFixed(2)} 元');
  print('股價: $stockPrice 元');
  print('最大可買: $maxShares 張');
  print('實際成本: ${actualCost.toStringAsFixed(2)} 元');
  print('剩餘金額: ${(investAmount - actualCost).toStringAsFixed(2)} 元');
}
```

## 5. 格式化輸出

### 使用 Formatter 格式化資料

```dart
import 'package:stock_app/core/utils/formatter.dart';

void main() {
  // 價格格式化
  final price = 580.5;
  print('價格: ${Formatter.formatPrice(price)}');  // 580.50
  
  // 貨幣格式化
  print('金額: ${Formatter.formatCurrency(price)}');  // NT$ 580.50
  
  // 百分比格式化
  final percent = 0.87;
  print('漲跌幅: ${Formatter.formatPercent(percent)}');  // +0.87%
  
  // 成交量格式化（股轉張）
  final volume = 25000000;
  print('成交量: ${Formatter.formatVolume(volume)}張');  // 25,000張
  
  // 漲跌格式化
  final change = 5.0;
  print('漲跌: ${Formatter.formatChange(change)}');  // +5.00
  
  // 日期格式化
  final now = DateTime.now();
  print('日期: ${Formatter.formatDate(now)}');  // 2024-01-01
  print('時間: ${Formatter.formatDateTime(now)}');  // 2024-01-01 12:00:00
  
  // 風險報酬比格式化
  final ratio = 1.5;
  print('風險報酬比: ${Formatter.formatRiskRewardRatio(ratio)}');  // 1:1.50
}
```

## 6. 本地儲存

### 使用 StorageService

```dart
import 'package:stock_app/core/services/storage_service.dart';

void main() async {
  final storage = StorageService();
  await storage.init();
  
  // 儲存自選股
  final favorites = ['2330', '2454', '2317'];
  await storage.saveFavoriteStocks(favorites);
  
  // 讀取自選股
  final savedFavorites = storage.getFavoriteStocks();
  print('自選股: $savedFavorites');
  
  // 新增自選股
  await storage.addToFavorites('2412');
  
  // 移除自選股
  await storage.removeFromFavorites('2317');
  
  // 檢查是否在自選股中
  final isFavorite = storage.getFavoriteStocks().contains('2330');
  print('2330 是否在自選股: $isFavorite');
}
```

## 7. 策略分析

### 分析適合的策略

```dart
import 'package:stock_app/data/models/stock.dart';
import 'package:stock_app/domain/use_cases/strategy_analysis.dart';

void main() {
  final stock = Stock(
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
  
  // 分析適合的策略
  final strategies = StrategyAnalysis.analyzeStrategies(stock);
  
  print('適合的策略:');
  for (final strategy in strategies) {
    final score = StrategyAnalysis.calculateStrategyScore(stock, strategy);
    print('${strategy.strategyName}: ${score.toStringAsFixed(2)} 分');
  }
}
```

## 8. 完整範例：從查詢到計畫

```dart
import 'package:stock_app/data/repositories/stock_repository.dart';
import 'package:stock_app/data/models/strategy.dart';
import 'package:stock_app/domain/use_cases/trade_calculator.dart';
import 'package:stock_app/core/utils/formatter.dart';

void main() async {
  // 1. 查詢股票
  print('=== 步驟 1: 查詢股票 ===');
  final repository = StockRepository();
  
  try {
    final stock = await repository.getStockQuote('2330', '台積電');
    print('${stock.stockId} ${stock.stockName}');
    print('現價: ${Formatter.formatCurrency(stock.currentPrice)}');
    print('漲跌: ${Formatter.formatChange(stock.changePrice)} (${Formatter.formatPercent(stock.changePercent)})');
    
    // 2. 選擇策略
    print('\n=== 步驟 2: 選擇策略 ===');
    final strategy = Strategy.getMaSupport();
    print('策略: ${strategy.strategyName}');
    print('描述: ${strategy.description}');
    
    // 3. 計算交易計畫
    print('\n=== 步驟 3: 計算交易計畫 ===');
    final plan = TradeCalculator.calculateTradePlan(
      stock: stock,
      strategy: strategy,
      investAmount: 100000,
      riskPercent: 2.0,
    );
    
    print('投資金額: ${Formatter.formatCurrency(plan.investAmount)}');
    print('建議買入價: ${Formatter.formatCurrency(plan.suggestedBuyPrice)}');
    print('止損價: ${Formatter.formatCurrency(plan.stopLossPrice)}');
    print('停利價:');
    for (int i = 0; i < plan.takeProfitPrices.length; i++) {
      print('  停利${i + 1}: ${Formatter.formatCurrency(plan.takeProfitPrices[i])}');
    }
    print('可買張數: ${Formatter.formatShares(plan.maxShares)}');
    print('總成本: ${Formatter.formatCurrency(plan.totalCost)}');
    print('風險金額: ${Formatter.formatCurrency(plan.riskAmount)}');
    print('風險報酬比: ${Formatter.formatRiskRewardRatio(plan.riskRewardRatio)}');
    print('預期報酬: ${Formatter.formatPercent(plan.expectedReturn)}');
    
    // 4. 驗證計畫
    print('\n=== 步驟 4: 驗證計畫 ===');
    final isValid = TradeCalculator.validateTradePlan(plan);
    print('計畫有效性: ${isValid ? "✓ 有效" : "✗ 無效"}');
    
  } catch (e) {
    print('錯誤: $e');
  }
}
```

## 注意事項

1. **網路連接**: 查詢股票資料需要網路連接
2. **API 限制**: Yahoo Finance API 可能有請求頻率限制
3. **資料延遲**: 股票資料可能有幾分鐘的延遲
4. **費用計算**: 實際交易費用可能因券商而異
5. **風險提示**: 本 App 僅供參考，不構成投資建議

## 更多資源

- [API 文件](ARCHITECTURE.md)
- [貢獻指南](CONTRIBUTING.md)
- [常見問題](README.md)
