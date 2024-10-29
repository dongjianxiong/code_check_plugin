#!/bin/sh

GIT_ROOT=$(git rev-parse --show-toplevel)

# 获取脚本所在目录的绝对路径
# shellcheck disable=SC2034
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC2164
cd "$SCRIPT_DIR"

chmod +x pre_commit_install.sh
chmod +x commit_msg_install.sh

#chmod +x post_merge_install.sh
#chmod +x post_checkout_install.sh

sh pre_commit_install.sh "$GIT_ROOT"
sh commit_msg_install.sh "$GIT_ROOT"

#sh post_merge_install.sh "$GIT_ROOT"
#sh post_checkout_install.sh "$GIT_ROOT"

