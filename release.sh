#!/bin/bash

# Query Builder 预发布脚本
# 作者: 缪克拉 <2972799448@qq.com>
# GitHub: https://github.com/miaokela/query-builder

set -e

echo "🚀 Query Builder 预发布流程开始..."

# 检查当前目录
if [ ! -f "Cargo.toml" ]; then
    echo "❌ 请在 query-builder 项目根目录运行此脚本"
    exit 1
fi

echo "📋 当前包信息:"
echo "   - 包名: query-builder"
echo "   - 版本: 0.1.0"
echo "   - 作者: 缪克拉 <2972799448@qq.com>"
echo "   - GitHub: https://github.com/miaokela/query-builder"

echo ""
echo "📦 已构建的包:"
ls -la target/wheels/

echo ""
echo "🔧 可选操作:"
echo "1. 重新构建包 (可选)"
echo "2. 发布到 TestPyPI (测试)"
echo "3. 发布到正式 PyPI"

echo ""
read -p "选择操作 (1/2/3 或回车跳过): " choice

case $choice in
    1)
        echo "🔨 重新构建包..."
        maturin build --release
        echo "✅ 构建完成"
        ;;
    2)
        echo "🧪 发布到 TestPyPI..."
        echo "请确保已配置 TestPyPI 认证信息"
        read -p "继续? (y/N): " confirm
        if [[ $confirm =~ ^[Yy]$ ]]; then
            maturin publish --repository testpypi
        else
            echo "已取消发布到 TestPyPI"
        fi
        ;;
    3)
        echo "🚀 发布到正式 PyPI..."
        echo "⚠️  这将正式发布包到 PyPI，请确保:"
        echo "   - 版本号正确"
        echo "   - 包名可用"
        echo "   - 已在 TestPyPI 测试通过"
        read -p "确认发布到正式 PyPI? (y/N): " confirm
        if [[ $confirm =~ ^[Yy]$ ]]; then
            maturin publish
        else
            echo "已取消发布到正式 PyPI"
        fi
        ;;
    *)
        echo "跳过操作"
        ;;
esac

echo ""
echo "📖 更多信息:"
echo "   - 预发布指南: ./PRERELEASE.md"
echo "   - 发布指南: ./PUBLISH.md"
echo "   - 项目文档: ./README.md"

echo ""
echo "🎉 预发布流程完成!"