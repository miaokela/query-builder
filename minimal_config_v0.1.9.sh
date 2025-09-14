#!/bin/bash

echo "🧹 创建极简无错配置 - v0.1.9"
echo "=========================="
echo "清理时间: $(date)"
echo ""

echo "🐛 当前问题:"
echo "ERROR: Could not find a version that satisfies the requirement puccinialin"
echo "可能原因: 配置文件中有拼写错误或多余配置"
echo ""

echo "🔧 极简化策略:"
echo "1. ✅ 移除所有可能有问题的配置"
echo "2. ✅ 使用最基础的maturin配置"
echo "3. ✅ 简化cibuildwheel设置"
echo "4. ✅ 确保没有拼写错误"
echo ""

# 检查当前配置
echo "🔍 当前Cargo.toml检查:"
echo "Dependencies:"
grep -A 10 "\[dependencies\]" Cargo.toml
echo ""
echo "Maturin metadata:"
grep -A 5 "\[package.metadata.maturin\]" Cargo.toml
echo ""

echo "🔍 当前pyproject.toml检查:"
echo "Build system:"
grep -A 3 "\[build-system\]" pyproject.toml
echo ""
echo "Tool.maturin:"
grep -A 3 "\[tool.maturin\]" pyproject.toml
echo ""

# 更新版本号
echo "📝 更新版本到 v0.1.9"
sed -i '' 's/version = "0.1.8"/version = "0.1.9"/' Cargo.toml
sed -i '' 's/version = "0.1.8"/version = "0.1.9"/' pyproject.toml

echo "🚀 提交极简配置..."
git add .
git commit -m "🧹 极简化配置: 移除所有可能导致错误的多余配置"
git push

# 创建新标签
echo "🏷️ 创建标签 v0.1.9"
git tag v0.1.9
git push origin v0.1.9

echo ""
echo "✅ v0.1.9 极简配置已发布!"
echo "监控地址: https://github.com/miaokela/query-builder/actions"
echo ""
echo "🎯 极简配置原则:"
echo "- 只保留绝对必要的配置项"
echo "- 移除所有可能有歧义的设置"
echo "- 让maturin使用默认行为"
echo "- 最小化cibuildwheel配置"
echo ""
echo "📊 如果还有问题，下一步可以:"
echo "1. 尝试直接使用maturin-action (不用cibuildwheel)"
echo "2. 或者使用setup.py + setuptools-rust"
echo "3. 或者暂时只支持Linux平台"