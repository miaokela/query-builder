#!/bin/bash

echo "🚨 紧急修复: maturin配置错误 - v0.1.8"
echo "===================================="
echo "修复时间: $(date)"
echo ""

echo "🐛 错误分析:"
echo "maturin failed: python source path 'python' does not exist"
echo "问题: pyproject.toml中错误的python-source配置"
echo "原因: 不应该指定python-source为'python'目录"
echo ""

echo "🔧 修复措施:"
echo "1. ✅ 移除错误的python-source配置"
echo "2. ✅ 修正build-verbosity类型(字符串→整数)"
echo "3. ✅ 保持module-name和features配置"
echo "4. ✅ 简化maturin配置为必要项"
echo ""

echo "📝 修复后的配置:"
echo "[tool.maturin]配置:"
grep -A 3 "\[tool.maturin\]" pyproject.toml
echo ""
echo "cibuildwheel环境变量:"
grep -A 2 "environment.*PYO3" pyproject.toml
echo ""

# 更新版本号
echo "📝 更新版本到 v0.1.8"
sed -i '' 's/version = "0.1.7"/version = "0.1.8"/' Cargo.toml
sed -i '' 's/version = "0.1.7"/version = "0.1.8"/' pyproject.toml

echo "🚀 提交紧急修复..."
git add .
git commit -m "🚨 紧急修复: 移除错误的python-source配置，修正build-verbosity类型"
git push

# 创建新标签
echo "🏷️ 创建标签 v0.1.8"
git tag v0.1.8
git push origin v0.1.8

echo ""
echo "✅ v0.1.8 紧急修复已发布!"
echo "监控地址: https://github.com/miaokela/query-builder/actions"
echo ""
echo "🎯 修复预期:"
echo "- maturin不再寻找'python'目录"
echo "- 使用项目根目录作为源码路径"
echo "- cibuildwheel配置正确应用"
echo "- 4平台构建恢复正常"
echo ""
echo "📊 技术细节:"
echo "maturin会自动检测Rust源码和Cargo.toml"
echo "不需要明确指定python-source路径"
echo "abi3配置通过features正确传递"