#!/bin/bash

echo "🛑 取消 GitHub Actions 工作流指南"
echo "=================================="
echo "时间: $(date)"
echo ""

echo "📋 当前工作流状态:"
echo "项目: https://github.com/miaokela/query-builder"
echo "Actions页面: https://github.com/miaokela/query-builder/actions"
echo ""

echo "🔍 需要检查的工作流:"
echo "• Build and Release (主要构建流程)"
echo "• Simple Test Build (测试流程)"
echo ""

echo "🛑 手动取消步骤:"
echo "1. 访问: https://github.com/miaokela/query-builder/actions"
echo "2. 查看正在运行的工作流 (显示黄色圆圈🟡或蓝色圆圈🔵)"
echo "3. 点击正在运行的工作流条目"
echo "4. 在工作流详情页面点击 'Cancel workflow' 按钮"
echo "5. 确认取消操作"
echo ""

echo "📊 检查要取消的工作流:"
echo "• 状态为 'In progress' 或 'Queued' 的工作流"
echo "• 由以下触发的运行:"
echo "  - 标签推送 (v0.1.1, v0.1.2, v0.1.3)"
echo "  - 分支推送 (main branch)"
echo "  - 手动触发 (workflow_dispatch)"
echo ""

echo "✅ 取消完成后验证:"
echo "• 所有工作流状态显示为 'Cancelled' ❌"
echo "• 没有正在运行的工作流"
echo "• 可以安全地重新配置或重新触发"
echo ""

echo "🔧 如果无法通过UI取消:"
echo "• 等待工作流自然完成 (通常10-20分钟)"
echo "• 检查是否有权限问题"
echo "• 联系仓库管理员"
echo ""

echo "⚠️  注意事项:"
echo "• 取消后的工作流不会发布到PyPI"
echo "• artifacts可能不完整"
echo "• 需要重新触发才能完成发布"
echo ""

echo "📱 下一步操作建议:"
echo "1. 确认所有工作流已取消"
echo "2. 检查和修复workflow配置"
echo "3. 创建新标签重新触发发布"

# 显示当前标签状态
echo ""
echo "🏷️  当前标签状态:"
git tag --sort=-version:refname | head -5

echo ""
echo "💡 已删除v0.1.4标签，避免意外触发"