# sqlite-examples

「SQLite入門（図解でわかる SQLite）」シリーズ（全8回）の**動くサンプルコード**です。全記事が同じサンプル DB `shop.db`（ミニ EC スキーマ）を使い回します。

- スキーマ正本: [`schema.sql`](schema.sql)（users / products / orders / order_items の4テーブル）
- シードデータ: [`seed.sql`](seed.sql)（仮名・`example.com` のみ / 実在の人名・メールアドレスは含みません）

## 使い方

```bash
# サンプル DB を作る
sqlite3 shop.db < schema.sql
sqlite3 shop.db < seed.sql

# 各回のクエリを実行する（例: 第5回 JOIN）
sqlite3 shop.db < 05_join/queries.sql
```

まとめて検証する場合:

```bash
bash verify/run_all.sh          # システムの sqlite3 を使う
bash verify/run_all.sh /opt/homebrew/opt/sqlite/bin/sqlite3   # 別バージョンを指定
```

## 記事 ↔ コード 対応表

| 回 | テーマ | コード | 記事 |
|----|--------|--------|------|
| 001 | SQLite入門・最初のテーブル | [`01_intro/queries.sql`](01_intro/queries.sql) | [記事](https://www.visionnurture.com/sqlite_basics_for_beginner_001/) |
| 002 | SELECT・WHERE・ORDER BY・LIKE・IS NULL | [`02_select/queries.sql`](02_select/queries.sql) | [記事](https://www.visionnurture.com/sqlite_basics_for_beginner_002/) |
| 003 | 追加・更新・削除・トランザクション | [`03_write/run.sh`](03_write/run.sh) | [記事](https://www.visionnurture.com/sqlite_basics_for_beginner_003/) |
| 004 | テーブル設計・型親和性・制約・外部キー | [`04_design/run.sh`](04_design/run.sh) | [記事](https://www.visionnurture.com/sqlite_basics_for_beginner_004/) |
| 005 | JOIN（INNER・LEFT・連鎖・直積） | [`05_join/queries.sql`](05_join/queries.sql) | [記事](https://www.visionnurture.com/sqlite_basics_for_beginner_005/) |
| 006 | 集計・GROUP BY・インデックス・EXPLAIN | [`06_aggregate/`](06_aggregate/) | [記事](https://www.visionnurture.com/sqlite_basics_for_beginner_006/) |
| 007 | 使いどころ・WAL・並行性 | [`07_usecase/`](07_usecase/) | [記事](https://www.visionnurture.com/sqlite_basics_for_beginner_007/) |
| 008 | 今のSQLite（俯瞰・コードなし） | [`08_modern/README.md`](08_modern/README.md) | [記事](https://www.visionnurture.com/sqlite_basics_for_beginner_008/) |

> **クリーンなクエリ**（01/02/05/06 index_demo/07 wal）は CI で「エラーなく実行できる」ことを検証しています。
> **03/04/06 のクエリ**は、トランザクションや制約違反・集約関数の誤りなど「わざとエラーを見せる学習デモ」を含みます。

## 動作確認バージョン

macOS Homebrew 3.53.3 / macOS 同梱 3.51.0 / Ubuntu apt 3.46.1 で確認しています（記事執筆時点）。SQLite の SQL は枯れており、上記いずれのバージョンでも論理的な結果は同じです。

## ライセンス / データについて

MIT（[LICENSE](LICENSE)）。学習・商用を問わず自由に使えます。

サンプルデータはすべて架空のもので、実在の人物・組織とは関係ありません（`example.com` はドキュメント用に予約されたドメインです）。
