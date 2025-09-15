# Query Builder

一个高性能的SQL查询构建器，使用Rust + PyO3开发，为Python提供内存缓存的SQL模板渲染功能。

## 🚀 特性

- **⚡ 极速性能**: 使用Rust开发 + 内存模板缓存，提供原生级别的性能
- **🔒 安全第一**: 内置SQL注入防护和危险关键词检测
- **🧠 智能缓存**: 启动时一次性加载所有模板到内存，查询时零IO操作
- **🎯 模板引擎**: 基于Tera模板引擎，支持条件语句、循环等高级功能
- **🐍 Python友好**: 完整的类型提示支持，VS Code智能感知
- **🌐 跨平台**: 支持macOS、Windows、Linux多平台

## 🏗️ 架构优势

### 🔥 性能优化
```
传统方式:  查询时读取文件 → 解析YAML → 渲染SQL
新架构:    启动时加载全部 → 查询时内存读取 ⚡ → 渲染SQL
```

### 💾 内存缓存机制
- **一次加载** - 应用启动时将所有SQL模板加载到内存
- **零IO查询** - 构建SQL时直接从内存获取模板
- **生产就绪** - 适合高并发、低延迟的生产环境

### 🎯 VS Code完整支持
- **智能感知** - 完整的方法和属性提示
- **类型检查** - 参数类型验证和错误预防
- **文档悬浮** - 丰富的API说明和示例

## 🔒 安全特性

- **仅支持 SELECT 查询** - 严格限制只能构造查询语句
- **SQL 注入防护** - 检测和阻止常见的 SQL 注入攻击模式
- **危险关键词过滤** - 阻止 DROP、UPDATE、DELETE 等危险操作
- **模式匹配检测** - 识别注释注入、UNION 注入等攻击

## 📦 安装

```bash
pip install query-builder-tool
```

## 🚀 快速开始

### 1. 组织SQL模板

创建模板目录结构：
```
sql/
├── users.yaml          # 用户查询
├── orders.yaml         # 订单查询
└── api.yaml            # API查询
```

#### users.yaml
```yaml
select_by_id: |
  SELECT id, name, email, created_at 
  FROM users 
  WHERE id = {{ user_id }};

list_active: |
  SELECT id, name, email 
  FROM users 
  WHERE status = "{{ status }}"
  {% if limit %}LIMIT {{ limit }}{% endif %};

search: |
  SELECT id, name, email 
  FROM users 
  WHERE name LIKE "%{{ keyword }}%" 
  ORDER BY created_at DESC
  {% if limit %}LIMIT {{ limit }}{% endif %};
```

#### orders.yaml
```yaml
recent: |
  SELECT * FROM orders 
  WHERE created_at >= "{{ start_date }}"
  ORDER BY created_at DESC
  LIMIT {{ limit }};

by_customer: |
  SELECT * FROM orders 
  WHERE customer_id = {{ customer_id }}
  AND status = "{{ status }}";
```

### 2. 基本用法（新架构）

```python
from query_builder import PyQueryBuilder

# 🔥 新的优化用法
qb = PyQueryBuilder()

# 1. 设置模板目录
qb.sql_path = "./sql"

# 2. 一次性加载所有模板到内存（重要！）
qb.load_all_templates()

# 3. 现在可以快速构建查询（从内存）
sql = qb.build("users.select_by_id", user_id=123)
print(sql)
# 输出: SELECT id, name, email, created_at FROM users WHERE id = 123;

# 复杂查询示例
sql = qb.build("users.list_active", status="active", limit=10)
sql = qb.build("orders.recent", start_date="2024-01-01", limit=50)
sql = qb.build("users.search", keyword="john", limit=20)
```

### 3. 模板键格式

使用 `文件名.模板名` 的格式：
- `users.select_by_id` → `sql/users.yaml` 中的 `select_by_id`
- `orders.recent` → `sql/orders.yaml` 中的 `recent`  
- `api.search` → `sql/api.yaml` 中的 `search`

### 4. 查看可用模板

```python
# 获取所有已加载的模板键
keys = qb.get_template_keys()
print("可用模板:", keys)
# ['users.select_by_id', 'users.list_active', 'orders.recent', ...]

# 检查特定模板是否存在
if "users.select_by_id" in keys:
    sql = qb.build("users.select_by_id", user_id=123)
```

### 5. 错误处理

```python
try:
    qb = PyQueryBuilder()
    qb.sql_path = "./sql"
    qb.load_all_templates()  # 可能抛出 ValueError 或 IOError
    
    sql = qb.build("users.select_by_id", user_id=123)  # 可能抛出 KeyError
    
except ValueError as e:
    print(f"配置错误: {e}")
except IOError as e:
    print(f"文件读取错误: {e}")
except KeyError as e:
    print(f"模板不存在: {e}")
```

## 🎨 模板语法

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

## 🛡️ 安全检查

以下类型的 SQL 会被自动阻止：

- 非 SELECT 语句（UPDATE、DELETE、INSERT 等）
- 包含危险关键词（DROP、TRUNCATE、EXEC 等）
- SQL 注入攻击模式（注释注入、UNION 注入等）
- 脚本注入攻击（JavaScript、VBScript 等）

### 安全示例

```python
# ❌ 这些操作会被阻止
try:
    qb.build('malicious', query='DROP TABLE users;')  # 抛出 ValueError
except ValueError as e:
    print("安全检查阻止了危险操作:", e)

# ✅ 只允许安全的SELECT查询
sql = qb.build('users.select_by_id', user_id=123)  # 正常工作
```

## 📋 完整API参考

### PyQueryBuilder 类

#### 属性
- `sql_path: Optional[str]` - SQL模板目录路径

#### 方法

##### `__init__() -> None`
创建新的查询构建器实例。

##### `load_all_templates() -> None`
将所有SQL模板加载到内存。必须在构建查询前调用。
- **异常**: `ValueError`, `IOError`

##### `build(key: str, **kwargs) -> str`
从内存中的模板构建SQL查询。
- **参数**: 
  - `key`: 模板键（格式: "文件.模板"）
  - `**kwargs`: 模板变量
- **返回**: 渲染后的SQL字符串
- **异常**: `KeyError`, `ValueError`

##### `get_template_keys() -> List[str]`
获取所有已加载的模板键。
- **返回**: 模板键列表

### 便利函数

#### `builder() -> PyQueryBuilder`
创建新的PyQueryBuilder实例的便利函数。

## 🚀 性能基准

### 内存缓存 vs 文件读取
```python
import time
from query_builder import PyQueryBuilder

# 传统方式模拟（每次读取文件）
def old_way():
    # 假设每次查询需要 5ms 文件IO
    time.sleep(0.005)
    return "SELECT * FROM users"

# 新的内存缓存方式
qb = PyQueryBuilder()
qb.sql_path = "./sql"
qb.load_all_templates()  # 一次性加载

# 性能对比
queries = 1000

# 新方式：从内存查询
start = time.time()
for i in range(queries):
    sql = qb.build("users.select_by_id", user_id=i)
new_time = time.time() - start

print(f"内存缓存方式: {new_time:.4f}s")
print(f"平均每查询: {new_time/queries*1000:.2f}ms")
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
python example_with_types.py
```

### 测试

```bash
# 测试基本功能
python -c "
from query_builder import PyQueryBuilder
qb = PyQueryBuilder()
print('Query Builder 正常工作！')
"
```

## 🏗️ 项目架构

```
query-builder/
├── src/
│   └── lib.rs                  # Rust核心代码
├── sql/                        # SQL模板示例
│   ├── users.yaml
│   └── orders.yaml
├── query_builder.pyi           # 类型提示文件
├── example_with_types.py       # 使用示例
├── TYPE_HINTS_GUIDE.md         # 详细指南
├── .github/
│   └── workflows/
│       └── build-simple-maturin.yml  # CI/CD配置
├── Cargo.toml                  # Rust依赖配置
├── pyproject.toml              # Python包配置
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