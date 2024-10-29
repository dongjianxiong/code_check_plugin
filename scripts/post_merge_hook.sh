#!/bin/sh

echo "Start run post merge hook"

# 当前Git仓库根目录
GIT_ROOT=$(git rev-parse --show-toplevel)
echo "[INFO] GIT_ROOT: $GIT_ROOT"
cd "$GIT_ROOT" || exit

# 判断是否是flutter工程根目录
# shellcheck disable=SC2039
REQUIRED_FILES=("pubspec.yaml" "android" "ios" "lib")
# 遍历所需的文件或文件夹来检查它们是否存在
is_flutter_project_root=true
# shellcheck disable=SC2039
for file in "${REQUIRED_FILES[@]}"; do
  if [ ! -e "$file" ]; then
    is_flutter_project_root=false
    break
  fi
done

# 如果是flutter项目，更新依赖
if [ "$is_flutter_project_root" = true ]; then
  echo "Current directory is a Flutter project root."
  echo "Updating dependencies"
  flutter pub get
else
  echo "Current directory is not a Flutter project root."
fi

# 确保 ios 目录存在
if [ -d "ios" ]; then
  cd ios || exit
  echo "Running pod install"
  pod install
else
  echo "No 'ios' directory found in the project"
fi
