#!/bin/sh

# Git 仓库根目录，由宿主工程传入
GIT_ROOT=$1

# 确定 Git hooks 文件夹
GIT_HOOKS="$GIT_ROOT/.git/hooks"
HOOKS_FILE="$GIT_HOOKS/commit-msg"

# 确保 Git hooks 目录存在
mkdir -p "$GIT_HOOKS"

# 将脚本内容写入 post-checkout 文件
cat commit_msg_hook.sh > "$HOOKS_FILE"

# 为 post-checkout 钩子添加可执行权限
chmod +x "$HOOKS_FILE"

echo "Commit-msg hook script has been written and made executable."

## shellcheck disable=SC2028
#echo "\n Start run commit_msg_install.sh \n"
#
## 获取脚本所在目录的绝对路径
#SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
## 项目根目录
#PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
## 确保在项目根目录运行
#cd "$PROJECT_ROOT" || exit
## 获取git hook 文件路径
#HOOK_DIR=$(git rev-parse --show-toplevel)/.git/hooks
##删除老脚本
#echo "Delete existing commit-msg script  ..."
## shellcheck disable=SC2086
#rm -f $HOOK_DIR/commit-msg
#echo "Create new commit-msg script ..."
#touch "$HOOK_DIR"/commit-msg
## 定义要写入文件的内容
## shellcheck disable=SC2016
## shellcheck disable=SC1078
#HOOK_CONTENT='#!/bin/sh
##获取脚本所在路径
#SCRIPT_DIR="$(cd "$(dirname "$0")" && cd ../../.code_check_scripts && pwd)"
##设置文件可执行
#chmod +x $SCRIPT_DIR/commit_msg_hook.sh
##执行commit-msg的脚本
#$SCRIPT_DIR/commit_msg_hook.sh $1
#'
#
## 指定文件路径
#
#HOOK_FILE="$HOOK_DIR/commit-msg"
#
## 将内容写入文件
#echo "Writing content to file: $HOOK_FILE"
#echo "$HOOK_CONTENT" > "$HOOK_FILE"
#
## 使文件可执行
#echo "Setting executable permission for commit-msg"
#chmod +x "$HOOK_FILE"
#echo "Commit-msg hook script written to commit-msg and made executable."
