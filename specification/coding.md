## コーディング規約

### 命名規則

クラス名、変数・関数・メソッド、定数、ファイル名は、見た目で何を行うもの、何のためのもの、が分かる名称とする

- クラス名は PascalCase

```
class UserProfileScreen {}
```

- 変数・関数・メソッドは lowerCamelCase

```
final userName = 'Taro';
void fetchUser() {}
```

- 定数は すべて大文字 + snake_case

```
const MAX_RETRY_COUNT = 3;
const double DEFAULT_PADDING = 16.0;
```

- ファイル名は snake_case

```
user_profile_screen.dart
auth_service.dart
```

- フォルダ名は snake_case

```
services/
common_method/
```

- enum名：UpperCamelCase
- enum値：lowerCamelCase（必須）
```
enum UserRole {
    admin,
    editor,
    viewer,
}
```

- 引数・コンストラクタは lowerCamelCase

```
class User {
    final String firstName;
    final String lastName;

    User({required this.firstName, required this.lastName});
}
```

- private 変数・関数は _ で始める

```
class AuthService {
    String _token = "";

    void _authenticate() {
      // 認証処理
    }
}
```

- ブール値は is / has / can で始める

```
isLoading
hasPermission
canEdit
```

- Widget のクラス名は語尾を Widget / Page / Screen / View で統一

```
HomeScreen
LoginPage
ProfileView
```

### コーディングルール

- １つのメソッドや関数は最大でも50行ぐらいとする。これを超える場合は、長いロジックを別処理として関数化する
- 30行を超える処理は長いロジックとする
- 上位の処理は、処理順に関数を並べるような記載とし、これら関数名を見ればどのような処理を行っているのかがわかるようにする
- 特に指示が無くても、作成したファイル毎にテストコードを作成する
- ディレクトリ構成は`specification\architecture.md`に従うこと

### テストコード作成ルール

- テストコードは、`/test`以下に `/lib`以下と同じディレクトリ構造で作成する
- ファイル名は、基本的にはテスト対象ファイル名語尾の `.dart` を `.test.dart` に変更したものとする
- コードの修正があった場合、対象のテストコードも併せて修正すること

#### ロジックのテストコード

- 初めに、テスト対象のメソッドや関数のブラックボックステストとし、取り得るinputに対するoutputが正しいことを判定する
- 次に、メソッドや関数内に分岐がある場合、条件により正しく分岐されることを判定する
- 次に、例外処理が正しく動作することを判定する
- 正常系と異常系がわかるようなテスト表示にすること
- メソッドや関数に変更があった場合、テストコードも合わせて変更すること
- テスト内容（test()のsubject）は日本語とする
- Riverpodテストなど、インスタンスを作成する場合は、addTearDown()で解放しメモリリークを回避すること
- RepositoryのテストでMockを利用する場合は、`mocktail`を利用する
- 場合によっては、`test/helper/`ディレクトリ以下にhelperを作成しても良い

#### 目標カバレッジ
- Serviceはドメインロジックのため、そのテストではカバレッジ80～90%を目標とする
- ViewModelはドメインロジックのため、そのテストではカバレッジ80～90%を目標とする
- Providerはドメインロジックはほとんど無いため、そのテストはカバレッジ60～80%を目標とする
- Pageは、画面遷移、エラー表示、loading表示、Form submitを主にテストし、画面の構成に関わる Padding, Column, SizeBoxなど部分は Flutter frameworkを信用し、そのカバレッジは20～40%を目標とする
- Widgetは、再利用されるWidgetだけ重点的にテストし、そのカバレッジは30～50%を目標とする
