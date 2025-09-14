#!/bin/bash

# GitHub Actions 状态检查脚本

echo "🔍 GitHub Actions 状态检查"
echo "=========================="
echo "时间: $(date)"
echo "项目: query-builder"
echo ""

echo "📋 最新提交信息:"
git log --oneline -3
echo ""

echo "🏷️ 当前标签:"
git tag --sort=-version:refname | head -3
echo ""

echo "🔗 重要链接:"
echo "GitHub Actions: https://github.com/miaokela/query-builder/actions"
echo "最新工作流: https://github.com/miaokela/query-builder/actions/runs"
echo "构建配置: https://github.com/miaokela/query-builder/blob/main/.github/workflows/build.yml"
echo ""

echo "🛠️ 故障排除步骤:"
echo "1. 检查runner可用性:"
echo "   • ubuntu-20.04 ✓ (标准runner)"
echo "   • windows-2019 ✓ (标准runner)"  
echo "   • macos-11 ✓ (标准runner)"
echo ""
echo "2. 如果仍然等待runner:"
echo "   • 可能是GitHub服务繁忙"
echo "   • 等待几分钟后重新检查"
echo "   • 或手动触发workflow_dispatch"
echo ""
echo "3. 手动触发命令:"
echo "   访问: https://github.com/miaokela/query-builder/actions"
echo "   点击 'Build and Release' workflow"
echo "   点击 'Run workflow' 按钮"
echo ""

echo "📊 workflow配置检查:"
if [ -f ".github/workflows/build.yml" ]; then
    echo "✅ build.yml 存在"
    echo "触发条件:"
    grep -A 5 "^on:" .github/workflows/build.yml
    echo ""
    echo "运行环境:"
    grep -A 3 "matrix:" .github/workflows/build.yml
else
    echo "❌ build.yml 不存在"
fi

echo ""
echo "💡 如果问题持续:"
echo "• 检查GitHub状态页面: https://www.githubstatus.com/"
echo "• 尝试创建新的标签触发构建: git tag v0.1.2 && git push --tags"
echo "• 或等待GitHub runner资源恢复"