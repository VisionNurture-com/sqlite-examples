-- 第5回 JOIN: INNER / LEFT / ON と WHERE / 連鎖 / 直積（shop.db 4テーブル）
-- 記事: https://www.visionnurture.com/sqlite_basics_for_beginner_005/
-- 出力は .mode column（SQLite 3.53.3 では数値列が右寄せ）。架空データのみ（仮名・example.com）
.mode column
.headers on

.print '===== [FK] PRAGMA foreign_keys（既定・004 の一貫性確認） ====='
PRAGMA foreign_keys;
PRAGMA foreign_keys = ON;
PRAGMA foreign_keys;

.print ''
.print '===== [INNER] INNER JOIN: 注文のあるユーザーだけ（jiro は消える） ====='
SELECT u.name, o.id AS order_id, o.status
FROM users AS u
INNER JOIN orders AS o ON o.user_id = u.id
ORDER BY o.id;

.print ''
.print '===== [LEFT] LEFT JOIN: 全ユーザーを残す（jiro は order 列が NULL） ====='
SELECT u.name, o.id AS order_id, o.status
FROM users AS u
LEFT JOIN orders AS o ON o.user_id = u.id
ORDER BY u.id, o.id;

.print ''
.print '===== [LEFT-NULL] LEFT JOIN + WHERE o.id IS NULL: 未注文ユーザー抽出（002 IS NULL 回収） ====='
SELECT u.name, u.email
FROM users AS u
LEFT JOIN orders AS o ON o.user_id = u.id
WHERE o.id IS NULL;

.print ''
.print '===== [ON-cond] LEFT JOIN で右条件を ON に置く（全ユーザー残る・非一致は NULL） ====='
SELECT u.name, o.id AS order_id, o.status
FROM users AS u
LEFT JOIN orders AS o ON o.user_id = u.id AND o.status = 'paid'
ORDER BY u.id;

.print ''
.print '===== [WHERE-cond] LEFT JOIN で右条件を WHERE に置く（実質 INNER 化・行数が減る） ====='
SELECT u.name, o.id AS order_id, o.status
FROM users AS u
LEFT JOIN orders AS o ON o.user_id = u.id
WHERE o.status = 'paid'
ORDER BY u.id;

.print ''
.print '===== [CHAIN] 連鎖 JOIN: 誰が・何を・いくつ買ったか（4テーブル横断） ====='
SELECT u.name, p.name AS product, oi.quantity, o.status
FROM users AS u
JOIN orders AS o       ON o.user_id = u.id
JOIN order_items AS oi ON oi.order_id = o.id
JOIN products AS p     ON p.id = oi.product_id
ORDER BY u.id, o.id;

.print ''
.print '===== [CROSS-count] 直積事故: users(3) × products(3) = 9 行（ON 忘れ） ====='
SELECT count(*) AS cartesian_rows FROM users, products;

.print ''
.print '===== [CROSS-sample] 直積の中身（先頭6行のみ表示） ====='
SELECT u.name AS user, p.name AS product FROM users u, products p LIMIT 6;

.print ''
.print '===== [FK-independent] JOIN は foreign_keys OFF でも同結果（値の一致で成立） ====='
PRAGMA foreign_keys = OFF;
SELECT count(*) AS inner_rows_fk_off
FROM users u INNER JOIN orders o ON o.user_id = u.id;
PRAGMA foreign_keys = ON;
SELECT count(*) AS inner_rows_fk_on
FROM users u INNER JOIN orders o ON o.user_id = u.id;

.print ''
.print '===== [RIGHT-FULL] RIGHT/FULL OUTER JOIN は 3.39+ で対応（競合誤り訂正 G5） ====='
SELECT u.name, o.id AS order_id
FROM orders AS o
RIGHT JOIN users AS u ON o.user_id = u.id
ORDER BY u.id, o.id;
