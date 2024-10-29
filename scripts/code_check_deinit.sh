#!/bin/sh

# 检查当前路径是否在 Git 仓库中
if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    # Git 仓库根目录
    GIT_ROOT=$(git rev-parse --show-toplevel)
    # 确定 Git hooks 文件夹
    GIT_HOOKS="$GIT_ROOT/.git/hooks"
    echo "Remove $GIT_HOOKS config..."
    rm -f "$GIT_HOOKS/pre-commit"
    rm -f "$GIT_HOOKS/commit-msg"
    rm -f "$GIT_HOOKS/post-merge"
    rm -f "$GIT_HOOKS/post-checkout"

#    rm -rf "$HOME/.code_check_scripts"
else
    echo "This command need to run in a Git repository."
fi