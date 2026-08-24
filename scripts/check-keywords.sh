#!/bin/sh
#
# 敏感關鍵字檢查腳本（供 pre-commit 呼叫）。
#
# 關鍵字清單放在 repo 根目錄的 .secret-keywords（每行一個，# 開頭為註解）。
# 該清單檔應加入 .gitignore，不進版控，避免關鍵字本身外洩。
#
# 用法：check-keywords.sh <file1> <file2> ...
#   pre-commit 會把本次 staged 的檔案路徑當參數傳入。
# 命中任一關鍵字 → exit 1（中止 commit）；否則 exit 0。

# 找 repo 根目錄，讓腳本從任何 cwd 都能定位清單檔。
repo_root=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
keywords_file="${repo_root}/.secret-keywords"

if [ ! -f "$keywords_file" ]; then
    printf '\033[33m⚠ 找不到關鍵字清單 %s，略過檢查。\033[0m\n' "$keywords_file" >&2
    printf '  （若要啟用檢查，請建立該檔，每行一個關鍵字。）\n' >&2
    exit 0
fi

# 讀清單，去掉註解行與空行，組成 grep 的 alternation pattern。
pattern=$(grep -vE '^\s*(#|$)' "$keywords_file" | paste -sd '|' -)

if [ -z "$pattern" ]; then
    # 清單是空的，無關鍵字可檢查。
    exit 0
fi

status=0
for f in "$@"; do
    [ -f "$f" ] || continue
    # -i 不分大小寫；-n 顯示行號。
    matches=$(grep -inE "$pattern" "$f")
    if [ -n "$matches" ]; then
        if [ "$status" -eq 0 ]; then
            printf '\033[31m✖ 偵測到敏感關鍵字，commit 已中止：\033[0m\n' >&2
        fi
        printf '\n--- %s ---\n' "$f" >&2
        printf '%s\n' "$matches" >&2
        status=1
    fi
done

if [ "$status" -ne 0 ]; then
    printf '\n請移除上述內容再 commit。誤判時可用 \033[33mgit commit --no-verify\033[0m 跳過（慎用）。\n' >&2
fi

exit "$status"
