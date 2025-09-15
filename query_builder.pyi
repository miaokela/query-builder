"""
Type stubs for query_builder Rust extension module.
This file provides type hints for VS Code and other IDEs.
"""

from typing import Optional, Dict, Any, Union

class PyQueryBuilder:
    """
    A secure SQL query builder using Tera templates with built-in SQL injection protection.
    
    This class allows you to build SQL queries from YAML template files using the Tera
    templating engine, with automatic security validation to prevent SQL injection attacks.
    """
    
    def __init__(self) -> None:
        """
        Initialize a new PyQueryBuilder instance.
        
        You must set the sql_path before building queries.
        """
        ...
    
    @property
    def sql_path(self) -> Optional[str]:
        """
        Get the current SQL templates directory path.
        
        Returns:
            Optional[str]: The path to the SQL templates directory, or None if not set.
        """
        ...
    
    @sql_path.setter
    def sql_path(self, path: str) -> None:
        """
        Set the SQL templates directory path.
        
        Args:
            path (str): Path to the directory containing YAML template files.
        """
        ...
    
    def set_sql_path(self, path: str) -> None:
        """
        Set the SQL templates directory path.
        
        Args:
            path (str): Path to the directory containing YAML template files.
        """
        ...
    
    def get_sql_path(self) -> Optional[str]:
        """
        Get the current SQL templates directory path.
        
        Returns:
            Optional[str]: The path to the SQL templates directory, or None if not set.
        """
        ...
    
    def build(self, key: str, **kwargs: Any) -> str:
        """
        Build a SQL query from a template using the provided parameters.
        
        Args:
            key (str): Template key in format "file.template" or just "template" 
                      (searches in queries.yaml by default).
            **kwargs: Template variables to substitute in the query.
        
        Returns:
            str: The rendered SQL query string.
        
        Raises:
            ValueError: If sql_path is not set, template syntax is invalid, 
                       or SQL injection is detected.
            KeyError: If the specified template key is not found.
            
        Example:
            >>> builder = PyQueryBuilder()
            >>> builder.sql_path = "/path/to/sql/templates"
            >>> sql = builder.build("users.select_by_id", user_id=123)
            >>> print(sql)
            SELECT * FROM users WHERE id = 123
        """
        ...

def builder() -> PyQueryBuilder:
    """
    Create a new PyQueryBuilder instance.
    
    This is a convenience function equivalent to PyQueryBuilder().
    
    Returns:
        PyQueryBuilder: A new query builder instance.
        
    Example:
        >>> qb = builder()
        >>> qb.sql_path = "/path/to/templates"
        >>> sql = qb.build("users.list")
    """
    ...

# Module-level constants and metadata
__version__: str = "0.1.16"
__author__: str = "缪克拉"
__email__: str = "2972799448@qq.com"