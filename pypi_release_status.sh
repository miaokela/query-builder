#!/bin/bash

echo "📊 PyPI发布状态说明"
echo "=================="
echo "检查时间: $(date)"
echo ""

echo "🔍 当前发布触发条件:"
echo "1. ✅ 推送标签 (如 v0.1.11) - 自动发布到PyPI"
echo "2. ✅ 手动触发 + build_type='release' - 手动发布到PyPI"
echo "3. ❌ 普通push到main分支 - 只构建，不发布"
echo ""

echo "📋 刚才的操作:"
echo "✅ 已创建并推送标签 v0.1.11"
echo "✅ 这会触发完整的构建+发布流程"
echo "✅ 预期生成15个wheel文件并上传到PyPI"
echo ""

echo "🎯 监控发布状态:"
echo "GitHub Actions: https://github.com/miaokela/query-builder/actions"
echo "PyPI包页面: https://pypi.org/project/query-builder/"
echo ""

echo "📊 发布流程:"
echo "1. 🏗️  构建阶段: 3个平台并行构建wheel"
echo "2. 📦 artifact阶段: 收集所有wheel文件"
echo "3. 🚀 发布阶段: 上传到PyPI (仅标签触发)"
echo ""

echo "⏳ 预计时间:"
echo "- 构建: 10-15分钟"
echo "- 发布: 1-2分钟"
echo "- 总计: 约15分钟后可在PyPI看到新版本"
echo ""

echo "🔧 如果发布失败:"
echo "1. 检查 PYPI_API_TOKEN 密钥是否正确配置"
echo "2. 确认PyPI项目名称匹配"
echo "3. 检查版本号是否已存在"
echo "4. 可以手动下载artifacts上传"