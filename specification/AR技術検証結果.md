# AR技術検証結果（Step 3 技術スパイク）

## 1. 目的

仕様書「29. Phase 1：AR単体検証」の最初のステップとして、Flutter から ARCore / ARKit を利用し、
文字・図形の ARオブジェクトを現実空間に配置できるかを検証し、採用する AR ライブラリを決定する。

## 2. ライブラリ候補（2026年10月時点）

| ライブラリ | 状況 | 文字・図形の表示 | 判定 |
|---|---|---|---|
| ar_flutter_plugin | 2022年11月以降更新なし。Dart 3 非対応 | glTF/GLB のみ | 不採用 |
| **ar_flutter_plugin_plus 1.1.3** | 保守されている fork。Android は ARCore + Filament、iOS は ARKit + SceneKit | glTF/GLB のみ | **第1候補（暫定採用）** |
| ar_flutter_plugin_2 0.0.3 | Android を SceneView に移行した fork | glTF/GLB のみ | 予備 |
| augen 1.5.0 | 基本図形・物理演算など多機能 | iOS では glTF/GLB が仮の箱で表示され、USDZ が必要 | 不採用 |
| ネイティブ実装（PlatformView） | iOS: ARKit + SceneKit、Android: ARCore + SceneView | 画像を貼った板を直接生成できる | 予備案（工数大） |

## 3. 方式

文字・図形は「画像を貼った板（GLB）」として表示する。

```text
TextContent / ShapeContent
   │  ArTextureRendererService（Flutter の Canvas で PNG に描画）
   ▼
PNG
   │  GlbQuadBuilderService（PNG を貼った長方形の板を GLB として生成）
   ▼
GLB
   │  ArModelFileService（端末の Documents/ar_models に保存）
   ▼
ar_flutter_plugin_plus（NodeType.fileSystemAppFolderGLB で平面アンカーに配置）
```

- 板は XY 平面上にあり、下辺中央が原点、表面は +Z 方向を向く（平面に立つ看板のイメージ）
- マテリアルは両面表示・透過（BLEND）・KHR_materials_unlit（照明に影響されない）
- 配置情報は、平面アンカーに対するノードの変換行列を `ArPose`（位置・回転・大きさ）に分解して保持する
- 平面の種類は、アンカーの Y 軸（法線）と鉛直方向のなす角で判定する（45度未満なら水平面）

### 実装上の注意点

| 項目 | 内容 |
|---|---|
| GLB ファイルの URI | Android は絶対パス、iOS は Documents からの相対パスを要求する（プラグインの実装差異）。`ArModelFileService` で吸収 |
| 大きさ変更 | プラグインに拡大縮小のジェスチャが無いため、スライダーで `ARNode.scale` を変更する |
| JDK | プラグインが JDK 17 ツールチェーンを要求する。`android/settings.gradle.kts` に foojay-resolver を追加し、未導入環境では自動取得する |
| debuggable | ARCore の不具合により、一部端末ではデバッグビルドでトラッキングが不安定になる（プラグイン README）。実機検証は `--release` で行う |
| ARCore 必須 | `AndroidManifest.xml` で `com.google.ar.core` を `required` とし、ARCore 非対応端末にはインストールできない |
| iOS | デプロイターゲット 15.0。`Podfile` で permission_handler のカメラ・位置情報権限を有効化 |

## 4. ビルド確認

| 項目 | 結果 | 備考 |
|---|---|---|
| Android デバッグビルド（`flutter build apk --debug`） | ✅ 成功 | 2026-10-07 WSL2 |
| Android リリースビルド（`flutter build apk --release`） | ✅ 成功 | 70.1MB |
| iOS ビルド | 未実施 | Mac が無いため（6章参照） |

## 5. 実機検証

### 実行方法（Android）

```bash
fvm flutter run --release
```

ホーム →「ARを作成」→ カメラを平面に向けてゆっくり動かし、平面が表示されたらタップする。

### 検証項目

| No. | 項目 | Android | iOS |
|---|---|---|---|
| 1 | ビルド・起動できる | | |
| 2 | 水平面（床・机）を検出できる | | |
| 3 | 垂直面（壁）を検出できる | | |
| 4 | タップした位置に日本語の文字の板を配置できる | | |
| 5 | 文字が鮮明に読める・透過や裏面表示が正しい | | |
| 6 | スライダーで大きさを変更できる | | |
| 7 | ドラッグで移動、2本指で回転できる | | |
| 8 | 配置情報（平面・位置・回転・大きさ）が画面下に表示され、操作に応じて更新される | | |
| 9 | 動作の安定性（トラッキングのずれ、発熱、カクつき） | | |

検証端末：

| 端末 | OS | ARCore / ARKit 対応 |
|---|---|---|
| （Android 端末名を記入） | | |
| （iPhone 機種名を記入） | | |

### 判定基準

- No.1〜8 がすべて満たせれば `ar_flutter_plugin_plus` を正式採用し、Step 4 へ進む
- No.2・4 が満たせない場合は、予備案（ネイティブ実装）への切り替えを検討する

## 6. 検証環境の課題

### Android 端末

- ARCore は Google が認定した端末のみ対応する（Android 7.0 以上、OpenGL ES 3.0 以上）
- 約10年前の端末は対応していない可能性が高い。[ARCore 対応端末一覧](https://developers.google.com/ar/devices) で確認すること
- 非対応の場合は、対応端末の用意が必要となる

### iOS（Mac が無い場合）

iOS アプリのビルド・署名には Xcode（macOS）が必要。Mac が無い場合の選択肢：

| 方法 | 必要なもの | 備考 |
|---|---|---|
| クラウド CI（Codemagic、GitHub Actions の macOS ランナー等）でビルドし、TestFlight で配布 | Apple Developer Program（年額）、CI アカウント | Phase 4 の実ユーザー検証でも TestFlight を使うため、早めに用意すると後工程でも使える |
| Mac を借りる・購入する | Mac | 無料の Apple ID でも実機への直接インストールが可能（7日間有効） |

## 7. 結論

（実機検証後に記入する）
