#!/bin/bash

# OpenClaw Manager 构建脚本
# 用法: ./build.sh

set -e

echo "🦞 开始构建 OpenClaw Manager..."

# 设置 Rust 环境变量 (Windows)
export CARGO_HOME="${CARGO_HOME:-/c/Users/$USER/.cargo}"
export RUSTUP_HOME="${RUSTUP_HOME:-/c/Users/$USER/.rustup}"
export PATH="$CARGO_HOME/bin:$PATH"

# 进入项目目录 (处理 Windows 路径)
cd "$(cd "$(dirname "$0")" && pwd)"

echo "当前目录: $(pwd)"

# 检查 Rust
echo "检查 Rust..."
cargo --version
rustc --version

# 安装依赖 (如果 node_modules 不存在)
if [ ! -d "node_modules" ]; then
    echo "📦 安装依赖..."
    npm install
fi

# 清理旧构建
echo "🧹 清理旧构建..."
rm -rf src-tauri/target/release/openclaw-manager.exe
rm -rf src-tauri/target/release/bundle

# 构建
echo "🔨 开始编译..."
npm run tauri build 2>&1

# 检查是否成功
if [ -f "src-tauri/target/release/openclaw-manager.exe" ]; then
    # 复制到 exec 目录
    echo "📂 复制到 exec 目录..."
    mkdir -p exec
    cp "src-tauri/target/release/openclaw-manager.exe" "exec/"
    
    if [ -f "src-tauri/target/release/bundle/nsis/OpenClaw Manager_0.0.7_x64-setup.exe" ]; then
        cp "src-tauri/target/release/bundle/nsis/OpenClaw Manager_0.0.7_x64-setup.exe" "exec/"
    fi
    
    echo "✅ 构建完成！"
    echo "📁 输出文件:"
    ls -lh exec/
else
    echo "❌ 构建失败，未找到 exe 文件"
    exit 1
fi
