# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Flutter Version

This project uses [FVM](https://fvm.app/) to pin Flutter at **3.38.3**. Prefix all `flutter` and `dart` commands with `fvm`:

```
fvm flutter <command>
fvm dart <command>
```

## Common Commands

```bash
fvm flutter pub get          # Install dependencies
fvm flutter run              # Run on connected device/emulator
fvm flutter build apk        # Build Android APK
fvm flutter build web        # Build web
fvm flutter analyze          # Static analysis (flutter_lints)
fvm flutter test             # Run all tests
fvm flutter test test/widget_test.dart  # Run a single test file
```

## Project Structure

- `lib/main.dart` — entry point; currently the default Flutter counter app
- `test/` — widget tests using `flutter_test`
- Platform directories (`android/`, `ios/`, `linux/`, `macos/`, `web/`, `windows/`) contain platform-specific build config; generally don't need editing for app logic

## Linting

Rules come from `package:flutter_lints/flutter.yaml` (configured in `analysis_options.yaml`). Run `fvm flutter analyze` to check. Suppress per-line with `// ignore: rule_name` or per-file with `// ignore_for_file: rule_name`.

## ルール

- .env, credentials 等の機密ファイルを読み取り・編集・コミットしないこと
- シークレットやAPIキーをコードにハードコードしないこと
- rm -rf / や force push 等の破壊的コマンドを実行しないこと
- すべての応答は日本語で行う
- 実装前に、まずアプローチの計画を立てて私に見せてください。実装計画を提示した後は停止すること。ユーザーから承認を受けるまでは実装してはいけない。
- 実装前に、確認したファイルを報告すること
- レビューを指示された際は`rules/dart/review-rule.md`にも従うこと

### テストコード（必須）
- **特に指示がなくても、新規作成ファイルごとにテストコードを作成する**
- テスト詳細ルール：`specification/coding.md` を必ず実装前に読むこと

### コーディング規約（必読）
実装前に必ず以下を読むこと：
- `specification/coding.md` — 命名規則・テストルール・ディレクトリ構成
- `specification/Library.md` — 利用ライブラリ
- `rules/common/coding-style.md` — 共通ルール
- `rules/dart/coding-style.md` — Dart固有ルール

## アプリ仕様

- アプリケーションの仕様については `/specification`を読むこと
- `/rules` の内容と重複する場合は `/specification` の内容を優先すること
