#!/bin/bash
# 获取远程仓库最新 tag 的脚本

# 使用方法:
#   ./get-latest-tag.sh [remote] [branch]
#   例如: ./get-latest-tag.sh origin main

REMOTE=${1:-origin}
BRANCH=${2:-main}

# 确保远程仓库最新
git fetch --tags "$REMOTE"

# 获取最新 tag
LATEST_TAG=$(git describe --tags "$REMOTE"/"$BRANCH" 2>/dev/null | sed 's/^v//')

if [ -z "$LATEST_TAG" ]; then
    echo "未找到 tag"
    exit 1
fi

echo "$LATEST_TAG"
