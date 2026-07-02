-- ミニ EC データベース shop.db（全8回で共通のサンプル DB スキーマ）
-- 架空データのみ（仮名・example.com・一般名詞）

CREATE TABLE users (
    id         INTEGER PRIMARY KEY,
    name       TEXT    NOT NULL,
    email      TEXT    UNIQUE NOT NULL,      -- 例: taro@example.com（実在ドメイン禁止）
    created_at TEXT    NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE products (
    id          INTEGER PRIMARY KEY,
    name        TEXT    NOT NULL,            -- 例: コーヒー豆 / ノート / マグカップ
    price       INTEGER NOT NULL CHECK (price >= 0),
    category    TEXT    NOT NULL,            -- 例: 食品 / 文具 / 雑貨
    stock       INTEGER NOT NULL DEFAULT 0,
    description TEXT                          -- 商品説明（任意・NULL 可）
);

CREATE TABLE orders (
    id         INTEGER PRIMARY KEY,
    user_id    INTEGER NOT NULL REFERENCES users(id),
    ordered_at TEXT    NOT NULL DEFAULT (datetime('now')),
    status     TEXT    NOT NULL DEFAULT 'pending'  -- pending / paid / shipped
);

CREATE TABLE order_items (
    id         INTEGER PRIMARY KEY,
    order_id   INTEGER NOT NULL REFERENCES orders(id),
    product_id INTEGER NOT NULL REFERENCES products(id),
    quantity   INTEGER NOT NULL CHECK (quantity > 0)
);
