"""
Example usage of the query_builder library with improved memory-based template loading.

This demonstrates the new optimized approach where all SQL templates are loaded
into memory once, then accessed for fast query building.
"""

# Import with type hints now available
from query_builder import PyQueryBuilder, builder

def main():
    print("=== Query Builder Memory-Based Template Example ===\n")
    
    # Method 1: Using the class directly
    qb = PyQueryBuilder()
    
    # Set the SQL templates directory
    qb.sql_path = "./sql"  # Type: str
    print(f"SQL path set to: {qb.sql_path}")
    
    # Load all templates into memory (one-time operation)
    try:
        qb.load_all_templates()
        print("✅ All templates loaded successfully into memory")
        
        # Get all available template keys
        available_keys = qb.get_template_keys()
        print(f"📝 Available templates: {available_keys}")
        
    except (ValueError, IOError) as e:
        print(f"❌ Failed to load templates: {e}")
        return
    
    # Now build queries from memory (fast!)
    try:
        # Example 1: User queries
        if "users.select_by_id" in available_keys:
            sql = qb.build("users.select_by_id", user_id=123)
            print(f"\n🔍 Generated SQL:\n{sql}")
        
        # Example 2: API queries with multiple parameters
        if "api.user" in available_keys:
            sql = qb.build(
                "api.user",
                table="users",
                limit=10,
                status="active"
            )
            print(f"\n📊 API Query:\n{sql}")
            
    except (KeyError, ValueError) as e:
        print(f"❌ Query error: {e}")
    
    print("\n" + "="*50)
    
    # Method 2: Using the convenience function
    qb2 = builder()  # Returns PyQueryBuilder with type hints
    qb2.sql_path = "./sql"
    
    try:
        qb2.load_all_templates()
        print("✅ Second builder instance loaded templates")
        
        # Demonstrate error handling for non-existent keys
        try:
            sql = qb2.build("nonexistent.template")
        except KeyError as e:
            print(f"🚫 Expected error for missing template: {e}")
            
    except Exception as e:
        print(f"❌ Setup error: {e}")

def performance_demo():
    """
    Demonstrate the performance benefit of memory-based templates.
    """
    print("\n=== Performance Comparison Demo ===")
    
    qb = PyQueryBuilder()
    qb.sql_path = "./sql"
    
    try:
        # Load templates once
        import time
        start = time.time()
        qb.load_all_templates()
        load_time = time.time() - start
        print(f"⚡ Template loading time: {load_time:.4f}s")
        
        # Multiple fast queries from memory
        available_keys = qb.get_template_keys()
        if available_keys:
            key = available_keys[0]
            
            start = time.time()
            for i in range(100):
                sql = qb.build(key, iteration=i)
            query_time = time.time() - start
            print(f"🚀 100 queries from memory: {query_time:.4f}s")
            print(f"📈 Average per query: {query_time/100*1000:.2f}ms")
            
    except Exception as e:
        print(f"❌ Performance demo error: {e}")

if __name__ == "__main__":
    main()
    performance_demo()