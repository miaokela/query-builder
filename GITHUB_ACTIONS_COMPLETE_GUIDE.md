# 🚀 GitHub Actions 自动化发布完整指南

## 🎯 概述

您的 `query-builder` 项目现在已经完全配置好 GitHub Actions，可以实现：
- ✅ **多平台自动构建**: Windows, Linux, macOS (ARM64 + Intel)
- ✅ **自动测试**: 确保代码质量
- ✅ **自动 PyPI 发布**: 一键发布到 PyPI
- ✅ **零人工干预**: 推送标签即自动发布

## 📋 准备工作检查清单

### ✅ 已完成的准备工作
- [x] 项目代码完整 (Rust + pyo3)
- [x] GitHub Actions 配置文件 (`.github/workflows/build.yml`)
- [x] Git 仓库初始化
- [x] 包配置文件 (`pyproject.toml`, `Cargo.toml`)
- [x] 项目文档 (`README.md`, `LICENSE`)
- [x] 测试文件
- [x] `.gitignore` 配置

### 🔲 需要您完成的步骤
- [ ] 创建 GitHub 仓库
- [ ] 推送代码到 GitHub
- [ ] 配置 PyPI API Token
- [ ] 创建版本标签触发发布

## 🏭 GitHub Actions 工作流程详解

### 触发条件
```yaml
# 何时开始构建？
on:
  push:
    tags: ['v*']     # 推送 v0.1.0 这样的标签
    branches: [main] # 推送到 main 分支 (仅测试)
  workflow_dispatch: # 手动触发
  pull_request:      # PR 测试
```

### 构建矩阵
```yaml
# 在哪些平台构建？
matrix:
  include:
    - os: macos-latest, target: x86_64-apple-darwin     # macOS Intel
    - os: macos-latest, target: aarch64-apple-darwin    # macOS ARM64  
    - os: windows-latest, target: x86_64-pc-windows-msvc # Windows x64
    - os: windows-latest, target: i686-pc-windows-msvc   # Windows x86
    - os: ubuntu-latest, target: x86_64-unknown-linux-gnu # Linux x64
    - os: ubuntu-latest, target: aarch64-unknown-linux-gnu # Linux ARM64
```

### 构建步骤
1. **检出代码**: 下载您的代码到构建机器
2. **环境准备**: 安装 Python 3.8-3.12 和 Rust
3. **构建**: 使用 maturin 构建包
4. **测试**: 运行单元测试
5. **上传**: 保存构建的包
6. **发布**: (仅标签推送) 自动发布到 PyPI

## 📝 详细操作步骤

### 步骤 1: 创建 GitHub 仓库

1. **访问 GitHub**: https://github.com/new
2. **填写信息**:
   - Repository name: `query-builder`
   - Description: `A secure SQL query builder for Python using Rust and pyo3`
   - Public repository (推荐)
   - **不要**勾选 "Add a README file"
   - **不要**勾选 "Add .gitignore"
   - **不要**勾选 "Choose a license"
3. **点击**: "Create repository"

### 步骤 2: 推送代码到 GitHub

在项目目录执行：

```bash
# 运行我们的自动化脚本
./setup_github_actions.sh

# 或者手动执行：
git remote add origin https://github.com/miaokela/query-builder.git
git branch -M main
git push -u origin main
```

### 步骤 3: 配置 PyPI API Token

#### 3.1 创建 PyPI API Token
1. **登录 PyPI**: https://pypi.org/account/login/
2. **访问 Token 页面**: https://pypi.org/manage/account/token/
3. **创建新 Token**:
   - Token name: `query-builder-github-actions`
   - Scope: `Entire account` (首次发布) 或 `Specific project`
4. **复制 Token**: 格式类似 `pypi-AgEIcHlwaS5vcmc...`

#### 3.2 在 GitHub 添加 Secret
1. **访问仓库设置**: https://github.com/miaokela/query-builder/settings
2. **点击**: Secrets and variables -> Actions
3. **New repository secret**:
   - Name: `PYPI_API_TOKEN`
   - Secret: 粘贴您的 PyPI token
4. **点击**: Add secret

### 步骤 4: 触发自动发布

#### 4.1 测试构建 (可选)
```bash
# 推送到 main 分支将只运行测试，不发布
git push origin main
```

#### 4.2 正式发布
```bash
# 创建版本标签并推送
git tag v0.1.0
git push origin v0.1.0
```

#### 4.3 监控构建进度
- **访问**: https://github.com/miaokela/query-builder/actions
- **查看**: 构建日志和进度
- **等待**: 约 15 分钟完成

## 📊 构建时间线

### 第 0-2 分钟: 准备阶段
```
🔄 GitHub Actions 启动
📥 下载代码到 6 台虚拟机
🔧 安装 Python 3.8-3.12 和 Rust
```

### 第 2-10 分钟: 构建阶段
```
🏗️ 6 个平台同时构建:
   - macOS ARM64
   - macOS Intel  
   - Windows x64
   - Windows x86
   - Linux x64
   - Linux ARM64
```

### 第 10-12 分钟: 测试阶段
```
🧪 运行单元测试
✅ 验证包功能
📦 上传构建结果
```

### 第 12-15 分钟: 发布阶段
```
📤 下载所有包到发布机器
🚀 自动上传到 PyPI
✅ 发布完成
```

## 🎯 发布后验证

### 检查 PyPI
1. **访问**: https://pypi.org/project/query-builder/
2. **确认**: 包信息正确
3. **测试安装**: `pip install query-builder`

### 检查多平台支持
```bash
# 在不同平台测试安装
pip install query-builder

# 验证功能
python -c "import query_builder; print('Success!')"
```

## 🔧 高级配置

### 自定义版本号
```bash
# 发布补丁版本
git tag v0.1.1
git push origin v0.1.1

# 发布候选版本
git tag v0.2.0rc1
git push origin v0.2.0rc1

# 发布主版本
git tag v1.0.0
git push origin v1.0.0
```

### 手动触发构建
1. **访问**: https://github.com/miaokela/query-builder/actions
2. **选择**: "Build and Release" workflow
3. **点击**: "Run workflow"
4. **选择**: 分支和参数
5. **点击**: "Run workflow"

### 查看构建日志
```
GitHub Actions -> 选择运行 -> 展开步骤
可以查看详细的构建日志和错误信息
```

## 🚨 故障排除

### 常见问题

#### PyPI Token 错误
```
❌ 错误: 401 Unauthorized
✅ 解决: 检查 PYPI_API_TOKEN 是否正确配置
```

#### 包名冲突
```
❌ 错误: Package name already exists
✅ 解决: 更改 pyproject.toml 中的包名
```

#### 构建失败
```
❌ 错误: Compilation failed
✅ 解决: 查看 Actions 日志，检查 Rust 代码
```

### 获取帮助
- **GitHub Issues**: https://github.com/miaokela/query-builder/issues
- **Actions 文档**: https://docs.github.com/en/actions
- **PyPI 帮助**: https://pypi.org/help/

## 🎉 成功指标

### 构建成功标志
- ✅ 所有 6 个平台构建通过
- ✅ 测试全部通过
- ✅ PyPI 发布成功
- ✅ 用户可以 `pip install query-builder`

### 监控仪表板
- **GitHub Actions**: 构建状态
- **PyPI Statistics**: 下载量统计
- **GitHub Insights**: 仓库活动

## 📚 后续维护

### 版本发布流程
1. **修改代码**
2. **更新版本号** (pyproject.toml)
3. **提交更改**
4. **创建标签**: `git tag v0.1.x`
5. **推送标签**: `git push origin v0.1.x`
6. **自动发布**: GitHub Actions 处理一切

### 依赖更新
- **Rust 依赖**: 修改 `Cargo.toml`
- **Python 依赖**: 修改 `pyproject.toml`
- **Actions 版本**: 修改 `.github/workflows/build.yml`

## 💡 最佳实践

1. **语义化版本**: 使用 v1.2.3 格式
2. **变更日志**: 维护 CHANGELOG.md
3. **安全更新**: 定期更新依赖
4. **文档同步**: 保持文档更新
5. **测试覆盖**: 增加测试用例

---

## 🎯 总结

您的 `query-builder` 项目现在拥有**企业级的 CI/CD 流程**：

- 🏭 **自动化工厂**: 6 个平台并行构建
- 🔒 **质量保证**: 自动化测试
- 🚀 **一键发布**: 推送标签即发布
- 💰 **零成本**: GitHub Actions 免费
- 🌍 **全球可用**: PyPI 自动分发

这是现代 Python 包开发的**金标准**流程！🏆