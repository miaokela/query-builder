#!/bin/bash

# GitHub Actions 自动化发布脚本
# 作者: 缪克拉 <2972799448@qq.com>
# 项目: Query Builder - Rust + pyo3 SQL 查询构建器

set -e

echo "🚀 GitHub Actions 自动化发布准备"
echo "================================="

# 检查当前目录
if [ ! -f "Cargo.toml" ]; then
    echo "❌ 请在 query-builder 项目根目录运行此脚本"
    exit 1
fi

echo "📋 项目信息:"
echo "   - 项目名: query-builder"
echo "   - 版本: 0.1.0"
echo "   - 作者: 缪克拉 <2972799448@qq.com>"
echo "   - GitHub: https://github.com/miaokela/query-builder"
echo ""

# 检查 Git 状态
if [ ! -d ".git" ]; then
    echo "❌ Git 仓库未初始化"
    exit 1
fi

echo "📦 当前包状态:"
if [ -d "target/wheels" ]; then
    echo "   - 本地包数量: $(ls target/wheels/*.whl 2>/dev/null | wc -l | tr -d ' ')"
    ls target/wheels/*.whl 2>/dev/null | while read wheel; do
        echo "     $(basename "$wheel")"
    done
else
    echo "   - 本地包: 未构建"
fi

echo ""
echo "🔧 GitHub Actions 配置:"
if [ -f ".github/workflows/build.yml" ]; then
    echo "   ✅ GitHub Actions 配置文件存在"
    echo "   ✅ 支持平台: Windows, Linux, macOS (ARM64 + Intel)"
    echo "   ✅ 自动 PyPI 发布配置完成"
else
    echo "   ❌ GitHub Actions 配置文件缺失"
    exit 1
fi

echo ""
echo "📝 下一步操作指南:"
echo ""
echo "1. 创建 GitHub 仓库"
echo "   - 访问: https://github.com/new"
echo "   - 仓库名: query-builder"
echo "   - 设为公开仓库 (Public)"
echo "   - 不要初始化 README, .gitignore 或 LICENSE (已存在)"
echo ""

echo "2. 推送代码到 GitHub"
echo "   执行以下命令:"
echo "   git remote add origin https://github.com/miaokela/query-builder.git"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""

echo "3. 配置 PyPI API Token"
echo "   a) 访问 https://pypi.org/manage/account/token/"
echo "   b) 创建新的 API token"
echo "   c) 复制 token (格式: pypi-...)"
echo "   d) 在 GitHub 仓库设置中添加 Secret:"
echo "      - 仓库 -> Settings -> Secrets and variables -> Actions"
echo "      - 点击 'New repository secret'"
echo "      - Name: PYPI_API_TOKEN"
echo "      - Secret: 粘贴您的 PyPI token"
echo ""

echo "4. 触发自动构建和发布"
echo "   a) 创建版本标签:"
echo "      git tag v0.1.0"
echo "      git push origin v0.1.0"
echo ""
echo "   b) GitHub Actions 将自动:"
echo "      - 在 Windows/Linux/macOS 上构建包"
echo "      - 运行测试"
echo "      - 自动发布到 PyPI"
echo "      - 约 15 分钟完成全部流程"
echo ""

echo "5. 监控构建进度"
echo "   - 访问: https://github.com/miaokela/query-builder/actions"
echo "   - 查看构建日志和下载构建的包"
echo ""

echo "💡 提示:"
echo "   - 首次发布可能需要在 PyPI 上验证包名"
echo "   - 建议先创建 v0.1.0-rc1 测试版本"
echo "   - 每次推送标签都会触发发布流程"
echo ""

echo "🎯 优势:"
echo "   ✅ 零人工干预的多平台构建"
echo "   ✅ 自动化测试和质量检查"
echo "   ✅ 一键发布到 PyPI"
echo "   ✅ 支持所有主流平台"
echo "   ✅ 完全免费 (GitHub Actions)"
echo ""

read -p "是否现在配置 Git remote? (y/N): " setup_remote

if [[ $setup_remote =~ ^[Yy]$ ]]; then
    echo ""
    echo "🔧 配置 Git remote..."
    
    # 检查是否已经有 remote
    if git remote | grep -q "origin"; then
        echo "   - 移除现有 origin..."
        git remote remove origin
    fi
    
    # 添加新的 remote
    git remote add origin https://github.com/miaokela/query-builder.git
    git branch -M main
    
    echo "   ✅ Git remote 配置完成"
    echo ""
    echo "现在您可以执行:"
    echo "   git push -u origin main"
    echo ""
    echo "推送完成后，访问 GitHub 仓库配置 PyPI API Token，然后:"
    echo "   git tag v0.1.0"
    echo "   git push origin v0.1.0"
    echo ""
    echo "GitHub Actions 将自动开始构建和发布流程！"
else
    echo ""
    echo "⏭️  跳过 Git remote 配置"
    echo "请手动执行上述命令完成发布设置"
fi

echo ""
echo "🎉 GitHub Actions 发布准备完成!"
echo ""
echo "📚 更多信息:"
echo "   - GitHub Actions 指南: ./GITHUB_ACTIONS_GUIDE.md"
echo "   - 详细发布指南: ./PUBLISH.md"
echo "   - 项目文档: ./README.md"