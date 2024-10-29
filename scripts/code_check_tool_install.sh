#!/bin/bash

# 获取 Git 根目录和脚本目录
GIT_ROOT=$(git rev-parse --show-toplevel)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 日志输出函数
log_info() {
  echo "[INFO] $1"
}

log_warning() {
  echo "[WARNING] $1"
}

log_error() {
  echo "[ERROR] $1"
}

# 执行插件目录下的 code_check_deinit.sh 脚本,移除老命令
DEINIT_SCRIPT="$SCRIPT_DIR/code_check_deinit.sh"
if [ -f "$DEINIT_SCRIPT" ]; then
  chmod +x "$DEINIT_SCRIPT"
  log_info "Executing code_check_deinit.sh..."
  sh "$DEINIT_SCRIPT"
else
  log_warning "Script code_check_deinit.sh not found in $SCRIPT_DIR. Skipping execution."
fi

# 执行插件目录下的 code_check_init.sh 脚本
INIT_SCRIPT="$SCRIPT_DIR/code_check_init.sh"
if [ -f "$INIT_SCRIPT" ]; then
  chmod +x "$INIT_SCRIPT"
  log_info "Executing code_check_init.sh..."
  sh "$INIT_SCRIPT"
else
  log_warning "Script code_check_init.sh not found in $SCRIPT_DIR. Skipping execution."
fi

# 设置目标目录
TARGET_PATH_DIR="$GIT_ROOT/.code_check_scripts"

# 复制脚本到目标路径
# shellcheck disable=SC2115
rm -rf "$TARGET_PATH_DIR/" && mkdir -p "$TARGET_PATH_DIR"
cp -rf "$SCRIPT_DIR/"* "$TARGET_PATH_DIR/"


# shellcheck disable=SC2181
#if [ $? -eq 0 ]; then
#  TARGET_PATH="$TARGET_PATH_DIR/hz_code_check.sh"
#  chmod +x "$TARGET_PATH"  # 给脚本添加可执行权限
#  cp -f "$TARGET_PATH" "$TARGET_PATH_DIR/cc"
#  chmod +x "$TARGET_PATH_DIR/cc"
#  log_info "Script successfully copied to $TARGET_PATH and made executable."
#else
#  log_error "Failed to copy script to $TARGET_PATH."
#  exit 0
#fi

# 添加 .code_check_scripts 到 .gitignore 文件
GITIGNORE_FILE="$GIT_ROOT/.gitignore"
if ! grep -Fxq ".code_check_scripts" "$GITIGNORE_FILE"; then
  echo ".code_check_scripts" >> "$GITIGNORE_FILE"
  log_info "Added .code_check_scripts to .gitignore"
else
  log_info ".code_check_scripts already exists in .gitignore"
fi

## shellcheck disable=SC2164
#cd "$GIT_ROOT"
## 定义别名
#ALIAS_CMD="alias hz_code_check='sh $TARGET_PATH_DIR/hz_code_check.sh'"
#log_info "定义别名 $ALIAS_CMD"
## 检查并移除已存在的别名
#if alias hz_code_check &>/dev/null; then
#  unalias hz_code_check
#fi
## 设置别名
## shellcheck disable=SC2139
#alias hz_code_check="sh $TARGET_PATH_DIR/hz_code_check.sh"
#log_info "定义别名1 'sh $TARGET_PATH_DIR/hz_code_check.sh'"
#eval "$ALIAS_CMD"
#
## shellcheck disable=SC2164
#cd "$CURRENT_DIR"

## 检测当前使用的 shell
#CURRENT_SHELL=$(basename "$SHELL")
#if [ "$CURRENT_SHELL" == "bash" ]; then
#  SHELL_RC="$HOME/.bashrc"
#elif [ "$CURRENT_SHELL" == "zsh" ]; then
#  SHELL_RC="$HOME/.zshrc"
#else
#  log_warning "Unknown Shell: $CURRENT_SHELL. No configuration file will be modified."
#  exit 0
#fi
#if grep -q "alias hz_code_check=" "$SHELL_RC"; then
#  log_info "Alias 'hz_code_check' already exists in $SHELL_RC"
#else
#  echo "$ALIAS_CMD" >> "$SHELL_RC"
#  log_info "Alias 'hz_code_check' added to $SHELL_RC"
#fi
#
## 使别名更改生效
#log_info "Sourcing $SHELL_RC to apply changes..."
#if [ "$CURRENT_SHELL" == "bash" ]; then
#  # shellcheck disable=SC1090
#  source "$SHELL_RC"
#elif [ "$CURRENT_SHELL" == "zsh" ]; then
#  log_info "Please run 'source $SHELL_RC' manually in the terminal."
#else
#  log_error "Unsupported shell. Please use Bash or Zsh."
#  exit 0
#fi

log_info "You can now use 'hz_code_check [install|uninstall|update]'."
