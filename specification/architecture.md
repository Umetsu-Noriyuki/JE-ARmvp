# アーキテクチャー

## `/lib`以下のディレクトリ構成

`/lib`以下のディレクトリ構成は下記とする。


```
lib/
├── main.dart                               // アプリ起動エントリーポイント
│
├── app/                                    // アプリ全体設定
│   ├── app.dart                            // MaterialApp / ProviderScope / GoRouter 初期化、広告ライフサイクル監視
│   │
│   ├── router/                             // GoRouter 関連
│   │   ├── app_router.dart                 // ルーティング定義
│   │   ├── route_names.dart                // route 名定数
│   │   └── route_guards.dart               // 認証・初回起動などの画面遷移制御
│   │
│   └── theme/                              // アプリ全体テーマ
│       ├── app_theme.dart                  // ThemeData 定義
│       ├── app_colors.dart                 // カラー定義
│       └── app_text_styles.dart            // TextStyle 定義
│
├── core/                                   // アプリ全体共通の基盤機能
│   ├── ads/                                 // 広告(AdMob)関連
│   │   ├── ad_helper.dart                   // Ad Unit ID出し分け
│   │   ├── ad_frequency_store.dart          // 表示頻度キャップの判定・永続化
│   │   ├── anchored_banner_ad_widget.dart   // アンカーアダプティブバナー共通Widget
│   │   ├── app_open_ad_manager.dart         // アプリ起動広告の読み込み・表示・頻度判定
│   │   └── interstitial_ad_manager.dart     // 保存後インタースティシャルの読み込み・表示・頻度判定
│   │
│   ├── constants/                          // 全体共通定数
│   │   └── app_constants.dart              // 定数管理
│   │
│   ├── errors/                             // 共通エラー処理
│   │   ├── app_exception.dart              // 独自例外
│   │   ├── failure.dart                    // UI向けエラー表現
│   │   └── error_handler.dart              // エラーハンドリング共通処理
│   │
│   ├── extensions/                         // 拡張メソッド
│   │   ├── context_extensions.dart         // BuildContext 拡張
│   │   ├── datetime_extensions.dart        // DateTime 拡張
│   │   └── string_extensions.dart          // String 拡張
│   │
│   ├── utils/                              // 共通ユーティリティ
│   │   ├── logger.dart                     // ログ出力
│   │   ├── validators.dart                 // 入力チェック
│   │   ├── date_utils.dart                 // 日付処理
│   │   └── formatter.dart                  // 表示フォーマット変換
│   │
│   └── enums/                              // 全体共通 enum
│       ├── xxx_type.dart                   // 機能別の enum 定義
│       └── :
│
├── data/                                   // データ層（アプリの中核）
│   ├── db/                                 // Drift(SQLite) 関連
│   │   ├── app_database.dart               // DB接続定義
│   │   ├── app_database.g.dart             // Drift生成コード（build_runner、ソースと同階層に生成しコミットする）
│   │   │
│   │   └── tables/
│   │       ├── xxx_xxx.dart                // 各機能別のテーブル定義
│   │       └── :
│   │
│   ├── models/                             // DAO モデル(必要であれば)
│   │   ├── common/                         // 共通モデル
│   │   │   ├── pagination.dart             // ページング
│   │   │   └── app_setting.dart            // 設定情報
│   │   │
│   │   ├── xxx_xxx/                        // 各機能毎のモデルをディレクトリを分けて定義
│   │   │   ├── xxx_aaa.dar                 // xxx機能のaaaモデル定義
│   │   │   └── :
│   │   │
│   │   ├── yyy_yyy/
│   │   │   ├── yyy_aaa.dar                 // yyy機能のaaaモデル定義
│   │   │   └── :
│   │   :
│   │
│   ├── repositories/                       // Repository層
│   │   ├── xxx_repository.dart             // 各機能のデータ操作
│   │   └── :
│   │
│   ├── services/                           // データ処理系サービス(必要であれば)
│   │   ├── import_export_service.dart      // JSON/CSV入出力
│   │   ├── secure_storage_service.dart     // SecureStorage操作
│   │   └── :
│   │
│   └── providers/                          // Riverpod 共通Provider
│       ├── database_providers.dart         // DB Provider
│       ├── repository_providers.dart       // Repository Provider
│       └── service_providers.dart          // Service Provider
│
├── features/                               // UI機能単位
│   ├── home/                               // ホーム画面
│   │   ├── home_pages.dart                 // Home画面
│   │   ├── home_viewmodels.dart            // Home ViewModel
│   │   ├── home_providers.dart             // Home Provider
│   │   └── widgets/                        // Home専用Widget
│   │
│   ├── xxx_xxx/                              // xxx_xxx機能
│   │   ├── xxx_xxx_pages.dart                // xxx_xxx画面(View)
│   │   ├── xxx_xxx_viewmodels.dart           // ViewModel
│   │   ├── xxx_xxx_providers.dart            // Provider
│   │   └── widgets/
│   │
│   ├── yyy_yyy/                              // yyy_yyy機能
│   │   ├── yyy_yyy_pages.dart                // yyy_yyy画面(View)
│   │   ├── yyy_yyy_viewmodels.dart           // ViewModel
│   │   ├── yyy_yyy_providers.dart            // Provider
│   │   └── widgets/
│   :
│
├── shared/                                 // feature横断共通UI
│   ├── widgets/                            // 全体共通Widget
│   │   ├── buttons/                        // ボタン
│   │   ├── dialogs/                        // ダイアログ
│   │   ├── forms/                          // 入力フォーム
│   │   ├── loading/                        // Loading表示
│   │   └── charts/                         // グラフWidget
│   │
│   └── layouts/                            // 共通レイアウト
│       ├── app_scaffold.dart               // 共通Scaffold
│       └── responsive_layout.dart          // レスポンシブ対応
│
└── generated/                              // 生成コード
    └── l10n/                               // 多言語生成
```

- Drift の生成コード（`*.g.dart`）は `lib/generated/` には置かず、build_runner のデフォルトどおりソースファイルと同じ階層に生成し、コミットする

## リポジトリルート直下のインフラ構成

AWSインフラは Flutter のビルド対象（`lib/`）から分離し、リポジトリルート直下に配置する。

```
infrastructure/
├── cdk/                                    // CDKによるインフラ構築コード（Typescriptプロジェクト）
│
└── lambda/                                 // Lambda関数（Typescriptプロジェクト）
    ├── xxx_xxx_api/                        // xxx_xxx機能API
    :
```

## ディレクトリ構成に無い場合
- 構成にないディレクトリを作成する場合は、確認を求め承認されない場合は、ユーザーの指示に従うこと