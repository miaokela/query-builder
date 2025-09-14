# Query Builder

一个安全的SQL查询构建器，使用Rust + PyO3开发，为Python提供高性能的SQL模板渲染功能。

## 🚀 特性

- **高性能**: 使用Rust开发，提供原生级别的性能
- **安全第一**: 内置SQL注入防护和危险关键词检测
- **模板引擎**: 基于Tera模板引擎，支持条件语句、循环等高级功能
- **易于使用**: 简单的Python API，无缝集成到现有项目
- **跨平台**: 支持macOS、Windows、Linux多平台

## 🔒 安全特性

- **仅支持 SELECT 查询** - 严格限制只能构造查询语句
- **SQL 注入防护** - 检测和阻止常见的 SQL 注入攻击模式
- **危险关键词过滤** - 阻止 DROP、UPDATE、DELETE 等危险操作
- **模式匹配检测** - 识别注释注入、UNION 注入等攻击

## � 安装

```bash
pip install query-builder
```

## �🚀 快速开始

### 1. 创建SQL模板文件

创建一个YAML文件来存储你的SQL模板（例如：`queries.yaml`）：

```yaml
get_users: |
  SELECT id, name, email, created_at 
  FROM users 
  WHERE status = "{{ status }}"
  {% if limit %}LIMIT {{ limit }}{% endif %};

get_user_by_id: |
  SELECT * FROM users WHERE id = {{ user_id }};

search_users: |
  SELECT id, name, email 
  FROM users 
  WHERE name LIKE "%{{ keyword }}%" 
  AND status = "{{ status }}"
  ORDER BY created_at DESC
  {% if limit %}LIMIT {{ limit }}{% endif %};
```

### 2. 基本用法

```python
import query_builder

# 创建查询构建器
qb = query_builder.PyQueryBuilder()

# 设置SQL模板文件夹的绝对路径
qb.sql_path = "/path/to/your/sql/templates"

# 构造简单查询
sql = qb.build("queries.get_user_by_id", {"user_id": 123})
print(sql)  # SELECT * FROM users WHERE id = 123;

# 构造带条件的查询
sql = qb.build("queries.get_users", {
    "status": "active",
    "limit": 10
})
print(sql)

# 构造搜索查询
sql = qb.build("queries.search_users", {
    "keyword": "john",
    "status": "active",
    "limit": 20
})
print(sql)
```

## � 模板语法

Query Builder使用Tera模板引擎，支持以下语法：

### 变量替换
```sql
SELECT * FROM users WHERE id = {{ user_id }};
```

### 条件语句
```sql
SELECT * FROM products 
WHERE category = "{{ category }}"
{% if min_price %}AND price >= {{ min_price }}{% endif %}
{% if max_price %}AND price <= {{ max_price }}{% endif %};
```

### 循环
```sql
SELECT * FROM users 
WHERE id IN ({% for id in user_ids %}{{ id }}{% if not loop.last %},{% endif %}{% endfor %});
```

### 字符串处理
```sql
SELECT * FROM users 
WHERE name LIKE "%{{ keyword | lower }}%";
```

## �🛡️ 安全检查

以下类型的 SQL 会被自动阻止：

- 非 SELECT 语句（UPDATE、DELETE、INSERT 等）
- 包含危险关键词（DROP、TRUNCATE、EXEC 等）
- SQL 注入攻击模式（注释注入、UNION 注入等）
- 脚本注入攻击（JavaScript、VBScript 等）

## 🔒 安全示例

Query Builder会自动阻止危险的SQL操作：

```python
# ❌ 这些操作会被阻止
qb.build('malicious', {'query': 'DROP TABLE users;'})  # 抛出安全异常
qb.build('dangerous', {'action': 'DELETE FROM users'})  # 抛出安全异常

# ✅ 只允许安全的SELECT查询
qb.build('safe_query', {'user_id': 123})  # 正常工作
```

## 🛠️ 开发

### 本地构建

```bash
# 克隆仓库
git clone https://github.com/miaokela/query-builder.git
cd query-builder

# 安装依赖
pip install maturin pyyaml

# 开发模式构建
maturin develop

# 运行测试
python test_local.py
```

### 测试

```bash
# 运行本地功能测试
python test_local.py

# 测试输出示例
python -c "
import query_builder
qb = query_builder.PyQueryBuilder()
print('Query Builder 正常工作！')
"
```

## 📋 API参考

### PyQueryBuilder 类

#### 属性
- `sql_path`: 设置SQL模板文件的目录路径

#### 方法
- `build(key: str, kwargs: dict) -> str`: 构建SQL查询
  - `key`: 模板键名（格式：`文件名.模板名`）
  - `kwargs`: 模板变量字典
  - 返回: 渲染后的SQL字符串

## 🏗️ 项目架构

```
query-builder/
├── src/
│   └── lib.rs              # Rust核心代码
├── sql/                    # SQL模板示例
│   └── queries.yaml
├── .github/
│   └── workflows/
│       └── build.yml       # CI/CD配置
├── Cargo.toml              # Rust依赖配置
├── pyproject.toml          # Python包配置
├── test_local.py           # 本地测试脚本
├── BUILD_FIX_SUMMARY.md    # 构建修复文档
└── README.md
```

## 🚦 CI/CD状态

- ✅ 自动化构建支持macOS（x86_64 + ARM64）、Windows x64、Linux x64
- ✅ 支持Python 3.8-3.12
- ✅ 自动发布到PyPI
- ✅ 全面的安全测试

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件。

## 🤝 贡献

欢迎提交Issue和Pull Request！请确保：

1. 所有测试通过
2. 遵循安全编码规范
3. 更新相关文档

## 📞 联系

- 作者: 缪克拉
- 邮箱: 2972799448@qq.com
- GitHub: https://github.com/miaokela/query-builder

## 🙏 致谢

- [PyO3](https://github.com/PyO3/pyo3) - 优秀的Rust-Python绑定库
- [Tera](https://github.com/Keats/tera) - 强大的模板引擎
- [maturin](https://github.com/PyO3/maturin) - Python包构建工具
