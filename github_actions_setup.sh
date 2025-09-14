#!/bin/bash

# GitHub Actions 自动发布脚本
# 作者: 缪克拉 <2972799448@qq.com>

set -e

echo "🚀 开始 GitHub Actions 自动发布流程..."

# 检查当前目录
if [ ! -f "Cargo.toml" ]; then
    echo "❌ 请在 query-builder 项目根目录运行此脚本"
    exit 1
fi

# 检查 git 状态
if [ ! -d ".git" ]; then
    echo "❌ 未发现 .git 目录，请先初始化 git 仓库"
    exit 1
fi

echo "📋 项目信息:"
echo "   - 包名: query-builder"
echo "   - 版本: 0.1.0"
echo "   - 作者: 缪克拉 <2972799448@qq.com>"
echo "   - GitHub: https://github.com/miaokela/query-builder"

echo ""
echo "🔍 检查 GitHub Actions 配置..."
if [ ! -f ".github/workflows/build.yml" ]; then
    echo "❌ 未找到 GitHub Actions 配置文件"
    exit 1
fi
echo "✅ GitHub Actions 配置文件存在"

echo ""
echo "📦 检查本地构建..."
if [ ! -d "target/wheels" ]; then
    echo "🔨 先进行本地构建测试..."
    maturin build --release
fi
echo "✅ 本地构建正常"

echo ""
echo "📄 准备发布步骤:"
echo ""
echo "1️⃣ 确保代码已提交"
echo "2️⃣ 推送到 GitHub"
echo "3️⃣ 创建版本标签"
echo "4️⃣ 触发 GitHub Actions"

echo ""
read -p "是否继续发布流程? (y/N): " confirm

if [[ ! $confirm =~ ^[Yy]$ ]]; then
    echo "已取消发布"
    exit 0
fi

echo ""
echo "🔄 检查 git 状态..."
if [ -n "$(git status --porcelain)" ]; then
    echo "📝 发现未提交的更改，正在提交..."
    git add .
    git commit -m "Prepare for release v0.1.0" || echo "无新更改需要提交"
fi

echo ""
echo "🌐 推送到 GitHub..."
git branch -M main
git remote -v || echo "需要添加远程仓库"

echo ""
echo "⚠️  接下来需要您手动完成:"
echo ""
echo "1. 在 GitHub 创建仓库:"
echo "   https://github.com/new"
echo "   仓库名: query-builder"
echo "   可见性: Public"
echo ""
echo "2. 添加远程仓库并推送:"
echo "   git remote add origin https://github.com/miaokela/query-builder.git"
echo "   git push -u origin main"
echo ""
echo "3. 配置 PyPI API Token:"
echo "   - 访问: https://pypi.org/manage/account/token/"
echo "   - 创建新 Token"
echo "   - 在 GitHub 仓库 Settings > Secrets 添加:"
echo "     名称: PYPI_API_TOKEN"
echo "     值: 您的 PyPI Token"
echo ""
echo "4. 创建版本标签触发发布:"
echo "   git tag v0.1.0"
echo "   git push origin v0.1.0"
echo ""
echo "5. 查看构建进度:"
echo "   https://github.com/miaokela/query-builder/actions"
echo ""
echo "🎉 完成后，用户就可以使用:"
echo "   pip install query-builder"

echo ""
echo "📚 详细文档:"
echo "   - GitHub Actions 指南: ./GITHUB_ACTIONS_GUIDE.md"
echo "   - 完整发布指南: ./GITHUB_ACTIONS_COMPLETE_GUIDE.md"

echo ""
echo "✨ GitHub Actions 将自动:"
echo "   ✅ 在 Windows/Linux/macOS 构建包"
echo "   ✅ 运行测试"
echo "   ✅ 发布到 PyPI"
echo "   ✅ 支持所有平台的用户"

echo ""
echo "🚀 GitHub Actions 设置完成！"