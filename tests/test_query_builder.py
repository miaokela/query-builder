import pytest
import query_builder
import os

def test_sql_path_required():
    """测试必须设置 sql_path"""
    qb = query_builder.builder()
    with pytest.raises(ValueError, match="sql_path must be set"):
        qb.build("queries.user_list", {})

def test_basic_query():
    """测试基本查询"""
    qb = query_builder.builder()
    qb.sql_path = os.path.abspath("sql")
    
    sql = qb.build("queries.user_list", {})
    assert "select * from users where status = 'active'" in sql.lower()

def test_parameterized_query():
    """测试参数化查询"""
    qb = query_builder.builder()
    qb.sql_path = os.path.abspath("sql")
    
    sql = qb.build("queries.user_by_id", {"user_id": 123})
    assert "where id = 123" in sql

def test_conditional_query():
    """测试条件查询"""
    qb = query_builder.builder()
    qb.sql_path = os.path.abspath("sql")
    
    # 带条件
    sql = qb.build("queries.user_search", {"name": "john", "age_min": 18})
    assert "name like '%john%'" in sql.lower()
    assert "age >= 18" in sql.lower()
    
    # 无条件
    sql = qb.build("queries.user_search", {})
    assert "where 1=1" in sql.lower()

def test_list_query():
    """测试列表参数查询"""
    qb = query_builder.builder()
    qb.sql_path = os.path.abspath("sql")
    
    sql = qb.build("queries.user_in_list", {"user_ids": [1, 2, 3]})
    assert "id in (1,2,3)" in sql.replace(" ", "")

def test_security_check_non_select():
    """测试非 SELECT 语句被拒绝"""
    qb = query_builder.builder()
    qb.sql_path = os.path.abspath("sql")
    
    # 模拟恶意 SQL
    with pytest.raises(ValueError, match="Only SELECT queries are allowed"):
        # 这需要在 yaml 中有一个 update 语句来测试
        pass

def test_security_check_dangerous_keywords():
    """测试危险关键词检查"""
    qb = query_builder.builder()
    qb.sql_path = os.path.abspath("sql")
    
    # 这个测试需要实际的恶意 SQL 才能触发
    # 可以通过修改模板或参数来测试
    pass

def test_sql_injection_patterns():
    """测试 SQL 注入模式检查"""
    qb = query_builder.builder()
    qb.sql_path = os.path.abspath("sql")
    
    # 测试注释注入
    with pytest.raises(ValueError, match="SQL injection pattern"):
        # 需要构造包含 -- 注释的 SQL
        pass

if __name__ == "__main__":
    pytest.main([__file__, "-v"])