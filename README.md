# 股票策略分析 App - Phase 1

## 專案簡介

這是一個專為台灣股市設計的策略分析 App，能夠從 Yahoo Finance 即時取得台股報價，並提供完整的交易計畫計算功能。

## 主要功能

### 1. 股票報價
- 即時從 Yahoo Finance 取得台股報價
- 顯示現價、漲跌、漲跌幅、成交量等資訊
- 支援手動刷新和下拉刷新

### 2. 股票詳情
- 完整的股票資訊展示
- 開盤價、最高價、最低價、昨收價
- 成交量統計

### 3. 交易計畫
- 支援多種策略：
  - 均線支撐策略
  - 突破策略
  - 籌碼轉強策略
  - 費波那契策略
  - 自訂策略
- 自動計算：
  - 建議買入價
  - 止損價格
  - 多層停利價格
  - 可買張數（考慮手續費和交易稅）
  - 風險報酬比
  - 預期報酬

## 專案架構

```
lib/
├── main.dart                          # 應用程式入口
├── app/
│   ├── routes/
│   │   └── app_router.dart           # 路由配置
│   └── theme/
│       └── app_theme.dart            # 主題配置
├── core/
│   ├── constants/
│   │   └── api_constants.dart        # API 常數
│   ├── utils/
│   │   ├── calculator.dart           # 計算工具
│   │   └── formatter.dart            # 格式化工具
│   └── services/
│       ├── api_service.dart          # API 服務
│       ├── data_service.dart         # 資料服務
│       ├── storage_service.dart      # 儲存服務
│       └── notification_service.dart # 通知服務
├── data/
│   ├── models/
│   │   ├── stock.dart               # 股票模型
│   │   ├── kline.dart               # K線模型
│   │   ├── strategy.dart            # 策略模型
│   │   ├── chip_data.dart           # 籌碼模型
│   │   ├── trade_position.dart      # 交易倉位模型
│   │   └── trade_plan.dart          # 交易計畫模型
│   ├── repositories/
│   │   └── stock_repository.dart    # 股票資料倉庫
│   └── data_sources/
│       └── yahoo_finance_data_source.dart  # Yahoo Finance 資料源
├── domain/
│   └── use_cases/
│       ├── trade_calculator.dart    # 交易計算器
│       ├── strategy_analysis.dart   # 策略分析
│       └── chip_analysis.dart       # 籌碼分析
└── presentation/
    ├── screens/
    │   ├── home/
    │   │   └── home_screen.dart     # 首頁
    │   ├── stock_detail/
    │   │   └── stock_detail_screen.dart  # 股票詳情頁
    │   └── trade_plan/
    │       └── trade_plan_screen.dart    # 交易計畫頁
    └── widgets/
        ├── stock_card.dart          # 股票卡片元件
        └── loading_widget.dart      # 載入元件
```

## 技術棧

- **Framework**: Flutter 3.2+
- **狀態管理**: Provider
- **網路請求**: Dio
- **本地儲存**: SharedPreferences, Hive
- **UI 適配**: flutter_screenutil
- **工具庫**: intl, uuid

## 安裝與執行

### 前置需求

- Flutter SDK 3.2.0 或更高版本
- Dart SDK 3.2.0 或更高版本

### 安裝步驟

1. **Clone 專案**
   ```bash
   git clone https://github.com/jack505141/StockAPP.git
   cd StockAPP
   ```

2. **安裝依賴**
   ```bash
   flutter pub get
   ```

3. **執行應用程式**
   ```bash
   flutter run
   ```

### 編譯

- **Android APK**
  ```bash
  flutter build apk --release
  ```

- **iOS**
  ```bash
  flutter build ios --release
  ```

- **Web**
  ```bash
  flutter build web
  ```

## 使用範例

### 1. 查看股票列表

啟動 App 後，首頁會顯示預設的 5 檔台股：
- 2330 台積電
- 2454 聯發科
- 2317 鴻海
- 2412 中華電
- 2308 台達電

### 2. 查看股票詳情

點擊任何一檔股票，即可查看詳細資訊，包括：
- 現價
- 漲跌和漲跌幅
- 開盤價、最高價、最低價
- 昨收價
- 成交量

### 3. 建立交易計畫

在股票詳情頁點擊「建立交易計畫」，然後：
1. 選擇交易策略（預設為均線支撐策略）
2. 輸入投資金額（例如：100,000）
3. 設定風險容忍度（建議 1-5%）
4. 點擊「計算交易計畫」

系統會自動計算並顯示：
- 建議買入價
- 止損價
- 多層停利價格
- 可買張數
- 總成本
- 風險金額
- 風險報酬比
- 預期報酬

## 交易費用計算

- **手續費**: 0.1425%，最低 NT$ 20
- **證券交易稅**: 0.3%（賣出時收取）

## API 資料來源

本專案使用 Yahoo Finance API 取得台股即時報價：
- Base URL: `https://query1.finance.yahoo.com`
- Endpoint: `/v8/finance/chart/{stockId}.TW`

## 開發規範

- 遵循 Flutter/Dart 官方編碼規範
- 使用 `flutter_lints` 進行代碼檢查
- 所有類別和方法都有完整註解
- 使用有意義的變數命名
- 完整的錯誤處理

## 測試流程

1. 啟動 App
2. 首頁顯示 5 檔股票列表
3. 點擊「2330 台積電」
4. 查看完整報價資訊
5. 點擊「建立交易計畫」
6. 選擇「均線支撐策略」
7. 輸入投資金額：100,000
8. 設定風險：2%
9. 點擊「計算」
10. 查看完整的交易計畫結果

## 已知限制

- 目前僅支援台股（股票代碼需加 .TW 後綴）
- Yahoo Finance API 可能有請求限制
- 部分技術指標（MA5、MA10 等）需要歷史資料才能計算
- 籌碼資料需要額外的資料來源

## 未來規劃

- [ ] 新增歷史 K 線圖表
- [ ] 整合籌碼資料
- [ ] 實作技術指標計算
- [ ] 加入自選股管理
- [ ] 實作交易紀錄追蹤
- [ ] 推送通知功能
- [ ] 多語言支援

## 授權

MIT License

## 聯絡方式

如有問題或建議，請開 Issue 或 Pull Request。