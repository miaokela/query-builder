# 🤖 GitHub Actions 完全指南

## 🎯 什么是 GitHub Actions？

GitHub Actions 是 GitHub 提供的**免费 CI/CD 服务**，可以在代码推送时自动执行任务。

### 📊 简单对比
```
传统方式：
手动在 Windows 机器构建 → 手动在 Linux 机器构建 → 手动在 macOS 构建 → 手动上传

GitHub Actions：
推送代码 → 自动在 3 个平台构建 → 自动上传到 PyPI
```

## 🏭 GitHub Actions 工作原理

### 1. 触发条件
```yaml
# 什么时候开始工作？
on:
  push:              # 推送代码时
    tags: 'v*'       # 推送版本标签时
  workflow_dispatch: # 手动触发
```

### 2. 运行环境
```yaml
# 在哪里运行？
runs-on:
  - ubuntu-latest   # Linux 机器
  - windows-latest  # Windows 机器  
  - macos-latest    # macOS 机器
```

### 3. 执行步骤
```yaml
# 做什么？
steps:
  - 下载您的代码
  - 安装 Python 和 Rust
  - 构建包
  - 上传结果
```

## 🎮 实际演示

### 您推送代码后会发生什么：

#### 第 1 分钟：启动
```
📋 GitHub 检测到代码推送
🚀 同时启动 3 台虚拟机：
   - Ubuntu (Linux)
   - Windows Server  
   - macOS
```

#### 第 2-5 分钟：环境准备
```
🔧 每台机器自动安装：
   - Python 3.8, 3.9, 3.10, 3.11, 3.12
   - Rust 工具链
   - maturin 构建工具
```

#### 第 6-10 分钟：构建
```
🏗️ 每台机器构建适合自己平台的包：
   Linux:   query_builder-0.1.0-linux_x86_64.whl
   Windows: query_builder-0.1.0-win_amd64.whl
   macOS:   query_builder-0.1.0-macosx_arm64.whl
```

#### 第 11 分钟：发布
```
📦 自动上传到 PyPI
✅ 完成！用户可以 pip install query-builder
```

## 💰 费用和限制

### ✅ 完全免费
- **公开仓库**: 无限使用
- **私有仓库**: 每月 2000 分钟免费
- **您的项目**: 完全免费（公开仓库）

### 📊 性能
- **并行构建**: 3 个平台同时构建
- **总时间**: ~10 分钟完成所有平台
- **自动化**: 完全无需人工干预

## 🛠️ 已为您准备的配置

### 文件位置
```
.github/workflows/build.yml  # 我已经创建了这个文件
```

### 配置内容预览
```yaml
name: Build and Release
on:
  push:
    tags: 'v*'  # 推送 v1.0.0 这样的标签时触发

jobs:
  build:
    strategy:
      matrix:
        include:
          - os: macos-latest
            target: x86_64-apple-darwin
          - os: macos-latest  
            target: aarch64-apple-darwin
          - os: windows-latest
            target: x86_64-pc-windows-msvc
          - os: ubuntu-latest
            target: x86_64-unknown-linux-gnu
```

## 🚀 如何使用？

### 1. 创建 GitHub 仓库
```bash
# 在 GitHub 网站创建仓库：
# https://github.com/miaokela/query-builder
```

### 2. 推送您的代码
```bash
cd /Users/kela/Program/Other/Rust/query-builder
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/miaokela/query-builder.git
git push -u origin main
```

### 3. 创建版本标签
```bash
git tag v0.1.0
git push origin v0.1.0
```

### 4. 自动执行
```
🎉 GitHub Actions 自动开始工作！
📊 在 GitHub 仓库的 "Actions" 标签页查看进度
```

## 📊 GitHub Actions vs 手动构建

| 方面 | 手动构建 | GitHub Actions |
|------|----------|----------------|
| **时间** | 几小时 | 10 分钟 |
| **设备需求** | 3 台不同系统电脑 | 无需任何设备 |
| **人工干预** | 大量 | 零 |
| **错误率** | 高 | 几乎为零 |
| **可重复性** | 差 | 完美 |
| **成本** | 高 | 免费 |

## 🎯 为什么这是行业标准？

### 🏆 主流 Python 项目都在用
- **NumPy**: 使用 GitHub Actions
- **Pandas**: 使用 GitHub Actions  
- **TensorFlow**: 使用 GitHub Actions
- **Django**: 使用 GitHub Actions

### 💡 优势
1. **专业**: 行业标准做法
2. **可靠**: GitHub 的基础设施
3. **免费**: 对开源项目完全免费
4. **简单**: 一次配置，终身使用

## 🔧 配置 PyPI 自动发布

### 需要的密钥
```bash
# 在 PyPI 生成 API Token
# 在 GitHub 仓库设置中添加密钥：
# PYPI_API_TOKEN = "您的 PyPI API Token"
```

### 自动发布流程
```yaml
# 构建完成后自动发布到 PyPI
- name: Publish to PyPI
  env:
    MATURIN_PYPI_TOKEN: ${{ secrets.PYPI_API_TOKEN }}
  run: maturin upload --skip-existing dist/*
```

## 🎉 总结

GitHub Actions 让您：
- ✅ **无需多台电脑**
- ✅ **无需手动操作**  
- ✅ **无需支付费用**
- ✅ **获得专业级 CI/CD**

这就是为什么现代软件开发都使用 GitHub Actions 的原因！

## 🚀 下一步行动

1. **创建 GitHub 仓库**
2. **推送代码** 
3. **添加 PyPI API Token**
4. **推送版本标签**
5. **坐等自动构建完成** 🍿

GitHub Actions 将彻底解决您的跨平台构建问题！