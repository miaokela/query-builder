#!/usr/bin/env python3
"""
Query Builder PyPI 包安装验证脚本
用于验证从PyPI安装的query-builder包是否正常工作
"""

import sys
import subprocess
import tempfile
import os

def test_installation():
    """测试PyPI包安装和基本功能"""
    print("🧪 Query Builder PyPI 包验证测试")
    print("=" * 50)
    
    try:
        # 测试包导入
        print("1. 测试包导入...")
        import query_builder
        print("   ✅ 包导入成功")
        
        # 测试基本功能
        print("2. 测试基本功能...")
        qb = query_builder.PyQueryBuilder()
        print("   ✅ PyQueryBuilder 实例化成功")
        
        # 创建临时SQL文件进行测试
        print("3. 测试SQL模板渲染...")
        with tempfile.TemporaryDirectory() as temp_dir:
            # 创建测试SQL文件
            sql_file = os.path.join(temp_dir, "test.yaml")
            with open(sql_file, 'w') as f:
                f.write("""
simple_query: |
  SELECT * FROM users WHERE id = {{ user_id }};

conditional_query: |
  SELECT * FROM products 
  WHERE category = "{{ category }}"
  {% if price_min %}AND price >= {{ price_min }}{% endif %};
""")
            
            # 设置SQL路径
            qb.sql_path = temp_dir
            
            # 测试简单查询
            result1 = qb.build("test.simple_query", {"user_id": 123})
            expected1 = "SELECT * FROM users WHERE id = 123;"
            assert expected1.strip() in result1.strip(), f"期望: {expected1}, 实际: {result1}"
            print("   ✅ 简单查询渲染成功")
            
            # 测试条件查询
            result2 = qb.build("test.conditional_query", {
                "category": "electronics",
                "price_min": 100
            })
            assert "electronics" in result2 and "100" in result2
            print("   ✅ 条件查询渲染成功")
        
        print("4. 测试安全验证...")
        # 这里应该会抛出异常，因为包含危险关键词
        try:
            with tempfile.TemporaryDirectory() as temp_dir:
                sql_file = os.path.join(temp_dir, "danger.yaml")
                with open(sql_file, 'w') as f:
                    f.write("malicious: |\\n  DROP TABLE users;")
                qb.sql_path = temp_dir
                qb.build("danger.malicious", {})
                print("   ❌ 安全验证失败 - 应该阻止危险SQL")
                return False
        except Exception:
            print("   ✅ 安全验证成功 - 成功阻止危险SQL")
        
        print("\\n🎉 所有测试通过！Query Builder PyPI包工作正常！")
        return True
        
    except ImportError as e:
        print(f"   ❌ 包导入失败: {e}")
        print("\\n💡 解决方案:")
        print("   1. 确保已安装: pip install query-builder")
        print("   2. 检查Python环境是否正确")
        return False
        
    except Exception as e:
        print(f"   ❌ 测试失败: {e}")
        return False

def install_and_test():
    """安装包并测试"""
    print("📦 开始安装和测试 query-builder...")
    print("=" * 50)
    
    try:
        # 尝试安装包
        print("正在从PyPI安装 query-builder...")
        result = subprocess.run([
            sys.executable, "-m", "pip", "install", "query-builder"
        ], capture_output=True, text=True)
        
        if result.returncode == 0:
            print("✅ 安装成功！")
            print("\\n开始功能测试...")
            return test_installation()
        else:
            print(f"❌ 安装失败: {result.stderr}")
            print("\\n💡 可能的原因:")
            print("   1. 包还未发布到PyPI")
            print("   2. 网络连接问题")
            print("   3. Python版本不兼容")
            return False
            
    except Exception as e:
        print(f"❌ 安装过程出错: {e}")
        return False

if __name__ == "__main__":
    print("🚀 Query Builder PyPI 验证工具")
    print("用途: 验证从PyPI安装的query-builder包")
    print("时间:", subprocess.check_output(['date'], text=True).strip())
    print()
    
    # 检查是否已安装
    try:
        import query_builder
        print("📋 检测到已安装的 query-builder，直接测试功能...")
        success = test_installation()
    except ImportError:
        print("📋 未检测到 query-builder，尝试从PyPI安装...")
        success = install_and_test()
    
    if success:
        print("\\n🎊 验证完成！query-builder 可以正常使用！")
        sys.exit(0)
    else:
        print("\\n🔧 验证失败，请检查安装或等待PyPI发布完成")
        sys.exit(1)