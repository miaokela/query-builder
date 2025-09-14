#!/bin/bash

echo "🔧 综合修复Windows构建和PyO3弃用警告 - v0.1.6"
echo "=============================================="
echo "修复时间: $(date)"
echo ""

echo "🐛 问题汇总:"
echo "1. ❌ Windows仍然报python38.lib链接错误"
echo "2. ⚠️  PyO3弃用警告需要更新"
echo "3. 🔧 abi3配置需要更强制的设置"
echo ""

echo "🔧 本次修复:"
echo "1. ✅ 修复PyO3弃用警告: Option<&Bound<'_, PyDict>>"
echo "2. ✅ 修复PyO3弃用警告: &Bound<'_, PyModule>"
echo "3. ✅ 添加PYO3_NO_PYTHON=1强制abi3模式"
echo "4. ✅ Cargo.toml添加python-source配置"
echo ""

echo "📝 技术详解:"
echo "PYO3_NO_PYTHON=1: 强制PyO3不链接特定Python版本库"
echo "abi3-py38: 使用稳定ABI，与Python 3.8+兼容"
echo "python-source: 指定Python来源为registry"
echo ""

# 检查修复内容
echo "🔍 修复内容验证:"
echo "PyO3弃用警告修复:"
grep -n "Bound<'_, PyDict>" src/lib.rs
grep -n "Bound<'_, PyModule>" src/lib.rs
echo ""
echo "Cargo.toml配置:"
grep -A 3 "pyo3.*abi3" Cargo.toml
grep -A 2 "python-source" Cargo.toml
echo ""
echo "Workflow环境变量:"
grep -A 2 "PYO3_NO_PYTHON" .github/workflows/build.yml
echo ""

echo "🚀 提交并发布修复..."
git add .
git commit -m "🔧 综合修复: PyO3弃用警告 + Windows强制abi3模式 (PYO3_NO_PYTHON=1)"

# 更新版本号
echo "📝 更新版本到 v0.1.6"
sed -i '' 's/version = "0.1.5"/version = "0.1.6"/' Cargo.toml
git add Cargo.toml
git commit -m "📝 版本更新: v0.1.6"

git push

# 创建新标签
echo "🏷️ 创建标签 v0.1.6"
git tag v0.1.6
git push origin v0.1.6

echo ""
echo "✅ v0.1.6 综合修复已发布!"
echo "监控地址: https://github.com/miaokela/query-builder/actions"
echo ""
echo "🎯 本次修复预期:"
echo "- Windows: 不再尝试链接python38.lib"
echo "- 警告: 消除PyO3弃用警告"
echo "- abi3: 强制使用稳定ABI模式"
echo "- 构建: 所有4平台成功构建"
echo ""
echo "📊 如果仍有问题，可能需要考虑:"
echo "- 使用cibuildwheel替代maturin-action"
echo "- 或者在Windows上使用不同的构建策略"