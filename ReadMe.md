---
title: matchgame

---


## Matching Card Game 

### 項目概述
這是一個基於 Swift 和 UIKit 實現的記憶配對遊戲（Matching Card Game）。玩家需要翻開卡片，尋找相同的圖案（使用表情符號表示），直到所有卡片配對完成。遊戲包含 16 張卡片（8 對），支援卡片翻轉動畫、配對檢查、翻轉次數統計以及重啟功能。

---

### 程式碼結構與功能

#### 1. `Card.swift`
- **作用**: 定義了遊戲中單張卡片的資料結構。
- **內容**:
  - `isfaceUP`: 布林值，表示卡片是否正面朝上。
  - `isMatchUP`: 布林值，表示卡片是否已配對成功。
  - `cardTitel`: 字串，表示卡片的內容（例如 🍎、🍌 等表情符號）。
  - `init(titel:)`: 初始化函數，設定卡片標題。


#### 2. `MetchingGame.swift`
- **作用**: 遊戲的核心邏輯類，管理卡片狀態、配對檢查和遊戲流程。
- **主要屬性**:
  - `cards`: 卡片陣列，儲存所有卡片的狀態。
  - `cardTitles`: 表情符號陣列，初始包含 8 對（16 個）符號，會隨機打亂。
  - `matchedCards`: 已配對的卡片數量。
  - `firstFlippedIndex` / `secondFlippedIndex`: 記錄當前翻開的兩張卡片索引。
  - `indexOfOneAndOnlyFaceUpCard`: 計算屬性，確保遊戲中最多只有一張未配對的卡片正面朝上。
- **主要方法**:
  - `init(viewController:)`: 初始化遊戲，設定卡片並隨機打亂。
  - `touchCard(at:)`: 處理卡片點擊邏輯，翻開卡片或取消翻開。
  - `isNotMatchFlipBack(at:)`: 檢查兩張卡片是否配對，若不匹配則返回需翻回的索引。
  - `checkMatch()`: 確認兩張卡片是否相同，更新配對狀態並檢查遊戲是否結束。
  - `showCompletionAlert()`: 當所有卡片配對完成時顯示祝賀訊息。
  - `restartGame()`: 重置遊戲狀態並重新洗牌。

#### 3. `ViewController.swift`
- **作用**: 負責 UI 顯示與用戶互動，作為 `MetchingGame` 的視圖控制器。
- **主要屬性**:
  - `cards`: 包含 16 個 `UIButton` 的陣列，對應遊戲中的卡片。
  - `flipsCount`: 顯示翻轉次數的標籤。
  - `frontColor` / `backColor`: 使用自定義 hex 顏色表示卡片正反面。
  - `flipCount`: 追蹤翻轉次數並更新 UI。
- **主要方法**:
  - `viewDidLoad()`: 初始化遊戲並設定卡片外觀。
  - `cardTapped(_:)`: 處理卡片點擊事件，觸發翻轉動畫並更新遊戲狀態。
  - `flipCard(button:isFront:index:)`: 實現卡片的翻轉動畫效果。
  - `gameCheck(index:)`: 檢查配對結果，若不匹配則延遲翻回卡片。
  - `setMatchCards(index1:index2:)`: 將配對成功的卡片透明度設為 0.5。
  - `resetButton(_:)` / `filpAllCards(_:)`: 提供重啟和顯示所有卡片的功能。
- **設計評估**:
  - 使用 `UIView.transition` 實現翻轉動畫，效果流暢且直觀。
  - `isFilpAllCards` 的拼寫錯誤（應為 `isFlipAllCards`）與方法名稱不一致。
  - 事件處理與 UI 更新耦合度較高，可考慮進一步解耦。

#### 4. `UIColor+Extension.swift`
- **作用**: 擴展 `UIColor`，支援使用 hex 字串創建顏色。
- **實現**: 解析 hex 字串，提取紅、綠、藍和透明度值。
- **設計評估**: 
  - 實用且通用，適用於任何需要 hex 顏色的場景。
  - 缺少輸入驗證，若 hex 字串格式錯誤可能導致崩潰。

---

### 程式碼邏輯分析

#### 遊戲流程
1. **初始化**: `MetchingGame` 創建 16 張卡片（8 對），隨機打亂並顯示在 `ViewController` 的按鈕上。
2. **翻卡**: 玩家點擊按鈕，觸發 `touchCard(at:)`，翻開第一張或第二張卡片。
3. **配對檢查**: 
   - 若翻開第二張卡片，`isNotMatchFlipBack(at:)` 檢查是否匹配。
   - 匹配成功：卡片保持正面並降低透明度。
   - 不匹配：延遲後翻回背面。
4. **結束條件**: 當 `matchedCards` 等於卡片總數時，顯示完成提示並提供重啟選項。

#### 動畫與互動
- 卡片翻轉使用 `UIView.transition` 實現，帶有 `.transitionFlipFromRight` 效果。
- 不匹配的卡片在 0.5 秒後自動翻回，提供足夠的觀察時間。

，提升代碼可讀性。