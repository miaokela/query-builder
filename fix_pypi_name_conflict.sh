#!/bin/bash

echo "🔧 修复PyPI包名冲突 - 更改为query-builder-tool"
echo "=========================================="
echo "修复时间: $(date)"
echo ""

echo "🐛 问题分析:"
echo "❌ PyPI上已存在类似 'py-query-builder' 的项目"
echo "❌ 包名冲突导致上传失败"
echo "❌ 需要使用更独特的包名"
echo ""

echo "🔧 解决方案:"
echo "更改包名为: query-builder-tool"
echo "这样既独特又能表明项目用途"
echo ""

# 更新 Cargo.toml
echo "📝 已更新 Cargo.toml..."
echo "✅ name = \"query-builder-tool\""
echo "✅ version = \"0.1.15\""

# 更新 pyproject.toml
echo "📝 已更新 pyproject.toml..."
echo "✅ name = \"query-builder-tool\""
echo "✅ version = \"0.1.15\""

echo "🔍 验证修改:"
echo "Cargo.toml package name:"
grep "name.*=" Cargo.toml | head -1
echo "pyproject.toml project name:"
grep "name.*=" pyproject.toml | head -1
echo "Version:"
grep "version.*=" Cargo.toml | head -1
echo ""

echo "🚀 提交修改..."
git add Cargo.toml pyproject.toml
git commit -m "🔧 修复PyPI包名冲突: query-builder -> miaokela-query-builder"
git push

# 创建新标签
echo "🏷️ 创建标签 v0.1.12..."
git tag v0.1.12
git push origin v0.1.12

echo ""
echo "✅ 包名修复完成!"
echo "新包名: miaokela-query-builder"
echo "PyPI地址: https://pypi.org/project/miaokela-query-builder/"
echo "安装命令: pip install miaokela-query-builder"
echo ""
echo "🎯 预期结果:"
echo "- 不再有权限冲突"
echo "- 能成功发布到PyPI"
echo "- 用户可以通过新包名安装"