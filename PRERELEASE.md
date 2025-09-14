# 预发布指南

## 当前构建状态
✅ 包已成功构建并测试通过
✅ Python 3.9 版本：`query_builder-0.1.0-cp39-cp39-macosx_11_0_arm64.whl`
✅ Python 3.12 版本：`query_builder-0.1.0-cp312-cp312-macosx_11_0_arm64.whl`
✅ 作者信息已配置：缪克拉 <2972799448@qq.com>
✅ GitHub 仓库已配置：https://github.com/miaokela/query-builder
✅ 本地安装测试通过
✅ 基本功能测试通过

## 预发布步骤

### 1. 测试本地安装
首先在本地测试安装构建的包：

```bash
# 安装本地构建的包
pip install target/wheels/query_builder-0.1.0-cp312-cp312-macosx_11_0_arm64.whl --force-reinstall

# 测试导入
python -c "import query_builder; print('Import successful!')"
```

### 2. 发布到 TestPyPI（推荐先测试）
在正式发布前，建议先发布到 TestPyPI 进行测试：

```bash
# 发布到 TestPyPI
maturin publish --repository testpypi
```

注意：您需要在 TestPyPI 注册账号并配置 API token

### 3. 从 TestPyPI 安装测试
```bash
# 从 TestPyPI 安装测试
pip install -i https://test.pypi.org/simple/ query-builder
```

### 4. 发布到正式 PyPI
测试无误后，发布到正式 PyPI：

```bash
# 发布到正式 PyPI
maturin publish
```

## 配置 PyPI 认证

### 方法一：使用 API Token（推荐）
1. 登录 PyPI 账号
2. 生成 API token
3. 配置环境变量：
   ```bash
   export MATURIN_PYPI_TOKEN="your_api_token"
   ```

### 方法二：使用用户名密码
```bash
# 发布时会提示输入用户名和密码
maturin publish --username your_username
```

## 发布前检查清单

- [ ] 包构建成功
- [ ] 本地安装测试通过
- [ ] 作者信息正确
- [ ] GitHub 仓库信息正确
- [ ] README.md 文档完整
- [ ] LICENSE 文件存在
- [ ] 版本号合适（当前：0.1.0）
- [ ] PyPI/TestPyPI 账号准备就绪

## 构建包信息
- **包名**: query-builder
- **版本**: 0.1.0
- **构建文件**: target/wheels/query_builder-0.1.0-cp312-cp312-macosx_11_0_arm64.whl
- **Python 版本**: 支持 Python 3.7+
- **平台**: macOS ARM64（当前构建）

## 注意事项
1. 当前构建仅支持 macOS ARM64，如需支持更多平台，需要在对应平台上构建
2. 包名在 PyPI 上必须唯一，如果 "query-builder" 已被占用，需要更改包名
3. 首次发布需要在 PyPI 上注册该包名

## 下一步
执行以下命令开始预发布流程：

```bash
# 1. 本地测试安装
pip install target/wheels/query_builder-0.1.0-cp312-cp312-macosx_11_0_arm64.whl --force-reinstall

# 2. 发布到 TestPyPI（需要配置认证）
maturin publish --repository testpypi
```