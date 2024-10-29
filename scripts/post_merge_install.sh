#!/bin/sh

# Git 仓库根目录，由宿主工程传入
GIT_ROOT=$1

# 确定 Git hooks 文件夹
GIT_HOOKS="$GIT_ROOT/.git/hooks"
HOOKS_FILE="$GIT_HOOKS/post-merge"

# 确保 Git hooks 目录存在
mkdir -p "$GIT_HOOKS"

# 将脚本内容写入 post-checkout 文件
cat post_merge_hook.sh > "$HOOKS_FILE"

# 为 post-checkout 钩子添加可执行权限
chmod +x "$HOOKS_FILE"

echo "Post-merge hook script has been written and made executable."


## 获取脚本所在目录的绝对路径
#SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
## 项目根目录
#PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
#
## shellcheck disable=SC2028
#echo "\n Start run post_merge_install.sh \n"
#
## 确保在项目根目录运行
#cd "$PROJECT_ROOT" || exit
## 获取git hook 文件路径
#HOOK_DIR=$(git rev-parse --show-toplevel)/.git/hooks
#
##删除老脚本
#echo "Delete existing post-merge script ..."
#rm -f "$HOOK_DIR"/post-merge
#echo "Create new post-merge script ..."
#touch "$HOOK_DIR"/post-merge
#chmod +x "$HOOK_DIR"/post-merge
## 定义要写入文件的内容
## shellcheck disable=SC2016
#HOOK_CONTENT='#!/bin/sh
##获取脚本所在路径
#SCRIPT_DIR="$(cd "$(dirname "$0")" && cd ../../.code_check_scripts && pwd)"
##设置文件可执行
#chmod +x $SCRIPT_DIR/post_merge_hook.sh
##执行merge之后的脚本
#$SCRIPT_DIR/post_merge_hook.sh
#'
#
## 指定文件路径
#HOOK_FILE="$HOOK_DIR/post-merge"
#
## 将内容写入文件
#echo "Writing content to file: $HOOK_FILE"
#echo "$HOOK_CONTENT" > "$HOOK_FILE"
#
## 设置文件可执行
#echo "Setting executable permission for: post-merge"
#chmod +x "$HOOK_FILE"
#echo "Post-merge hook script written to post-merge and made executable."
