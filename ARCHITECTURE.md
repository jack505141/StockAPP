# 股票策略分析 App - 架構說明

## 架構概述

本專案採用 **Clean Architecture** 架構模式，將應用程式分為三個主要層級：

1. **Presentation Layer（展示層）**: UI 元件和畫面
2. **Domain Layer（領域層）**: 業務邏輯和用例
3. **Data Layer（資料層）**: 資料模型、資料源和資料倉庫

## 目錄結構說明

### 1. `lib/app/` - 應用程式配置

#### `routes/app_router.dart`
- 集中管理應用程式的路由
- 提供靜態方法進行頁面導航
- 支援帶參數的路由傳遞

#### `theme/app_theme.dart`
- 定義亮色和暗色主題
- 統一管理顏色、字體和樣式
- 提供漲跌顏色判斷功能

### 2. `lib/core/` - 核心功能

#### `constants/api_constants.dart`
定義所有常數：
- Yahoo Finance API URLs
- 交易手續費率和交易稅率
- 本地儲存的 Key 值
- 交易費用計算函數

#### `utils/calculator.dart`
金融計算工具類：
- 移動平均線（MA）計算
- RSI 技術指標計算
- 支撐/壓力位計算
- 手續費和交易稅計算
- 最大可買張數計算
- 損益計算

#### `utils/formatter.dart`
格式化工具類：
- 價格格式化（兩位小數）
- 百分比格式化
- 成交量格式化（張）
- 貨幣格式化（NT$）
- 日期時間格式化

#### `services/api_service.dart`
- 封裝 Dio HTTP 客戶端
- 提供 GET/POST 請求方法
- 統一錯誤處理

#### `services/data_service.dart`
- 高層級的資料服務
- 整合多個資料倉庫
- 提供簡化的資料存取介面

#### `services/storage_service.dart`
- 封裝 SharedPreferences
- 提供 Key-Value 儲存
- 管理自選股清單

#### `services/notification_service.dart`
- 通知服務介面（預留）
- 未來支援價格提醒

### 3. `lib/data/` - 資料層

#### `models/` - 資料模型

**stock.dart** - 股票模型
```dart
class Stock {
  - stockId: 股票代號（如 "2330"）
  - stockName: 股票名稱
  - currentPrice: 現價
  - changePrice: 漲跌
  - changePercent: 漲跌幅%
  - volume: 成交量
  - open/high/low/close: OHLC 價格
  - yesterdayClose: 昨收
  - ma5/ma10/ma20/ma60: 移動平均線（可選）
  - rsi: RSI 指標（可選）
  
  主要方法：
  - fromYahooJson(): 從 Yahoo Finance API 解析
  - fromJson/toJson(): JSON 序列化
  - copyWith(): 複製並更新欄位
}
```

**strategy.dart** - 策略模型
```dart
enum StrategyType {
  maSupport,      // 均線支撐策略
  breakout,       // 突破策略
  chipStrong,     // 籌碼轉強策略
  fibonacci,      // 費波那契策略
  custom,         // 自訂策略
}

class Strategy {
  - strategyId: 策略 ID
  - strategyName: 策略名稱
  - strategyType: 策略類型
  - defaultStopLossPercent: 預設止損百分比
  - defaultTakeProfitPercents: 預設停利百分比列表
  - useTrailingStop: 是否使用移動止損
  - suggestedRiskPercent: 建議風險百分比
  
  預定義策略：
  - getMaSupport(): 均線支撐策略
  - getBreakout(): 突破策略
  - getChipStrong(): 籌碼轉強策略
  - getFibonacci(): 費波那契策略
  - getCustom(): 自訂策略
}
```

**trade_plan.dart** - 交易計畫模型
```dart
class TradePlan {
  - planId: 計畫 ID
  - stockId/stockName: 股票資訊
  - strategyId/strategyName: 策略資訊
  - investAmount: 投資金額
  - riskPercent: 風險百分比
  - suggestedBuyPrice: 建議買入價
  - stopLossPrice: 止損價
  - takeProfitPrices: 停利價格列表
  - maxShares: 最大可買張數
  - totalCost: 總成本
  - riskAmount: 風險金額
  - riskRewardRatio: 風險報酬比
  - expectedReturn: 預期報酬百分比
}
```

**trade_position.dart** - 交易倉位模型
```dart
enum PositionStatus {
  holding,           // 持有中
  takeProfitClosed, // 已停利
  stopLossClosed,   // 已停損
  manuallyClosed,   // 手動平倉
}

class TakeProfit {
  - price: 停利價格
  - percent: 停利百分比
  - sellRatio: 賣出比例
  - isAchieved: 是否已達成
}

class TradePosition {
  - positionId: 部位 ID
  - buyPrice: 買入價格
  - shares: 持有張數
  - stopLossPrice: 止損價格
  - takeProfits: 停利目標列表
  - currentPrice: 當前價格
  - unrealizedPL: 未實現損益
  - status: 部位狀態
}
```

**kline.dart** - K線模型
```dart
class KLine {
  - timestamp: 時間戳
  - open/high/low/close: OHLC 價格
  - volume: 成交量
  
  計算屬性：
  - isBullish: 是否為陽線
  - isBearish: 是否為陰線
  - bodySize: 實體大小
  - upperShadow/lowerShadow: 上下影線
}
```

**chip_data.dart** - 籌碼資料模型
```dart
class ChipData {
  - date: 日期
  - stockId: 股票代號
  - foreignInvestorNetBuy: 外資買賣超
  - investmentTrustNetBuy: 投信買賣超
  - dealerNetBuy: 自營商買賣超
  - marginPurchaseChange: 融資增減
  - shortSaleChange: 融券增減
  
  計算屬性：
  - totalInstitutionalNetBuy: 三大法人合計
  - isChipStrong: 籌碼是否轉強
}
```

#### `data_sources/yahoo_finance_data_source.dart`
- 封裝 Yahoo Finance API 呼叫
- 提供股票報價查詢
- 支援批次查詢多檔股票
- 提供歷史資料查詢

#### `repositories/stock_repository.dart`
- 資料倉庫模式
- 整合資料源
- 提供統一的資料存取介面
- 錯誤處理和資料轉換

### 4. `lib/domain/` - 領域層

#### `use_cases/trade_calculator.dart`
交易計算器核心邏輯：

**主要功能：**
1. `calculateTradePlan()` - 計算完整交易計畫
   - 根據策略計算建議買入價
   - 計算止損價格
   - 計算多層停利價格
   - 計算可買張數（考慮手續費）
   - 計算風險報酬比

2. `calculatePositionSize()` - 計算部位大小
   - 基於風險管理計算
   - 考慮帳戶規模和風險承受度

3. `validateTradePlan()` - 驗證交易計畫
   - 檢查止損價是否合理
   - 檢查停利價是否合理
   - 檢查成本是否超過投資金額

4. `recalculateWithCustomPrices()` - 自訂價格重新計算

**策略買入價計算邏輯：**
- **MA Support**: 建議在 MA20 附近買入
- **Breakout**: 建議在壓力位上方買入
- **Chip Strong**: 建議當前價買入
- **Fibonacci**: 建議在 0.618 回撤位買入
- **Custom**: 使用當前價

#### `use_cases/strategy_analysis.dart`
策略分析用例：
- `analyzeStrategies()` - 分析適合的策略
- `calculateStrategyScore()` - 計算策略評分

#### `use_cases/chip_analysis.dart`
籌碼分析用例：
- `isChipStrong()` - 判斷籌碼是否轉強
- `calculateAverageInstitutionalNetBuy()` - 計算法人平均買超
- `getChipTrend()` - 取得籌碼趨勢
- `analyzeForeignInvestorSentiment()` - 分析外資情緒

### 5. `lib/presentation/` - 展示層

#### `screens/home/home_screen.dart`
首頁畫面：
- 顯示預設股票列表（2330, 2454, 2317, 2412, 2308）
- 支援下拉刷新
- 點擊進入股票詳情頁
- 錯誤處理和載入狀態顯示

#### `screens/stock_detail/stock_detail_screen.dart`
股票詳情頁：
- 顯示完整股票資訊
- 價格卡片：現價、漲跌、漲跌幅
- 市場資訊卡片：開高低收、成交量
- 支援手動刷新
- 「建立交易計畫」按鈕

#### `screens/trade_plan/trade_plan_screen.dart`
交易計畫頁：
- 策略選擇下拉選單
- 投資參數輸入（金額、風險）
- 計算按鈕
- 計算結果顯示：
  - 建議買入價
  - 止損價
  - 多層停利價
  - 可買張數
  - 總成本
  - 風險金額
  - 風險報酬比
  - 預期報酬

#### `widgets/stock_card.dart`
股票卡片元件：
- 顯示股票代號和名稱
- 顯示現價和漲跌
- 顏色標示（漲紅跌綠）
- 支援點擊事件

#### `widgets/loading_widget.dart`
載入元件：
- 顯示載入動畫
- 可選的載入訊息
- 小型載入指示器變體

## 資料流向

```
User Action (UI)
    ↓
Screen (Presentation Layer)
    ↓
Use Case (Domain Layer)
    ↓
Repository (Data Layer)
    ↓
Data Source (Data Layer)
    ↓
External API (Yahoo Finance)
```

## 交易費用計算

### 買入成本
```
總成本 = (股價 × 張數 × 1000) + 手續費
手續費 = max(金額 × 0.001425, 20)
```

### 賣出收入
```
實收金額 = (股價 × 張數 × 1000) - 手續費 - 交易稅
手續費 = max(金額 × 0.001425, 20)
交易稅 = 金額 × 0.003
```

## Yahoo Finance API

### API Endpoint
```
GET https://query1.finance.yahoo.com/v8/finance/chart/{stockId}.TW
Query Parameters:
- interval: 1d (日線)
- range: 1d (當日資料)
```

### 回應結構
```json
{
  "chart": {
    "result": [{
      "meta": {
        "regularMarketPrice": 580.0,
        "chartPreviousClose": 575.0,
        "regularMarketOpen": 575.0,
        "regularMarketDayHigh": 582.0,
        "regularMarketDayLow": 574.0,
        "regularMarketVolume": 25000000
      }
    }]
  }
}
```

## 測試策略

### 單元測試
- `test/calculator_test.dart` - 測試計算工具
- `test/trade_calculator_test.dart` - 測試交易計算器
- `test/stock_model_test.dart` - 測試股票模型

### 測試覆蓋
- 模型的 JSON 序列化/反序列化
- 交易費用計算
- 風險報酬比計算
- 最大可買張數計算
- Yahoo Finance 資料解析

## 設計原則

1. **單一職責原則 (SRP)**: 每個類別只負責一件事
2. **依賴反轉原則 (DIP)**: 依賴於抽象而非具體實作
3. **開放封閉原則 (OCP)**: 對擴展開放，對修改封閉
4. **介面隔離原則 (ISP)**: 使用小而專注的介面
5. **關注點分離**: UI、業務邏輯、資料存取分離

## 未來擴展方向

1. **技術指標計算**: 實作更多技術指標（MACD、KD、布林通道等）
2. **籌碼資料整合**: 整合三大法人買賣超資料
3. **回測功能**: 策略回測和績效分析
4. **通知功能**: 價格提醒和策略信號通知
5. **多帳戶管理**: 支援多個交易帳戶
6. **交易日記**: 記錄交易決策和心得
