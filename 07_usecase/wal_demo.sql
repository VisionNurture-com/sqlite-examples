-- 第7回 使いどころ・WAL（スキーマ非依存・最小 test.db）
-- 記事: https://www.visionnurture.com/sqlite_basics_for_beginner_007/
-- 単一プロセスで実行できる WAL/PRAGMA の確認のみ。
-- 「database is locked」の2プロセス再現は対話的なため、記事本文を参照（CI では実行しない）。
.mode column
.headers on

.print '===== 既定の journal_mode（delete = ロールバックジャーナル） ====='
PRAGMA journal_mode;

.print ''
.print '===== WAL に切り替える ====='
PRAGMA journal_mode=WAL;

.print ''
.print '===== 切替後の journal_mode（wal） ====='
PRAGMA journal_mode;

.print ''
.print '===== 既定の busy_timeout（0 = 即エラー） ====='
PRAGMA busy_timeout;

.print ''
.print '===== 最小テーブルで書き込み→読み取り ====='
CREATE TABLE t(id INTEGER PRIMARY KEY, v TEXT);
INSERT INTO t(v) VALUES ('a'), ('b');
SELECT id, v FROM t;
