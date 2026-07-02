# 08_modern — 今のSQLite（俯瞰）

記事: [今のSQLite入門：libSQL・Turso・D1とエッジ本番を図解【2026年版】](https://www.visionnurture.com/sqlite_basics_for_beginner_008/)

第8回は**俯瞰記事**です。libSQL・Turso・Cloudflare D1・Litestream / LiteFS といったエコシステムを、標準 SQLite の限界をどう補うかという軸で整理します。**各技術を実際に導入・実行するサンプルコードは含みません**（beginner 射程を超え、かつ更新が速く陳腐化しやすいため）。深掘りは各公式ドキュメントを参照してください。

このリポジトリで動かせるのは、土台となる**標準 SQLite** のサンプル（01〜07）です。標準 SQLite は今も現役で、エコシステムはその上に積み重なる層です。

## 一次情報（執筆時点の状態は各公式で確認してください）

- libSQL: https://github.com/tursodatabase/libsql
- Turso（Turso Cloud / Turso Database）: https://turso.tech/ ・ https://github.com/tursodatabase/turso
- Cloudflare D1: https://developers.cloudflare.com/d1/
- Litestream: https://litestream.io/
- LiteFS: https://fly.io/docs/litefs/
