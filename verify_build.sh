#!/bin/bash

echo "🔍 验证4平台构建状态"
echo "检查仓库: https://github.com/miaokela/query-builder"
echo

# 获取最新提交信息
echo "📝 最新提交:"
git log --oneline -1
echo

# 检查workflow文件
echo "⚙️  Workflow配置检查:"
if [ -f ".github/workflows/build.yml" ]; then
    echo "✅ build.yml 存在"
    echo "🔧 构建矩阵平台:"
    grep -A 10 "matrix:" .github/workflows/build.yml | grep -E "(os:|target:|include:)" | head -8
else
    echo "❌ build.yml 不存在"
fi
echo

# 检查平台配置
echo "🏗️  平台配置验证:"
echo "Platform | Runner        | Target"
echo "---------|---------------|---------------------------"
echo "Windows  | windows-latest| x86_64-pc-windows-msvc"
echo "macOS x64| macos-12      | x86_64-apple-darwin"
echo "macOS ARM| macos-14      | aarch64-apple-darwin"
echo "Linux    | ubuntu-latest | x86_64-unknown-linux-gnu"
echo

echo "📦 预期wheel文件 (20个):"
echo "Python版本: 3.8, 3.9, 3.10, 3.11, 3.12"
echo "文件格式:"
echo "  - query_builder-*-cp38-abi3-win_amd64.whl"
echo "  - query_builder-*-cp38-abi3-macosx_10_12_x86_64.whl"
echo "  - query_builder-*-cp38-abi3-macosx_11_0_arm64.whl"
echo "  - query_builder-*-cp38-abi3-linux_x86_64.whl"
echo "  (每个Python版本重复以上4个平台)"
echo

echo "🎯 下一步操作:"
echo "1. 手动触发构建: https://github.com/miaokela/query-builder/actions"
echo "2. 等待构建完成(约10-15分钟)"
echo "3. 验证所有平台成功"
echo "4. 下载artifacts检查wheel文件"
echo "5. 如果成功，打tag发布到PyPI"
echo

echo "🏷️  发布命令(构建成功后):"
echo "  git tag v0.1.X"
echo "  git push origin v0.1.X"
echo "  # 这会自动触发PyPI发布"