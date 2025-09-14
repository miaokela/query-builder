#!/bin/bash

echo "🔄 手动重新触发构建测试PowerShell修复"
echo "======================================="
echo "测试时间: $(date)"
echo ""

echo "💡 本次修复内容:"
echo "1. ✅ 明确指定 shell: pwsh"
echo "2. ✅ 移除Python f-string语法"
echo "3. ✅ 使用PowerShell原生变量语法"
echo "4. ✅ 简化引号嵌套问题"
echo ""

echo "📋 当前workflow检查:"
echo "Windows步骤配置:"
grep -A 10 "Install Python (Windows specific)" .github/workflows/build.yml

echo ""
echo "🎯 期望结果:"
echo "- Windows PowerShell命令正确执行"
echo "- Python环境检查成功"
echo "- abi3构建顺利进行"
echo "- 不再出现语法错误"
echo ""

# 创建一个强制推送来重新触发
echo "🚀 重新推送来触发构建..."
git commit --allow-empty -m "🔄 重新触发构建: 测试PowerShell语法修复"
git push

echo "✅ 构建已重新触发!"
echo "监控: https://github.com/miaokela/query-builder/actions"
echo ""
echo "🔍 关注点:"
echo "- Windows步骤是否通过Python环境检查"
echo "- 是否成功设置PYO3环境变量"
echo "- maturin构建是否开始执行"