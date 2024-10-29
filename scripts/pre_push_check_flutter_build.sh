#!/bin/sh

# 获取脚本所在目录的绝对路径
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# 项目根目录
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# 确保在项目根目录运行
echo "进入项目根目录$PROJECT_ROOT"
cd "$PROJECT_ROOT" || exit

echo "拉取当前分支的最新代码"
# 获取当前 Git 分支名称
current_branch=$(git rev-parse --abbrev-ref HEAD)
# 检查命令是否成功执行
if [ $? -ne 0 ]; then
    echo "Error: Not a git repository or no git branch found."
    exit 1
fi
# 输出当前分支名称
echo "当前分支: $current_branch"
# 拉取当前分支的最新代码
git pull origin "$current_branch"
# 检查命令是否成功执行
# shellcheck disable=SC2181
if [ $? -eq 0 ]; then
    echo "Successfully pulled the latest code for branch $current_branch."
else
    echo "Failed to pull the latest code for branch $current_branch."
    exit 1
fi

echo "Updating dependencies"
flutter pub get
flutter build apk

# 确保脚本在发生错误时停止
set -e
# 清理上一次的构建
echo "清理上一次的构建..."
flutter clean

# 构建发布版 APK，并分离 ABI
echo "开始构建 APK..."
flutter build apk --release --split-per-abi

# 检查构建是否成功
# shellcheck disable=SC2181
if [ $? -eq 0 ]; then
    echo "APK 构建成功，文件位于 build/app/outputs/flutter-apk/ 目录中。"
else
    echo "Error: APK 构建失败，请检查错误信息。"
    exit 1
fi
