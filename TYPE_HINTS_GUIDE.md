# Query Builder - 内存模板缓存与VS Code类型支持

## 🚀 新架构优势

### 性能优化架构
- **✅ 内存缓存** - 启动时一次性加载所有SQL模板
- **✅ 零IO查询** - 构建SQL时直接从内存读取
- **✅ 更快响应** - 避免重复文件读取和YAML解析
- **✅ 生产就绪** - 适合高并发环境

### VS Code完整支持
- **✅ 智能感知** - 完整的方法和属性提示
- **✅ 类型检查** - 参数类型验证
- **✅ 文档悬浮** - 丰富的API说明
- **✅ 错误提示** - 准确的问题定位

## 📋 新的使用方式

### 基础用法
```python
from query_builder import PyQueryBuilder

# 1. 创建实例
qb = PyQueryBuilder()

# 2. 设置SQL模板目录
qb.sql_path = "./sql"

# 3. 一次性加载所有模板到内存
qb.load_all_templates()

# 4. 快速构建查询（从内存）
sql = qb.build("users.select_by_id", user_id=123)
```

### 模板组织方式
```
sql/
├── users.yaml          # 用户相关查询
│   ├── select_by_id
│   ├── list_all
│   └── update_status
├── orders.yaml         # 订单查询
│   ├── recent
│   ├── by_customer
│   └── statistics
└── api.yaml           # API查询
    ├── user
    ├── search
    └── analytics
```

### 模板键格式
- `users.select_by_id` → `sql/users.yaml` 中的 `select_by_id`
- `orders.recent` → `sql/orders.yaml` 中的 `recent`
- `api.user` → `sql/api.yaml` 中的 `user`

## 🔍 VS Code体验改进

### 智能补全
```python
qb = PyQueryBuilder()        # 自动补全可用
qb.sql_path = "./sql"        # 属性类型提示
qb.load_all_templates()      # 方法签名显示
```

### 参数验证
```python
# VS Code会显示参数类型和文档
sql = qb.build(
    key="users.select_by_id",    # str类型 + 格式说明
    user_id=123,                 # 模板变量类型提示
    status="active"
)
```

### 错误预防
```python
keys = qb.get_template_keys()    # List[str]类型提示
if "users.select" in keys:       # 智能检查
    sql = qb.build("users.select")
```

## 📊 性能对比

### 传统方式（每次查询）
```
查询1: 读取文件 → 解析YAML → 渲染 → 返回SQL
查询2: 读取文件 → 解析YAML → 渲染 → 返回SQL  
查询3: 读取文件 → 解析YAML → 渲染 → 返回SQL
...
```

### 新方式（内存缓存）
```
初始化: 读取所有文件 → 解析所有YAML → 存储到内存
查询1: 内存读取 → 渲染 → 返回SQL ⚡
查询2: 内存读取 → 渲染 → 返回SQL ⚡
查询3: 内存读取 → 渲染 → 返回SQL ⚡
...
```

## 🛠️ API参考

### 核心方法

#### `load_all_templates()`
- **用途**: 将所有SQL模板加载到内存
- **调用**: 设置sql_path后调用一次
- **异常**: ValueError, IOError

#### `build(key, **kwargs)`
- **用途**: 从内存构建SQL查询
- **参数**: key格式为"文件.模板"
- **返回**: 渲染后的SQL字符串
- **异常**: KeyError, ValueError

#### `get_template_keys()`
- **用途**: 获取所有可用模板键
- **返回**: List[str]
- **用途**: 调试和验证

### 便利方法

#### `builder()`
- **用途**: 创建PyQueryBuilder实例
- **等价于**: PyQueryBuilder()

## 🧪 测试示例

运行完整示例：
```bash
python example_with_types.py
```

预期输出：
```
=== Query Builder Memory-Based Template Example ===

SQL path set to: ./sql
✅ All templates loaded successfully into memory
📝 Available templates: ['users.select_by_id', 'api.user', ...]

🔍 Generated SQL:
SELECT * FROM users WHERE id = 123

📊 API Query:
SELECT * FROM users LIMIT 10 WHERE status = 'active'
```

## ⚙️ VS Code配置建议

`.vscode/settings.json`:
```json
{
    "python.analysis.typeCheckingMode": "basic",
    "python.analysis.autoImportCompletions": true,
    "python.analysis.completeFunctionParens": true,
    "python.linting.enabled": true
}
```

## 🎯 最佳实践

1. **初始化时加载** - 应用启动时调用`load_all_templates()`
2. **错误处理** - 捕获加载和构建异常
3. **键名验证** - 使用`get_template_keys()`验证可用模板
4. **性能监控** - 在生产环境监控模板加载时间

这个新架构为PyO3库提供了生产级性能和完整的IDE支持！🚀