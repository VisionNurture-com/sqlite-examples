-- 第2回 SELECT編: WHERE / ORDER BY / LIMIT / LIKE / IS NULL
-- 記事: https://www.visionnurture.com/sqlite_basics_for_beginner_002/
.mode column
.headers on

.print '===== 全商品 ====='
SELECT id, name, price, category FROM products;

.print ''
.print '===== WHERE: 500円以上 ====='
SELECT name, price FROM products WHERE price >= 500;

.print ''
.print '===== ORDER BY: 価格の高い順 ====='
SELECT name, price FROM products ORDER BY price DESC;

.print ''
.print '===== LIMIT: 高い順に先頭2件 ====='
SELECT name, price FROM products ORDER BY price DESC LIMIT 2;

.print ''
.print '===== LIKE: 名前に「ー」を含む ====='
SELECT name FROM products WHERE name LIKE '%ー%';

.print ''
.print '===== IS NULL: 商品説明が未設定（ノート） ====='
SELECT name FROM products WHERE description IS NULL;

.print ''
.print '===== IS NOT NULL: 商品説明あり ====='
SELECT name, description FROM products WHERE description IS NOT NULL;
