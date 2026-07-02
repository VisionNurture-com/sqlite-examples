-- 共通サンプル DB shop.db シードデータ（4テーブル）
-- 架空データのみ（仮名・example.com・一般名詞）
-- 参照整合を満たす順序: users → products → orders → order_items

INSERT INTO users (id, name, email) VALUES
  (1, '田中太郎',   'taro@example.com'),
  (2, '鈴木花子',   'hanako@example.com'),
  (3, '佐藤次郎',   'jiro@example.com');

INSERT INTO products (id, name, price, category, stock, description) VALUES
  (1, 'コーヒー豆',   1200, '食品', 50, '深煎りブレンド200g'),
  (2, 'ノート',        300, '文具', 200, NULL),
  (3, 'マグカップ',    900, '雑貨', 30, '電子レンジ対応');

INSERT INTO orders (id, user_id, status) VALUES
  (1, 1, 'paid'),
  (2, 2, 'pending'),
  (3, 1, 'shipped');

INSERT INTO order_items (id, order_id, product_id, quantity) VALUES
  (1, 1, 1, 2),
  (2, 1, 3, 1),
  (3, 2, 2, 5),
  (4, 3, 1, 1);
