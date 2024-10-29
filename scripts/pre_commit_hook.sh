#!/bin/sh

# 当前Git仓库根目录
GIT_ROOT=$(git rev-parse --show-toplevel)
echo "[INFO] GIT_ROOT: $GIT_ROOT"
cd "$GIT_ROOT" || exit

# 检查是否为合并提交
if git rev-parse -q --verify MERGE_HEAD > /dev/null; then
  echo "This is a merge commit."

  # 获取冲突文件列表
  conflict_files=$(git ls-files -u)

  if [ -n "$conflict_files" ]; then
    echo "Error: Merge conflicts detected in the following files:"
    echo "$conflict_files"
    exit 1
  else
    echo "No merge conflicts detected."
    # 检查合并冲突标记 <<<<<<< ======= >>>>>>>
    # shellcheck disable=SC2126
    conflict_markers=$(git diff --cached | grep -E '^(<<<<<<<|=======|>>>>>>>)' | wc -l)
    if [ "$conflict_markers" -gt 0 ]; then
      echo "Error: Merge conflict markers detected. Please resolve the conflicts before committing."
      exit 1
    else
      echo "No merge conflict markers detected."
      exit 0
    fi
  fi
else
  echo "This is not a merge commit."
fi


# 获取所有已修改的 Dart 文件
MODIFIED_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep '\.dart$')

# 如果没有修改的 Dart 文件，则退出
if [ -z "$MODIFIED_FILES" ]; then
  echo "[INFO] No modified Dart files to check. Exiting."
  exit 0
fi

# 打印已修改的 Dart 文件列表
echo "[INFO] Changed Dart files:"
for FILE in $MODIFIED_FILES; do
  echo "    - $FILE"
done
echo "------------------------------------"


echo "[INFO]------------------ Start format ----------------"
MAX_LENGTH=100
# 如果没有修改的 Dart 文件，则退出
if [ -z "$MODIFIED_FILES" ]; then
  echo "[INFO] No modified Dart files to check. Exiting."
else
  # 检查是否有文件需要格式化
  echo "Checking if any files need formatting..."
  # shellcheck disable=SC2034
  for FILE in $MODIFIED_FILES; do
    echo "[INFO] Formatting $FILE with max line length $MAX_LENGTH..."
    dart format --line-length $MAX_LENGTH --output=none --set-exit-if-changed "$FILE"
    # 获取命令执行状态码
    status=$?
    # 如果有文件需要格式化
    if [ $status -ne 0 ]; then
      echo "Some files need to be formatted."
      dart format --line-length $MAX_LENGTH "$FILE"
    else
      echo "No formatting needed. Exiting script."
    fi
  done
fi
echo "[INFO]------------------ End format ----------------"

## shellcheck disable=SC2164
#cd "$SCRIPT_DIR"
#echo "[INFO]------------------ Start analyze ----------------"
#chmod +x pre_commit_check_flutter_files.sh
#sh pre_commit_check_flutter_files.sh
#echo "[INFO]------------------ End analyze ----------------"


echo "------------------ Start Dart File Check ----------------"

# 初始化错误和警告计数
ERROR_COUNT=0
WARNING_COUNT=0

# 用来存储有错误或警告的文件
# shellcheck disable=SC2039
ERROR_FILES=()
# shellcheck disable=SC2039
WARNING_FILES=()

#MAX_LENGTH=100
# 检查每个修改的文件是否能通过编译
for FILE in $MODIFIED_FILES; do
  # shellcheck disable=SC2028
  echo "------------------------------------"
#  echo "[INFO] Formatting $FILE with max line length $MAX_LENGTH..."
#  dart format --line-length $MAX_LENGTH "$FILE"

  echo "[INFO] Analyzing $FILE for compilation errors..."
  # 运行 flutter analyze 命令并捕获输出
  analyze_output=$(flutter analyze "$FILE" 2>&1)

  # 输出分析结果
  echo "[INFO] Analyze result for $FILE:"
  echo "$analyze_output"

  # 检查是否有错误或警告
  if echo "$analyze_output" | grep -q "error"; then
      echo "[ERROR] Error found in $FILE."
      # shellcheck disable=SC2039
      ERROR_FILES+=("$FILE")
      ERROR_COUNT=$((ERROR_COUNT + 1))
  elif echo "$analyze_output" | grep -q "warning"; then
      echo "[WARNING] Warning found in $FILE."
      # shellcheck disable=SC2039
      WARNING_FILES+=("$FILE")
      WARNING_COUNT=$((WARNING_COUNT + 1))
  else
      echo "[INFO] No errors or warnings found in $FILE."
  fi
done

# 输出错误和警告的统计信息
echo "------------------------------------"
if [ "$ERROR_COUNT" -gt 0 ]; then
    echo "[ERROR] Total errors found: $ERROR_COUNT"
    echo "[ERROR] Files with errors:"
    # shellcheck disable=SC2039
    for file in "${ERROR_FILES[@]}"; do
        echo "    - $file"
    done
else
    echo "[INFO] No errors found."
fi

if [ "$WARNING_COUNT" -gt 0 ]; then
    echo "[WARNING] Total warnings found: $WARNING_COUNT"
    echo "[WARNING] Files with warnings:"
    # shellcheck disable=SC2039
    for file in "${WARNING_FILES[@]}"; do
        echo "    - $file"
    done
else
    echo "[INFO] No warnings found."
fi

# 根据分析结果决定是否退出
if [ "$ERROR_COUNT" -gt 0 ]; then
    echo "[ERROR] Errors found. Exiting with commit failure."
    exit 1
elif [ "$WARNING_COUNT" -gt 0 ]; then
    echo "[WARNING] Warnings found. Exiting with commit failure."
    exit 1
else
    echo "[INFO] No errors or warnings. Exiting successfully."
    exit 0
fi
