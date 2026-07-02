#!/usr/bin/env bash
# sqlite-examples 全体検証ランナー
# - クリーンなクエリ（01/02/05/06 index_demo/07 wal）は「エラーなく実行できる」ことを assert する。
# - 意図的にエラーを見せるデモ（03/04/06 queries）は情報として実行する（学習ポイントのエラー表示を含む）。
# 使い方: bash verify/run_all.sh [sqlite3のパス]
set -uo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SQLITE="${1:-sqlite3}"
fail=0

echo "### sqlite3 version ###"
"$SQLITE" --version || { echo "sqlite3 が見つかりません"; exit 2; }

build_db() { rm -f "$1"; "$SQLITE" "$1" < "$ROOT/schema.sql" && "$SQLITE" "$1" < "$ROOT/seed.sql"; }

# クリーン assert: exit 0 かつ出力に Error を含まないこと
assert_clean() {
  local label="$1"; shift
  local db out rc
  db="$(mktemp -u).db"
  if ! build_db "$db"; then echo "FAIL[$label] schema/seed 投入に失敗"; rm -f "$db"; fail=1; return; fi
  out=$("$SQLITE" "$db" < "$1" 2>&1); rc=$?
  rm -f "$db"
  if [ "$rc" -ne 0 ] || printf '%s' "$out" | grep -qiE 'Error|Parse error|Runtime error'; then
    echo "FAIL[$label] rc=$rc"; printf '%s\n' "$out" | tail -8; fail=1
  else
    echo "PASS[$label]"
  fi
}

# デモ実行: エラー表示を含んでよい（情報表示のみ・fail に影響しない）
run_demo() {
  local label="$1"; shift
  echo "----- DEMO[$label] -----"
  "$@" >/dev/null 2>&1 && echo "DEMO[$label] 実行完了" || echo "DEMO[$label] 実行完了（想定内のエラー表示を含む）"
}

echo ""
echo "===== 1) schema + seed の投入 ====="
db="$(mktemp -u).db"
if build_db "$db"; then echo "PASS[schema+seed]"; else echo "FAIL[schema+seed]"; fail=1; fi
"$SQLITE" "$db" "SELECT 'users='||count(*) FROM users;" 2>/dev/null
rm -f "$db"

echo ""
echo "===== 2) クリーンなクエリ（assert: エラーなし） ====="
assert_clean "01_intro"       "$ROOT/01_intro/queries.sql"
assert_clean "02_select"      "$ROOT/02_select/queries.sql"
assert_clean "05_join"        "$ROOT/05_join/queries.sql"
assert_clean "06_index_demo"  "$ROOT/06_aggregate/index_demo.sql"
assert_clean "07_wal"         "$ROOT/07_usecase/wal_demo.sql"

echo ""
echo "===== 3) デモ（意図的なエラー表示を含む・情報表示） ====="
run_demo "03_write"  bash "$ROOT/03_write/run.sh"  "$SQLITE"
run_demo "04_design" bash "$ROOT/04_design/run.sh" "$SQLITE"
# 06 queries は集約関数を WHERE に書く誤りを含む学習デモ
db="$(mktemp -u).db"; build_db "$db"; "$SQLITE" "$db" < "$ROOT/06_aggregate/queries.sql" >/dev/null 2>&1; echo "DEMO[06_aggregate_queries] 実行完了（集約関数の想定エラーを含む）"; rm -f "$db"

echo ""
if [ "$fail" -eq 0 ]; then
  echo "### ALL CLEAN CHECKS PASSED ###"
else
  echo "### 一部の assert が FAIL しました ###"
fi
exit "$fail"
