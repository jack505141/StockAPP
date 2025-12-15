# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-12-15

### Added - Phase 1 完成

#### 專案架構
- 建立完整的 Clean Architecture 專案結構
- 設定 Flutter 專案配置（pubspec.yaml, analysis_options.yaml）
- 建立 Android、iOS、Web 平台配置

#### 資料模型
- **Stock 模型**: 完整的股票資料模型，支援 Yahoo Finance API 資料解析
- **Strategy 模型**: 五種預定義交易策略（均線支撐、突破、籌碼轉強、費波那契、自訂）
- **TradePlan 模型**: 交易計畫模型，包含買入價、止損、停利、風險報酬比等
- **TradePosition 模型**: 交易倉位模型，支援多層停利和移動止損
- **KLine 模型**: K線資料模型，包含 OHLC 和成交量
- **ChipData 模型**: 籌碼資料模型，支援三大法人買賣超分析

#### API 整合
- Yahoo Finance API 整合，支援台股即時報價查詢
- 批次查詢多檔股票功能
- 完整的錯誤處理和超時機制

#### 核心功能
- **TradeCalculator**: 交易計算器
  - 根據策略計算建議買入價
  - 計算止損價格
  - 計算多層停利價格
  - 計算最大可買張數（考慮手續費）
  - 計算風險報酬比和預期報酬
- **Calculator**: 金融計算工具
  - 手續費計算（0.1425%，最低 $20）
  - 交易稅計算（0.3%）
  - 買入成本計算
  - 賣出收入計算
  - 損益計算
  - 技術指標計算（MA, RSI）
- **Formatter**: 格式化工具
  - 價格、金額、百分比格式化
  - 成交量格式化（張）
  - 日期時間格式化

#### 業務邏輯
- **StrategyAnalysis**: 策略分析用例，評估適合的交易策略
- **ChipAnalysis**: 籌碼分析用例，分析法人動向和籌碼強弱

#### 服務層
- **ApiService**: HTTP 請求服務，基於 Dio
- **DataService**: 資料服務，整合多個資料倉庫
- **StorageService**: 本地儲存服務，基於 SharedPreferences
- **NotificationService**: 通知服務介面（預留）

#### UI 實作
- **HomeScreen**: 首頁，顯示股票列表
  - 預設顯示 5 檔台股（2330, 2454, 2317, 2412, 2308）
  - 支援下拉刷新
  - 完整的載入和錯誤狀態處理
- **StockDetailScreen**: 股票詳情頁
  - 顯示完整報價資訊（開高低收、成交量）
  - 即時更新股價
  - 「建立交易計畫」功能入口
- **TradePlanScreen**: 交易計畫頁
  - 策略選擇下拉選單
  - 投資參數輸入（金額、風險）
  - 實時計算並顯示交易計畫
  - 顯示建議買入價、止損、停利、可買張數等
- **StockCard Widget**: 股票卡片元件，美觀的股票資訊展示
- **LoadingWidget**: 載入指示器元件

#### 主題和路由
- **AppTheme**: 完整的亮色和暗色主題配置
- **AppRouter**: 集中式路由管理

#### 測試
- Calculator 單元測試（8 個測試案例）
- TradeCalculator 單元測試（10 個測試案例）
- Stock Model 單元測試（7 個測試案例）
- 測試覆蓋核心計算邏輯和資料模型

#### 文檔
- **README.md**: 完整的專案說明和使用指南
- **ARCHITECTURE.md**: 詳細的架構說明文檔
- **CONTRIBUTING.md**: 貢獻指南
- **EXAMPLES.md**: 豐富的使用範例
- **CHANGELOG.md**: 版本變更記錄

#### 依賴套件
- dio: ^5.4.0 - HTTP 請求
- provider: ^6.1.1 - 狀態管理
- flutter_screenutil: ^5.9.0 - UI 適配
- intl: ^0.19.0 - 國際化和格式化
- uuid: ^4.3.3 - UUID 生成
- shared_preferences: ^2.2.2 - 本地儲存
- hive: ^2.2.3 - 本地資料庫
- hive_flutter: ^1.1.0 - Hive Flutter 支援

### Features

#### 股票報價功能
- ✅ 從 Yahoo Finance 即時取得台股報價
- ✅ 支援批次查詢多檔股票
- ✅ 顯示現價、漲跌、漲跌幅、成交量
- ✅ 顯示開盤價、最高價、最低價、昨收價

#### 交易計畫功能
- ✅ 支援 5 種交易策略
- ✅ 自動計算建議買入價
- ✅ 自動計算止損價格
- ✅ 支援多層停利設定
- ✅ 計算最大可買張數（考慮手續費）
- ✅ 計算風險報酬比
- ✅ 計算預期報酬

#### 費用計算
- ✅ 精確的手續費計算（0.1425%）
- ✅ 交易稅計算（0.3%）
- ✅ 最低手續費處理（$20）

### Technical Improvements
- 採用 Clean Architecture 架構
- 完整的錯誤處理機制
- 類型安全的資料模型
- 單元測試覆蓋核心功能
- 詳細的程式碼註解

### Documentation
- 完整的 README.md
- 詳細的架構說明文檔
- 使用範例文檔
- 貢獻指南

## [Unreleased]

### Planned Features
- [ ] 歷史 K 線圖表顯示
- [ ] 整合實際籌碼資料源
- [ ] 自選股管理功能
- [ ] 交易紀錄追蹤
- [ ] 價格提醒推送通知
- [ ] 技術指標圖表（MA, RSI, MACD 等）
- [ ] 策略回測功能
- [ ] 多帳戶管理
- [ ] 交易日記功能
- [ ] 暗色模式自動切換
- [ ] 多語言支援（繁中、簡中、英文）

### Known Issues
- Yahoo Finance API 可能有請求頻率限制
- 技術指標需要歷史資料才能計算
- 籌碼資料目前為模擬資料

## Notes

### Phase 1 完成項目總結

**程式碼統計**:
- 總代碼行數: 3,079+ 行
- Dart 檔案: 40+ 個
- 測試檔案: 3 個
- 文檔檔案: 5 個

**架構設計**:
- Clean Architecture 三層架構
- 關注點分離
- 依賴注入準備
- 可測試性設計

**品質保證**:
- 單元測試覆蓋核心邏輯
- 完整的錯誤處理
- 類型安全
- Lint 規則遵循

---

[1.0.0]: https://github.com/jack505141/StockAPP/releases/tag/v1.0.0
