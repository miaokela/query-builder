#!/bin/bash

echo "🔍 检查工作流状态并手动触发"
echo "========================"
echo "检查时间: $(date)"
echo ""

echo "📂 当前工作流文件:"
ls -la .github/workflows/
echo ""

echo "🔍 活动工作流分析:"
echo "1. build.yml - Build and Release"
echo "2. build-simple-maturin.yml - Build and Release (Simple Maturin)" 
echo "3. test-simple.yml - 测试工作流"
echo ""

echo "⚠️  问题分析:"
echo "有两个类似的构建工作流可能导致冲突"
echo "都只在标签推送时触发，普通push不会运行"
echo ""

echo "🔧 解决方案:"
echo "1. 禁用旧的build.yml"
echo "2. 保留build-simple-maturin.yml作为主要构建流"
echo "3. 手动触发测试构建"
echo ""

# 禁用旧的build.yml
echo "🔧 禁用旧的build.yml工作流..."
mv .github/workflows/build.yml .github/workflows/build.yml.old-disabled

echo "📋 当前活动工作流:"
echo "✅ build-simple-maturin.yml (主要构建)"
echo "✅ test-simple.yml (测试)"
echo "❌ build.yml -> build.yml.old-disabled"
echo "❌ build-cibuildwheel.yml -> disabled"
echo ""

echo "🚀 提交工作流清理..."
git add .github/workflows/
git commit -m "🔧 清理工作流: 禁用旧build.yml，保留build-simple-maturin.yml"
git push

echo ""
echo "📊 检查最近的标签:"
git tag --sort=-version:refname | head -5
echo ""

echo "🎯 触发构建的方法:"
echo "1. 访问 GitHub Actions页面手动触发"
echo "2. 或者推送新标签自动触发"
echo "3. 或者我们可以添加push触发器进行测试"
echo ""

echo "🔗 GitHub Actions: https://github.com/miaokela/query-builder/actions"
echo "应该能看到v0.1.10标签触发的构建"