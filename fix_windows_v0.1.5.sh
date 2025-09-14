#!/bin/bash

echo "🔧 修复Windows构建问题 - v0.1.5"
echo "===================================="
echo "修复时间: $(date)"
echo ""

echo "🐛 Windows构建问题分析:"
echo "错误: LINK : fatal error LNK1181: cannot open input file 'python38.lib'"
echo "原因: Windows平台PyO3配置缺少abi3支持"
echo "解决: 添加abi3-py38特性和Windows特定环境配置"
echo ""

echo "🔧 修复措施:"
echo "1. ✅ Cargo.toml: 添加 abi3-py38 特性"
echo "2. ✅ workflow: 添加Python setup步骤"  
echo "3. ✅ workflow: 添加Windows特定环境变量"
echo "4. ✅ workflow: 设置PYO3_USE_ABI3_FORWARD_COMPATIBILITY"
echo ""

echo "📝 技术细节:"
echo "- PyO3 abi3: 使用稳定ABI避免特定Python版本库依赖"
echo "- Python setup: 确保所有平台Python环境一致"
echo "- 环境变量: PYO3_CROSS_LIB_DIR 和 PYO3_USE_ABI3_FORWARD_COMPATIBILITY"
echo ""

# 检查当前配置
echo "🔍 当前配置检查:"
echo "Cargo.toml PyO3配置:"
grep -A 6 "dependencies" Cargo.toml | grep pyo3
echo ""
echo "Workflow Python setup:"
grep -A 10 "Set up Python" .github/workflows/build.yml | head -5
echo ""

echo "🚀 准备发布 v0.1.5:"
echo "1. 提交修复"
echo "2. 创建新标签"
echo "3. 测试4平台构建"
echo "4. 验证Windows构建成功"

read -p "是否继续发布 v0.1.5? (y/n): " confirm
if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
    echo "开始发布流程..."
    
    # 更新版本号
    echo "📝 更新版本号到 v0.1.5"
    sed -i '' 's/version = "0.1.0"/version = "0.1.5"/' Cargo.toml
    
    # 提交修复
    git add .
    git commit -m "🔧 修复Windows构建: 添加abi3-py38支持和Windows特定配置"
    git push
    
    # 创建并推送标签
    echo "🏷️ 创建标签 v0.1.5"
    git tag v0.1.5
    git push origin v0.1.5
    
    echo "✅ v0.1.5 发布已启动!"
    echo "监控地址: https://github.com/miaokela/query-builder/actions"
    echo ""
    echo "🎯 预期结果:"
    echo "- Windows x64: 修复python38.lib错误"
    echo "- macOS Intel: 正常构建"
    echo "- macOS Apple Silicon: 正常构建"  
    echo "- Linux x64: 正常构建"
    echo "- 总计: 20个wheel文件成功构建"
    
else
    echo "❌ 发布已取消"
fi