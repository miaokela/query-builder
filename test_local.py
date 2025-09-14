#!/usr/bin/env python3
"""
Test script to verify the query-builder package works correctly.
"""

import query_builder
import os
import tempfile
import yaml

def test_basic_functionality():
    print("Testing basic functionality...")
    
    # Create temporary directory for test files
    with tempfile.TemporaryDirectory() as temp_dir:
        # Create a test SQL template file
        sql_templates = {
            'get_users': 'SELECT * FROM users WHERE status = "{{ status }}" {% if limit %}LIMIT {{ limit }}{% endif %};',
            'get_user_by_id': 'SELECT * FROM users WHERE id = {{ user_id }};'
        }
        
        sql_file = os.path.join(temp_dir, 'test_queries.yaml')
        with open(sql_file, 'w') as f:
            yaml.dump(sql_templates, f)
        
        # Test the query builder
        qb = query_builder.PyQueryBuilder()
        qb.sql_path = temp_dir  # Use property assignment
        
        # Test simple template
        result1 = qb.build('test_queries.get_user_by_id', {'user_id': 123})
        expected1 = 'SELECT * FROM users WHERE id = 123;'
        assert result1 == expected1, f"Expected: {expected1}, Got: {result1}"
        print("✓ Simple template test passed")
        
        # Test conditional template
        result2 = qb.build('test_queries.get_users', {'status': 'active', 'limit': 10})
        expected2 = 'SELECT * FROM users WHERE status = "active" LIMIT 10;'
        assert result2 == expected2, f"Expected: {expected2}, Got: {result2}"
        print("✓ Conditional template test passed")
        
        # Test without limit
        result3 = qb.build('test_queries.get_users', {'status': 'active'})
        expected3 = 'SELECT * FROM users WHERE status = "active" ;'
        assert result3 == expected3, f"Expected: {expected3}, Got: {result3}"
        print("✓ Template without condition test passed")
        
        print("All tests passed! 🎉")

if __name__ == '__main__':
    test_basic_functionality()