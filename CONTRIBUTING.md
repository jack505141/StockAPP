# 貢獻指南

感謝您對股票策略分析 App 專案的關注！本文件將幫助您了解如何為專案做出貢獻。

## 開發環境設置

### 必要工具

1. **Flutter SDK** (>= 3.2.0)
   ```bash
   flutter --version
   ```

2. **Dart SDK** (>= 3.2.0)
   ```bash
   dart --version
   ```

3. **IDE** (擇一)
   - Visual Studio Code + Flutter Extension
   - Android Studio + Flutter Plugin
   - IntelliJ IDEA + Flutter Plugin

### 專案設置

1. **Fork 並 Clone 專案**
   ```bash
   git clone https://github.com/YOUR_USERNAME/StockAPP.git
   cd StockAPP
   ```

2. **安裝依賴**
   ```bash
   flutter pub get
   ```

3. **執行測試**
   ```bash
   flutter test
   ```

4. **執行應用程式**
   ```bash
   flutter run
   ```

## 程式碼規範

### Dart 編碼規範

遵循 [Effective Dart](https://dart.dev/guides/language/effective-dart) 指南：

1. **命名規範**
   - 類別名稱：`PascalCase` (例如：`StockCard`)
   - 變數和方法：`camelCase` (例如：`calculatePrice`)
   - 常數：`camelCase` (例如：`maxRetries`)
   - 私有成員：以 `_` 開頭 (例如：`_privateMethod`)

2. **註解規範**
   - 所有公開的類別、方法都應該有文件註解
   - 使用 `///` 進行文件註解
   - 複雜的邏輯應該有行內註解說明

3. **格式化**
   ```bash
   flutter format lib/
   ```

### 檔案組織

```
lib/
├── app/              # 應用程式層級配置
├── core/             # 核心功能（常數、工具、服務）
├── data/             # 資料層（模型、資料源、倉庫）
├── domain/           # 領域層（實體、用例）
└── presentation/     # 展示層（畫面、元件）
```

### Git 提交訊息規範

使用 [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Type 類型：**
- `feat`: 新功能
- `fix`: 修復 Bug
- `docs`: 文件更新
- `style`: 程式碼格式（不影響功能）
- `refactor`: 重構
- `test`: 測試相關
- `chore`: 維護任務

**範例：**
```
feat(calculator): add risk reward ratio calculation

Implement risk reward ratio calculation in TradeCalculator.
This helps users evaluate their trade plans.

Closes #123
```

## 開發流程

### 1. 建立 Issue

在開始工作前，請先建立或選擇一個 Issue：
- 描述要解決的問題或要新增的功能
- 說明實作方式
- 等待維護者回應

### 2. 建立分支

```bash
git checkout -b feature/your-feature-name
# 或
git checkout -b fix/bug-description
```

### 3. 開發和測試

- 撰寫程式碼
- 新增單元測試
- 確保所有測試通過
- 執行 linter 檢查

```bash
# 執行測試
flutter test

# 執行分析
flutter analyze

# 格式化程式碼
flutter format lib/
```

### 4. 提交變更

```bash
git add .
git commit -m "feat: your commit message"
git push origin feature/your-feature-name
```

### 5. 建立 Pull Request

- 前往 GitHub 建立 Pull Request
- 填寫 PR 模板
- 連結相關 Issue
- 等待 Code Review

## 測試指南

### 單元測試

為新功能撰寫單元測試：

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:stock_app/core/utils/calculator.dart';

void main() {
  group('Calculator Tests', () {
    test('should calculate commission correctly', () {
      final commission = Calculator.calculateCommission(100000);
      expect(commission, 142.5);
    });
  });
}
```

### 測試覆蓋率

```bash
flutter test --coverage
```

## Code Review 檢查清單

PR 提交前請確認：

- [ ] 程式碼符合專案規範
- [ ] 所有測試通過
- [ ] 新增功能有對應測試
- [ ] 文件已更新
- [ ] 沒有不必要的依賴
- [ ] 沒有 console.log 或 debug 程式碼
- [ ] 提交訊息清晰明確

## 報告 Bug

### Bug Report 模板

請包含以下資訊：

1. **環境資訊**
   - Flutter 版本
   - Dart 版本
   - 作業系統
   - 裝置型號（如果是移動裝置）

2. **Bug 描述**
   - 預期行為
   - 實際行為
   - 重現步驟

3. **相關資訊**
   - 錯誤訊息
   - 截圖（如果適用）
   - 相關程式碼

## 功能建議

### Feature Request 模板

1. **功能描述**
   - 要解決的問題
   - 建議的解決方案
   - 替代方案

2. **使用情境**
   - 誰會使用這個功能
   - 如何使用
   - 預期效益

## 程式碼審查

### 作為審查者

- 保持友善和建設性
- 提供具體的改進建議
- 讚美好的程式碼
- 及時回應

### 作為被審查者

- 接受建設性批評
- 解釋你的設計決策
- 進行必要的修改
- 表達感謝

## 社群準則

- 尊重所有貢獻者
- 使用友善和包容的語言
- 接受建設性批評
- 關注對社群最有利的事情

## 授權

貢獻到本專案的程式碼將採用 MIT License。

## 問題與協助

如有任何問題，歡迎：
- 在 GitHub 上開 Issue
- 參與 Discussions
- 聯繫維護者

感謝您的貢獻！🎉
