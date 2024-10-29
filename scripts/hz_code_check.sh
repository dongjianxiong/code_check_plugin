#!/bin/bash


# 检查当前路径是否在 Git 仓库中，若不是 Git 仓库则退出
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "[ERROR] 当前路径不是一个 Git 仓库。"
    exit 1  # 退出脚本
fi

# 获取第一个参数
ACTION="$1"
# 检查是否传入了参数
if [ -z "$ACTION" ]; then
    echo "[ERROR] 没有提供任何参数。"
    echo "用法: hz_code_check [install|uninstall|update]"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "[INFO] 当前脚本路径SCRIPT_DIR:$SCRIPT_DIR"
# 根据 ACTION 参数执行不同操作
if [ "$ACTION" == "install" ]; then
    # 安装代码检查命令
    echo "[INFO] 正在安装代码检查命令..."
    chmod +x "$SCRIPT_DIR"/code_check_init.sh
    sh "$SCRIPT_DIR"/code_check_init.sh
    echo "[INFO] 代码检查命令已成功安装。"

elif [ "$ACTION" == "uninstall" ]; then
    # 卸载代码检查命令
    echo "[INFO] 正在卸载代码检查命令..."
    chmod +x "$SCRIPT_DIR"/code_check_deinit.sh
    sh "$SCRIPT_DIR"/code_check_deinit.sh
    echo "[INFO] 卸载代码检查命令完成..."
elif [ "$ACTION" == "update" ]; then
    # 卸载代码检查命令
    echo "[INFO] 正在更新代码检查命令..."
    chmod +x "$SCRIPT_DIR"/code_check_deinit.sh
    sh "$SCRIPT_DIR"/code_check_deinit.sh
    chmod +x "$SCRIPT_DIR"/code_check_init.sh
    sh "$SCRIPT_DIR"/code_check_init.sh
    echo "[INFO] 更新代码检查命令完成..."
else
    # 如果传入的参数无效
    echo "[ERROR] 无效的参数: $ACTION"
    echo "用法: hz_code_check [install|uninstall|update]"
    exit 1
fi

