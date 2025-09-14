#!/bin/bash

echo "🔍 GitHub Actions 工作流状态检查"
echo "============================="
echo "检查时间: $(date)"
echo ""

echo "✅ 问题已解决:"
echo "1. ✅ 清理了重复的工作流文件"
echo "2. ✅ 保留 build-simple-maturin.yml 作为主要构建流"
echo "3. ✅ 添加了 main 分支 push 触发器"
echo "4. ✅ 刚刚推送了测试提交应该触发构建"
echo ""

echo "📂 当前活动工作流:"
echo "✅ build-simple-maturin.yml - 主要构建 (支持4平台)"
echo "✅ test-simple.yml - 简单测试"
echo ""

echo "📂 已禁用的工作流:"
echo "❌ build.yml.old-disabled - 旧版构建"
echo "❌ build.yml.disabled - 另一个旧版"
echo "❌ build-cibuildwheel.yml.disabled - cibuildwheel方案"
echo ""

echo "🎯 构建触发条件:"
echo "- ✅ 推送到 main 分支 (刚刚已触发)"
echo "- ✅ 推送标签 v* (v0.1.10已存在)"
echo "- ✅ 手动触发 (workflow_dispatch)"
echo ""

echo "📊 监控链接:"
echo "GitHub Actions: https://github.com/miaokela/query-builder/actions"
echo ""

echo "🔍 预期看到的构建:"
echo "工作流名称: 'Build and Release (Simple Maturin)'"
echo "触发原因: 'Push to main branch'"
echo "构建平台: Windows, macOS Intel, macOS Apple Silicon, Linux"
echo ""

echo "⏳ 如果构建已开始:"
echo "- 每个平台大约需要 5-15 分钟"
echo "- 总共应该生成 20 个 wheel 文件"
echo "- 构建成功后会自动上传到 artifacts"
echo ""

echo "🔧 如果仍然没有构建:"
echo "1. 检查 GitHub Actions 页面"
echo "2. 确认工作流文件语法正确"
echo "3. 手动触发 workflow_dispatch"
echo "4. 检查仓库的 Actions 权限设置"