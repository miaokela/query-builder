"""
Type stubs for query_builder Rust extension module.
This file provides type hints for VS Code and other IDEs.
"""

from typing import Optional, Dict, Any, Union, List

class PyQueryBuilder:
    """
    A secure SQL query builder using Tera templates with built-in SQL injection protection.
    
    This class loads SQL templates from YAML files into memory for fast access and allows
    you to build queries using template keys with automatic security validation.
    """
    
    def __init__(self) -> None:
        """
        Initialize a new PyQueryBuilder instance.
        
        You must set the sql_path and call load_all_templates() before building queries.
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
    
    def load_all_templates(self) -> None:
        """
        Load all SQL templates from the configured directory into memory.
        
        This method scans all YAML files in the sql_path directory and loads
        all templates with keys in format "filename.template_key".
        
        Raises:
            ValueError: If sql_path is not set or directory doesn't exist.
            IOError: If files cannot be read or parsed.
            
        Example:
            >>> builder = PyQueryBuilder()
            >>> builder.sql_path = "./sql"
            >>> builder.load_all_templates()  # Loads all *.yaml files
        """
        ...
    
    def build(self, key: str, **kwargs: Any) -> str:
        """
        Build a SQL query from a template using the provided parameters.
        
        Templates must be loaded into memory first using load_all_templates().
        
        Args:
            key (str): Template key in format "file.template" (e.g., "users.select_by_id").
            **kwargs: Template variables to substitute in the query.
        
        Returns:
            str: The rendered SQL query string.
        
        Raises:
            ValueError: If templates not loaded, template syntax is invalid, 
                       or SQL injection is detected.
            KeyError: If the specified template key is not found in memory.
            
        Example:
            >>> builder = PyQueryBuilder()
            >>> builder.sql_path = "/path/to/sql/templates"
            >>> builder.load_all_templates()
            >>> sql = builder.build("users.select_by_id", user_id=123)
            >>> print(sql)
            SELECT * FROM users WHERE id = 123
        """
        ...
    
    def get_template_keys(self) -> List[str]:
        """
        Get all available template keys loaded in memory.
        
        Returns:
            List[str]: List of all loaded template keys in format "file.template".
            
        Example:
            >>> builder = PyQueryBuilder()
            >>> builder.sql_path = "./sql"
            >>> builder.load_all_templates()
            >>> keys = builder.get_template_keys()
            >>> print(keys)
            ['users.select_by_id', 'users.list_all', 'orders.recent']
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
        >>> qb.load_all_templates()
        >>> sql = qb.build("users.list")
    """
    ...

# Module-level constants and metadata
__version__: str = "0.2.0"
__author__: str = "缪克拉"
__email__: str = "2972799448@qq.com"