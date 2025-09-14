# Query Builder

基于 Rust + pyo3 的安全 SQL 查询构造器，专注于安全的 SELECT 查询语句构造。

## 🔒 安全特性

- **仅支持 SELECT 查询** - 严格限制只能构造查询语句
- **SQL 注入防护** - 检测和阻止常见的 SQL 注入攻击模式
- **危险关键词过滤** - 阻止 DROP、UPDATE、DELETE 等危险操作
- **模式匹配检测** - 识别注释注入、UNION 注入等攻击

## 🚀 使用方法

### 基本用法

```python
import query_builder
import os

# 创建查询构建器
qb = query_builder.builder()

# 必须手动设置 SQL 文件夹绝对路径
qb.sql_path = "/absolute/path/to/sql"

# 构造查询
sql = qb.build("queries.user_by_id", {"user_id": 123})
print(sql)  # select id, name, email from users where id = 123
```

### SQL 模板示例

**sql/queries.yaml:**
```yaml
user_list: |
  select * from users where status = 'active'

user_by_id: |
  select id, name, email from users where id = {{ user_id }}

user_search: |
  select * from users 
  where 1=1
  {% if name %}
    and name like '%{{ name }}%'
  {% endif %}
  {% if age_min %}
    and age >= {{ age_min }}
  {% endif %}
```

## 🛡️ 安全检查

以下类型的 SQL 会被自动阻止：

- 非 SELECT 语句（UPDATE、DELETE、INSERT 等）
- 包含危险关键词（DROP、TRUNCATE、EXEC 等）
- SQL 注入攻击模式（注释注入、UNION 注入等）
- 脚本注入攻击（JavaScript、VBScript 等）

## ⚡ 模板语法

支持 Tera 模板引擎的所有语法：

- **变量插值**: `{{ variable_name }}`
- **条件语句**: `{% if condition %}...{% endif %}`
- **循环语句**: `{% for item in list %}...{% endfor %}`
- **复杂表达式**: `{{ item.field }}`, `{{ list | length }}`
