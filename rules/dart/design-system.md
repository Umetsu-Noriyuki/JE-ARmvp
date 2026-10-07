# デザイン仕様

実装は `lib/app/theme/` に定義する。

## Color

`lib/app/theme/app_colors.dart`

| 定数名 | 用途 | 値 |
|---|---|---|
| PRIMARY_NAVY | Primary（AppBar・主要ボタン） | #0B1F44 |
| ACCENT_GOLD | Accent（強調・セカンダリ） | #D4A64A |
| BACKGROUND | 画面背景 | #F5F7FA |
| CARD_WHITE | カード・AppBar文字 | #FFFFFF |
| SUCCESS_GREEN | 成功・共有中表示 | #34C759 |
| WARNING_RED | エラー・警告・期限切れ表示 | #FF6B6B |

## Typography

`lib/app/theme/app_text_styles.dart`

| 定数名 | 用途 | サイズ |
|---|---|---|
| TITLE | 画面タイトル | 22 / bold |
| HEADING | 見出し・AppBarタイトル | 18 / w600 |
| BODY | 本文 | 16 |
| CAPTION | 補足（作成日時・残り時間など） | 12 |

## Components

- AppBar
- PrimaryButton
- SecondaryButton
- SectionHeader
- ArObjectCard（マイAR一覧の1件表示：サムネイル・内容・場所・共有状態）
- ShareStatusBadge（未共有 / 共有中：残り時間 / 終了）
- EmptyState
