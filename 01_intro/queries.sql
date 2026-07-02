-- 第1回 SQLite入門: 最初のテーブルと最小のSELECT
-- 記事: https://www.visionnurture.com/sqlite_basics_for_beginner_001/
-- 実行: sqlite3 shop.db でスキーマ+シード投入後、このクエリを .read する
.mode column
.headers on

.print '===== users テーブルの全件（最初のSELECT） ====='
SELECT id, name, email FROM users;

.print ''
.print '===== 1件だけ取り出す（WHERE の初歩） ====='
SELECT name FROM users WHERE id = 1;
