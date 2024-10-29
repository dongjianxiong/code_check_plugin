#!/bin/sh

echo "Checking commit message format..."

COMMIT_MSG_FILE=$1
echo "Commit message file: $COMMIT_MSG_FILE"
if [ ! -f "$COMMIT_MSG_FILE" ]; then
    echo "Error: Commit message file not found!"
    exit 1
fi

COMMIT_MSG=$(cat "$COMMIT_MSG_FILE")
echo "Commit message: $COMMIT_MSG"

# 如果提交消息包含 "Merge" 字符串，则不做任何检查，直接退出
# shellcheck disable=SC2039
if [[ "$COMMIT_MSG" =~ ^Merge ]]; then
  echo "[INFO] Merge commit detected. Skipping commit message check."
  exit 0
fi

# Define the regex for the commit message format
ID_REGEX="(t|f)-[A-Za-z0-9]+"
#COMMIT_MSG_REGEX="^(feat|fix|docs|style|refactor|perf|test|chore|revert)\($ID_REGEX\): .+$"
COMMIT_MSG_REGEX="^(feat|fix|docs|style|refactor|perf|test|chore|revert)\($ID_REGEX(, $ID_REGEX)*\): .+$"

# 检查提交信息是否符合正则表达式
if ! echo "$COMMIT_MSG" | grep -Eq "$COMMIT_MSG_REGEX"; then
    echo "提交信息格式不正确，请遵循以下格式："
    echo ""
    echo "  格式: <type>(<ID>): <subject>"
    echo ""
    echo "  可用的 <type> 有:"
    echo "    feat     : 新功能 (feature)"
    echo "    fix      : 修复问题，需要填写 bug ID 及描述"
    echo "    docs     : 仅仅修改了文档"
    echo "    style    : 仅对格式进行修改，如逗号、缩进、空格等，不改变代码逻辑"
    echo "    refactor : 代码重构，没有新增功能或修复 bug"
    echo "    perf     : 性能优化相关，如提升性能或用户体验"
    echo "    test     : 测试用例的新增或修改，包括单元测试、集成测试"
    echo "    chore    : 改变构建流程、增加依赖库、工具等"
    echo "    revert   : 版本回滚"
    echo ""
    echo "  可用的 <ID> 有:"
#    echo "    m-<需求ID>  : 需求ID"
    echo "    t-<任务ID>  : 任务ID"
    echo "    f-<缺陷ID>  : 缺陷ID"
    echo ""
    echo "  示例:"
    echo "    feat(t-12345): 新增用户登录功能"
    echo "    feat(t-12345, t-67890): 新增用户登录功能"
    echo "    fix(f-67890): 修复用户注册时崩溃的问题"
    echo "    fix(f-67890, f-124234): 修复用户注册时崩溃的问题"
    echo "    feat(t-12345, f-67890): 新增用户登录功能"
    echo ""
    exit 1 # 非 0 状态退出表示校验失败
fi

echo "The submit message check passed"
