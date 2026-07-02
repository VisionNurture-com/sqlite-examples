#!/usr/bin/env bash
# 第4回 テーブル設計: 型親和性 / STRICT / CHECK / 外部キー のデモ
# 記事: https://www.visionnurture.com/sqlite_basics_for_beginner_004/
# 注意: このデモは「わざとエラーになる操作」を含みます（STRICT 拒否・CHECK 違反・外部キー違反）。
#       エラー表示そのものが学習ポイントなので、途中でエラーが出ても最後まで実行します。
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SQLITE="${1:-sqlite3}"
DB="$(mktemp -u).db"
rm -f "$DB"
"$SQLITE" "$DB" < "$ROOT/schema.sql"
"$SQLITE" "$DB" < "$ROOT/seed.sql"

echo "### sqlite3 version ###"; "$SQLITE" --version

echo ""
echo "========== [1] 型親和性: INTEGER 列に文字列を入れると? （非 STRICT） =========="
"$SQLITE" "$DB" <<'SQL'
CREATE TABLE affinity_demo (n INTEGER);
INSERT INTO affinity_demo VALUES (123);      -- 数値
INSERT INTO affinity_demo VALUES ('456');    -- 数値文字列 → 数値に変換される
INSERT INTO affinity_demo VALUES ('abc');    -- 非数値文字列 → そのまま TEXT で入る
SQL
"$SQLITE" -header -column "$DB" "SELECT n, typeof(n) FROM affinity_demo;"

echo ""
echo "========== [2] STRICT テーブル（3.37+）: 非数値は弾かれる（わざとエラー） =========="
"$SQLITE" "$DB" "CREATE TABLE affinity_strict (n INTEGER) STRICT;"
echo "--- 数値 123 は OK ---"
"$SQLITE" "$DB" "INSERT INTO affinity_strict VALUES (123);" && echo "(成功)"
echo "--- 非数値 'abc' はエラーになる（想定どおり） ---"
"$SQLITE" "$DB" "INSERT INTO affinity_strict VALUES ('abc');" || echo "(想定どおりエラー)"

echo ""
echo "========== [3] CHECK 制約違反: price >= 0 に反する INSERT（わざとエラー） =========="
"$SQLITE" "$DB" "INSERT INTO products (name, price, category) VALUES ('不良品', -100, '雑貨');" || echo "(想定どおりエラー)"

echo ""
echo "========== [4] 外部キー: 既定 OFF では通り、ON では弾かれる =========="
echo "--- foreign_keys 既定値 ---"
"$SQLITE" "$DB" "PRAGMA foreign_keys;"
echo "--- ON にして存在しない user_id=999 の注文を入れる（わざとエラー） ---"
"$SQLITE" "$DB" "PRAGMA foreign_keys = ON; INSERT INTO orders (user_id, status) VALUES (999, 'pending');" || echo "(想定どおりエラー)"

rm -f "$DB"
echo ""
echo "### 04_design demo 完了（上記のエラー表示は学習ポイントです） ###"
