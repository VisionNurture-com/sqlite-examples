#!/usr/bin/env bash
# 第3回 追加・更新・削除・トランザクション デモ
# 記事: https://www.visionnurture.com/sqlite_basics_for_beginner_003/
# 各デモは fresh な shop.db で実行（記事のコードブロック出力を再現）。
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SQLITE="${1:-sqlite3}"
DB="$(mktemp -u).db"

rebuild() { rm -f "$DB"; "$SQLITE" "$DB" < "$ROOT/schema.sql"; "$SQLITE" "$DB" < "$ROOT/seed.sql"; }
hdr() { printf '\n========== %s ==========\n' "$1"; }
run() { "$SQLITE" "$DB" -cmd '.mode column' -cmd '.headers on' "$@"; }

echo "### sqlite3 version ###"; "$SQLITE" --version

hdr "D1 INSERT 単一行（id 自動採番）"
rebuild
run "INSERT INTO orders (user_id, status) VALUES (3, 'pending');" \
    "SELECT id, user_id, status FROM orders;"

hdr "D2 UPDATE（WHERE で 1 件だけ paid に）"
rebuild
run "UPDATE orders SET status = 'paid' WHERE id = 1;" \
    "SELECT id, user_id, status FROM orders;"

hdr "D3 DELETE（WHERE で 1 件だけ削除）"
rebuild
run "DELETE FROM orders WHERE id = 3;" \
    "SELECT id, user_id, status FROM orders;"

hdr "D4 トランザクション ROLLBACK（間違えた DELETE を取り消す）"
rebuild
run "BEGIN;" \
    "DELETE FROM orders WHERE id = 2;" \
    "SELECT id, user_id, status FROM orders;  -- BEGIN 中（消えて見える）" \
    "ROLLBACK;" \
    "SELECT id, user_id, status FROM orders;  -- ROLLBACK 後（戻る）"

hdr "D5 トランザクション COMMIT（確定）"
rebuild
run "BEGIN;" \
    "UPDATE orders SET status = 'shipped' WHERE id = 2;" \
    "COMMIT;" \
    "SELECT id, user_id, status FROM orders;"

rm -f "$DB"
echo ""
echo "### 03_write demo 完了 ###"
