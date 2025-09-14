#!/bin/bash

echo "🚀 手动触发4平台构建测试"
echo "Platform Configuration:"
echo "  - Windows x64    (windows-latest)"
echo "  - macOS Intel    (macos-12)" 
echo "  - macOS Apple    (macos-14)"
echo "  - Linux x64      (ubuntu-latest)"
echo

# 检查是否有 gh CLI
if command -v gh &> /dev/null; then
    echo "使用 GitHub CLI 触发构建..."
    gh workflow run build.yml
    echo "✅ 构建已触发"
    echo "查看状态: https://github.com/miaokela/query-builder/actions"
else
    echo "⚠️  GitHub CLI 未安装"
    echo "请通过以下方式手动触发："
    echo "1. 访问 https://github.com/miaokela/query-builder/actions"
    echo "2. 点击 'Build and Test'"
    echo "3. 点击 'Run workflow'"
    echo "4. 选择 'main' 分支"
    echo "5. 点击 'Run workflow' 按钮"
    echo
    echo "或者安装 GitHub CLI:"
    echo "  brew install gh"
    echo "  gh auth login"
    echo "  ./trigger_build.sh"
fi

echo
echo "🔍 构建完成后将产生20个wheel文件:"
echo "  Python 3.8-3.12 × 4平台 = 20个wheels"
echo "  预期文件模式: query_builder-*-cp3*-abi3-{win_amd64,macosx_*,linux_x86_64}.whl"