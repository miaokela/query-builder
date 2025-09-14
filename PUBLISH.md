# 发布到 PyPI 的步骤

## 准备工作

1. **注册 PyPI 账号**
   - 访问 https://pypi.org/account/register/
   - 注册账号并验证邮箱

2. **注册 TestPyPI 账号**（可选，用于测试）
   - 访问 https://test.pypi.org/account/register/

## 安装发布工具

```bash
pip install twine
```

## 构建包

```bash
# 构建 release 版本
maturin build --release

# 或者构建所有平台的包（需要在对应平台上执行）
maturin build --release --target x86_64-apple-darwin  # Intel Mac
maturin build --release --target aarch64-apple-darwin # Apple Silicon Mac
maturin build --release --target x86_64-pc-windows-msvc # Windows
maturin build --release --target x86_64-unknown-linux-gnu # Linux
```

## 测试发布（推荐）

```bash
# 上传到 TestPyPI
twine upload --repository testpypi target/wheels/*.whl

# 从 TestPyPI 安装测试
pip install --index-url https://test.pypi.org/simple/ query-builder
```

## 正式发布

```bash
# 上传到正式 PyPI
twine upload target/wheels/*.whl

# 安装验证
pip install query-builder
```

## 使用 maturin 直接发布

```bash
# 发布到 TestPyPI
maturin publish --repository testpypi

# 发布到正式 PyPI
maturin publish
```

## 注意事项

1. **包名唯一性** - 确保包名在 PyPI 上唯一
2. **版本号管理** - 每次发布需要更新版本号
3. **多平台支持** - 建议提供多平台的 wheel 包
4. **文档完整** - 确保 README.md 和文档齐全
5. **测试充分** - 发布前充分测试功能

## API Token 配置

为了安全，建议使用 API Token：

1. 在 PyPI 账户设置中生成 API Token
2. 配置 ~/.pypirc：

```ini
[distutils]
index-servers =
    pypi
    testpypi

[pypi]
username = __token__
password = pypi-your-api-token-here

[testpypi]
repository = https://test.pypi.org/legacy/
username = __token__
password = pypi-your-test-api-token-here
```