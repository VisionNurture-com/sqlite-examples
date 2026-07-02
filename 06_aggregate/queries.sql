-- 第6回 集計・インデックス: 集約関数 / GROUP BY / HAVING / EXPLAIN QUERY PLAN
-- 記事: https://www.visionnurture.com/sqlite_basics_for_beginner_006/
-- 注意: 「集約関数を WHERE に書く誤り」は、わざとエラーを見せる学習用です。
.mode column
.headers on
PRAGMA foreign_keys = ON;

.print '===== 全体集計（集約関数）====='
SELECT COUNT(*) AS cnt, SUM(quantity) AS sum_qty, AVG(quantity) AS avg_qty FROM order_items;

.print ''
.print '===== 商品別数量（GROUP BY）====='
SELECT product_id, SUM(quantity) AS total_qty
FROM order_items GROUP BY product_id;

.print ''
.print '===== 商品別 数量・売上（GROUP BY + JOIN）====='
SELECT p.name AS product, SUM(oi.quantity) AS qty, SUM(oi.quantity * p.price) AS sales
FROM order_items oi JOIN products p ON p.id = oi.product_id
GROUP BY p.id;

.print ''
.print '===== 集約関数を WHERE に書く誤り（わざとエラー・エラー文言を確認）====='
SELECT product_id, SUM(quantity) FROM order_items WHERE SUM(quantity) >= 3 GROUP BY product_id;

.print ''
.print '===== HAVING で成功（数量3以上）====='
SELECT product_id, SUM(quantity) AS total_qty
FROM order_items GROUP BY product_id HAVING SUM(quantity) >= 3;

.print ''
.print '===== WHERE と HAVING の併用 ====='
SELECT product_id, SUM(quantity) AS total_qty
FROM order_items WHERE quantity > 0 GROUP BY product_id HAVING SUM(quantity) >= 3;

.print ''
.print '===== 集計×JOIN カテゴリ別売上 ====='
SELECT p.category, SUM(oi.quantity * p.price) AS sales
FROM order_items oi JOIN products p ON p.id = oi.product_id
GROUP BY p.category;

.print ''
.print '===== ユーザー別購入額（連鎖JOIN + GROUP BY）====='
SELECT u.name AS user, SUM(oi.quantity * p.price) AS total
FROM users u
JOIN orders o ON o.user_id = u.id
JOIN order_items oi ON oi.order_id = o.id
JOIN products p ON p.id = oi.product_id
GROUP BY u.id;

.print ''
.print '===== 補足: COUNT(*) vs COUNT(列) の差（description は NULL 可）====='
SELECT COUNT(*) AS all_rows, COUNT(description) AS non_null_desc FROM products;

.print ''
.print '===== 補足: SUM vs TOTAL（全 NULL のケース）====='
SELECT SUM(description) AS sum_null, TOTAL(description) AS total_null FROM products;

.print ''
.print '===== EXPLAIN QUERY PLAN 索引前（小テーブル）====='
EXPLAIN QUERY PLAN SELECT * FROM order_items WHERE product_id = 1;

.print ''
.print '===== インデックス作成 ====='
CREATE INDEX idx_order_items_product ON order_items(product_id);
.print '(idx_order_items_product 作成)'

.print ''
.print '===== EXPLAIN QUERY PLAN 索引後（小テーブルでは SCAN のままか実測）====='
EXPLAIN QUERY PLAN SELECT * FROM order_items WHERE product_id = 1;
