#!/bin/bash

echo "🔍 GitHub Actions 发布状态检查"
echo "=============================="
echo "检查时间: $(date)"
echo "项目: query-builder"
echo ""

echo "📋 最新提交和标签:"
echo "当前分支: $(git branch --show-current)"
echo "最新提交:"
git log --oneline -3
echo ""
echo "发布标签:"
git tag --sort=-version:refname | head -5
echo ""

echo "🔗 重要页面链接:"
echo "• GitHub Actions: https://github.com/miaokela/query-builder/actions"
echo "• 最新Runs: https://github.com/miaokela/query-builder/actions/runs"
echo "• PyPI项目页面: https://pypi.org/project/query-builder/"
echo "• GitHub Releases: https://github.com/miaokela/query-builder/releases"
echo ""

echo "📊 预期构建状态:"
echo "触发条件:"
echo "  ✅ 标签推送: v0.1.3 ($(git log -1 --format=%ci v0.1.3))"
echo "  ✅ 分支推送: main branch"
echo ""

echo "构建矩阵:"
echo "  • ubuntu-20.04 + Python 3.8,3.9,3.10,3.11,3.12"
echo "  • windows-2019 + Python 3.8,3.9,3.10,3.11,3.12"
echo "  • macos-11 + Python 3.8,3.9,3.10,3.11,3.12"
echo "  总计: 15个wheel文件"
echo ""

echo "🎯 发布流程检查:"
echo "1. Build Job:"
echo "   - 3个平台并行构建"
echo "   - 使用PyO3/maturin-action"
echo "   - 上传wheel artifacts"
echo ""
echo "2. Publish Job (仅标签触发):"
echo "   - 下载所有wheel文件"
echo "   - 发布到PyPI"
echo "   - 需要PYPI_API_TOKEN密钥"
echo ""

echo "🔍 检查方法:"
echo "1. 访问GitHub Actions页面查看运行状态"
echo "2. 检查每个job的详细日志"
echo "3. 验证artifact是否生成"
echo "4. 确认PyPI发布状态"
echo ""

echo "📦 本地验证:"
echo "本地wheel文件:"
if [ -d "target/wheels" ] && [ "$(ls -A target/wheels 2>/dev/null)" ]; then
    ls -la target/wheels/
else
    echo "  ❌ 没有本地wheel文件"
fi
echo ""

echo "💡 如果构建完成，可以测试安装:"
echo "pip install query-builder"
echo "python -c \"import query_builder; print('🎉 安装成功!')\""
echo ""

echo "🚨 常见问题排查:"
echo "• 如果等待runner: GitHub服务可能繁忙，稍等片刻"
echo "• 如果构建失败: 检查具体错误日志"
echo "• 如果PyPI发布失败: 检查PYPI_API_TOKEN设置"
echo "• 如果没有触发: 确认workflow文件语法正确"
echo ""

echo "📱 持续监控建议:"
echo "每5-10分钟检查一次GitHub Actions页面"
echo "构建通常需要10-20分钟完成"