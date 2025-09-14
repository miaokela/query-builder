#!/bin/bash

echo "🔄 回退到简单maturin-action方案"
echo "=========================="
echo "回退时间: $(date)"
echo ""

echo "🐛 cibuildwheel问题:"
echo "❌ puccinialin包不存在错误"
echo "❌ 配置过于复杂导致依赖问题"
echo "❌ 可能是cibuildwheel与maturin版本兼容性问题"
echo ""

echo "🔄 回退策略:"
echo "1. ✅ 禁用cibuildwheel workflow"
echo "2. ✅ 启用简单maturin-action workflow"
echo "3. ✅ 使用--abi3-python-version参数"
echo "4. ✅ 移除复杂的环境变量配置"
echo ""

# 禁用cibuildwheel workflow
echo "🔧 禁用cibuildwheel workflow..."
mv .github/workflows/build-cibuildwheel.yml .github/workflows/build-cibuildwheel.yml.disabled

# 启用简单maturin workflow
echo "🔧 启用简单maturin workflow..."
echo "新workflow: build-simple-maturin.yml"

echo "📋 简单方案对比:"
echo "| 特性              | cibuildwheel      | maturin-action     |"
echo "|------------------|-------------------|--------------------|"
echo "| 复杂度            | ⚠️  高            | ✅ 低              |"
echo "| 依赖管理          | ❌ 复杂           | ✅ 简单            |"
echo "| abi3支持         | ⚠️  间接          | ✅ 直接            |"
echo "| 错误调试          | ❌ 困难           | ✅ 容易            |"
echo ""

echo "🔍 新workflow关键配置:"
echo "args: --release --out dist --interpreter 3.8 3.9 3.10 3.11 3.12 --abi3-python-version 3.8"
echo "env: PYO3_USE_ABI3_FORWARD_COMPATIBILITY=1"
echo ""

# 更新版本号
echo "📝 更新版本到 v0.1.10"
sed -i '' 's/version = "0.1.9"/version = "0.1.10"/' Cargo.toml
sed -i '' 's/version = "0.1.9"/version = "0.1.10"/' pyproject.toml

echo "🚀 提交回退方案..."
git add .
git commit -m "🔄 回退到简单maturin-action: 避免cibuildwheel依赖问题"
git push

# 创建新标签
echo "🏷️ 创建标签 v0.1.10"
git tag v0.1.10
git push origin v0.1.10

echo ""
echo "✅ v0.1.10 简单方案已发布!"
echo "监控地址: https://github.com/miaokela/query-builder/actions"
echo ""
echo "🎯 预期改进:"
echo "- 不再有puccinialin错误"
echo "- 直接使用maturin构建abi3 wheels"
echo "- 更简单的错误调试"
echo "- 可靠的4平台构建"
echo ""
echo "📊 如果这次还有问题:"
echo "- 可能需要检查PyO3版本兼容性"
echo "- 或者maturin-action版本问题"
echo "- 最后选择可以手动构建wheels"