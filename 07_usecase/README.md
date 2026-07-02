# 07_usecase — 使いどころ・WAL・並行性

記事: [SQLiteの使いどころ：向き不向きとWAL・並行性を図解【2026年版】](https://www.visionnurture.com/sqlite_basics_for_beginner_007/)

第7回は**スキーマ非依存**（共通サンプル DB `shop.db` を使いません）。WAL やロックの挙動はテーブルの中身に依存しないため、最小の `test.db` で確認します。

## 単一プロセスで確認できること（CI 対象）

```bash
sqlite3 "$(mktemp -u).db" < wal_demo.sql
```

`wal_demo.sql` は、既定の `journal_mode`（delete）→ `WAL` への切り替え、既定 `busy_timeout`（0）、最小テーブルへの書き込み・読み取りを確認します。

## 2 プロセスで再現する `database is locked`（CI 対象外）

`database is locked`（SQLITE_BUSY）は、2 つのプロセスが同時に書き込もうとしたときに発生します。これは対話的な操作（2 つのターミナルを開く）が必要なため、CI では自動化していません。手順は記事本文の「database is lockedはなぜ起きるのか」を参照してください。

- 応急処置: `PRAGMA busy_timeout = 5000;`（レーンが空くまで待つ）
- 根治: WAL 化 / トランザクションを短く保つ / `BEGIN IMMEDIATE` で書き込みを始める
