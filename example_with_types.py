"""
Example usage of the query_builder library with improved type hints.

This demonstrates how VS Code will now provide better IntelliSense support
for the PyO3-based query_builder library.
"""

# Import with type hints now available
from query_builder import PyQueryBuilder, builder

def main():
    # Method 1: Using the class directly
    qb = PyQueryBuilder()
    
    # VS Code will now show property suggestions
    qb.sql_path = "./sql"  # Type: str
    
    # VS Code will show method signatures and documentation
    try:
        sql = qb.build(
            "users.select_by_id",  # key parameter with type hint
            user_id=123,           # **kwargs with type hints
            status="active"
        )
        print("Generated SQL:", sql)
    except (ValueError, KeyError) as e:
        print("Error:", e)
    
    # Method 2: Using the convenience function
    qb2 = builder()  # Returns PyQueryBuilder with type hints
    qb2.sql_path = "./sql"
    
    # Accessing properties with type hints
    current_path = qb2.sql_path  # Type: Optional[str]
    print("Current SQL path:", current_path)
    
    # All methods now have proper type hints and documentation
    try:
        query = qb2.build("api.user", table="users", limit=10)
        print("API Query:", query)
    except Exception as e:
        print("Query error:", e)

if __name__ == "__main__":
    main()