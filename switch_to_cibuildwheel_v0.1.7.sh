#!/bin/bash

echo "🔄 切换到cibuildwheel构建方案 - v0.1.7"
echo "======================================="
echo "切换时间: $(date)"
echo ""

echo "🐛 持续问题:"
echo "maturin-action在Windows上仍然尝试链接python38.lib"
echo "PYO3_NO_PYTHON=1 环境变量似乎没有生效"
echo "需要更可靠的构建方案"
echo ""

echo "🔧 新方案: cibuildwheel"
echo "1. ✅ 创建新的workflow: build-cibuildwheel.yml"
echo "2. ✅ 更新pyproject.toml支持cibuildwheel"
echo "3. ✅ 添加Windows特定的环境配置"
echo "4. ✅ 暂时禁用原workflow避免冲突"
echo ""

echo "📝 cibuildwheel优势:"
echo "- 更成熟的跨平台wheel构建"
echo "- 更好的Windows支持"
echo "- 原生支持abi3配置"
echo "- 更可靠的环境变量处理"
echo ""

# 暂时禁用原workflow
echo "🔧 暂时禁用原workflow..."
mv .github/workflows/build.yml .github/workflows/build.yml.disabled
echo "原workflow已重命名为 build.yml.disabled"
echo ""

echo "🔍 当前配置检查:"
echo "新workflow文件:"
ls -la .github/workflows/build-cibuildwheel.yml
echo ""
echo "pyproject.toml cibuildwheel配置:"
grep -A 10 "\[tool.cibuildwheel\]" pyproject.toml
echo ""

# 更新版本号
echo "📝 更新版本到 v0.1.7"
sed -i '' 's/version = "0.1.6"/version = "0.1.7"/' Cargo.toml
sed -i '' 's/version = "0.1.6"/version = "0.1.7"/' pyproject.toml

echo "🚀 提交并发布..."
git add .
git commit -m "🔄 切换到cibuildwheel: 解决Windows python38.lib链接问题"
git push

# 创建新标签
echo "🏷️ 创建标签 v0.1.7"
git tag v0.1.7
git push origin v0.1.7

echo ""
echo "✅ v0.1.7 cibuildwheel方案已发布!"
echo "监控地址: https://github.com/miaokela/query-builder/actions"
echo ""
echo "🎯 预期改进:"
echo "- cibuildwheel原生支持abi3"
echo "- 更可靠的Windows构建"
echo "- 环境变量正确处理"
echo "- 所有4平台成功构建"
echo ""
echo "📊 如果这次还不成功，下一步可以考虑:"
echo "- 调整abi3最小版本要求"
echo "- 使用setuptools-rust作为备选"
echo "- 或者暂时排除Windows平台专注其他平台"