#!/bin/bash

# 文件路径
FILE="pubspec.yaml"
IOS_PODSPEC="ios/code_check_plugin.podspec"

# 读取 pubspec.yaml 中的版本号
VERSION_LINE=$(grep 'version:' $FILE)
# shellcheck disable=SC2001
CURRENT_VERSION=$(echo "$VERSION_LINE" | sed 's/version: //')
echo "当前版本: $CURRENT_VERSION"

# 获取自增类型或指定版本号
TYPE=$1

# 检查传入参数是否为 auto 或版本号
if [ "$TYPE" == "auto" ]; then
  # 分割当前版本号并自增最后一位
  HEAD_VERSION=$(echo "$CURRENT_VERSION" | cut -d'.' -f1)
  MID_VERSION=$(echo "$CURRENT_VERSION" | cut -d'.' -f2)
  LAST_VERSION=$(echo "$CURRENT_VERSION" | cut -d'.' -f3)
  LAST_VERSION=$((LAST_VERSION + 1))
  NEW_VERSION="${HEAD_VERSION}.${MID_VERSION}.${LAST_VERSION}"
  echo "自动自增版本: $NEW_VERSION"

# 检查是否传入了有效的版本号格式
elif [[ $TYPE =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  NEW_VERSION="$TYPE"
  echo "指定版本: $NEW_VERSION"

# 参数为空或传入了无效参数
else
  echo "[ERROR] 无效的参数，请输入 'auto' 来自增版本号，或者传入正确的版本号 (例如: 1.0.1)"
  echo ""
  echo "  示例: sh release.sh auto"
  echo "  示例: sh release.sh 1.0.1"
  echo ""
  exit 1
fi

# 替换 pubspec.yaml 中的版本号
sed -i '' "s/version: $CURRENT_VERSION/version: $NEW_VERSION/" $FILE

# 替换 iOS 的版本号
sed -i '' "s/s.version *= *'[^']*'/s.version = '${NEW_VERSION}'/" "$IOS_PODSPEC"

# 检查替换结果
PLUGIN_VERSION_LINE=$(grep 'version:' $FILE)
# shellcheck disable=SC2001
CURRENT_PLUGIN_VERSION=$(echo "$PLUGIN_VERSION_LINE" | sed 's/version: //')
if [ "$CURRENT_PLUGIN_VERSION" == "$NEW_VERSION" ]; then
  echo "插件版本号已成功更新为 ${NEW_VERSION}"
else
  echo "[ERROR] 插件版本号更新失败"
fi

if grep -q "s.version = '${NEW_VERSION}'" "$IOS_PODSPEC"; then
  echo "iOS 版本号已成功更新为 ${NEW_VERSION}"
else
  echo "[ERROR] iOS 版本号更新失败"
fi

# shellcheck disable=SC2164
cd example/
flutter pub get
# shellcheck disable=SC2164
cd ios/
pod install
cd ../../
#flutter run


# 升级版本号
echo "升级版本号： $NEW_VERSION"