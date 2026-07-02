-- 006 索引実演用 補助デモ（決定事項2 案A・seed 正本は不変）
-- 目的: 小テーブル（seed 4 行）では索引が使われず SCAN のままになることが多いため、
--       行数を増やした専用テーブルで CREATE INDEX 前後の QUERY PLAN 変化（SCAN→SEARCH）を実測する。
-- 本デモは記事本文で「行数が増えるほど索引が効く」を体感させる補助（shop.db の order_items とは別テーブル）。
.mode column
.headers on

-- デモ用テーブル: order_items と同型だが大量行を投入
CREATE TABLE order_items_big (
    id         INTEGER PRIMARY KEY,
    order_id   INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity   INTEGER NOT NULL
);

-- 再帰 CTE で 50,000 行を生成（product_id は 1..100 を循環＝そこそこの選択性）
INSERT INTO order_items_big (order_id, product_id, quantity)
WITH RECURSIVE seq(n) AS (
  SELECT 1 UNION ALL SELECT n + 1 FROM seq WHERE n < 50000
)
SELECT n, (n % 100) + 1, (n % 5) + 1 FROM seq;

.print '===== デモ: 行数 ====='
SELECT COUNT(*) AS rows FROM order_items_big;

.print ''
.print '===== デモ 索引前: EXPLAIN QUERY PLAN（50000行・SCAN 期待）====='
EXPLAIN QUERY PLAN SELECT * FROM order_items_big WHERE product_id = 42;

.print ''
.print '===== デモ 索引作成 ====='
CREATE INDEX idx_big_product ON order_items_big(product_id);
.print '(idx_big_product 作成)'

.print ''
.print '===== デモ 索引後: EXPLAIN QUERY PLAN（SEARCH USING INDEX 期待）====='
EXPLAIN QUERY PLAN SELECT * FROM order_items_big WHERE product_id = 42;
