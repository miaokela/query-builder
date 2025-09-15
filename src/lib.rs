use std::fs;
use std::path::{Path, PathBuf};
use std::collections::HashMap;
use pyo3::prelude::*;
use pyo3::types::PyDict;
use tera::{Tera, Context};
use regex::Regex;

#[pyclass]
/// A secure SQL query builder using Tera templates with built-in SQL injection protection.
///
/// This class allows you to build SQL queries from YAML template files using the Tera
/// templating engine, with automatic security validation to prevent SQL injection attacks.
/// Templates are loaded into memory for better performance.
struct PyQueryBuilder {
    sql_path: Option<String>,
    /// In-memory storage for all loaded SQL templates
    /// Key format: "file.template" (e.g., "users.select_by_id")
    templates: HashMap<String, String>,
}

#[pymethods]
impl PyQueryBuilder {
    #[new]
    /// Initialize a new PyQueryBuilder instance.
    ///
    /// You must set the sql_path and call load_all_templates() before building queries.
    fn new() -> Self {
        Self {
            sql_path: None,
            templates: HashMap::new(),
        }
    }

    #[setter]
    /// Set the SQL templates directory path.
    ///
    /// Args:
    ///     path (str): Path to the directory containing YAML template files.
    fn set_sql_path(&mut self, path: String) {
        self.sql_path = Some(path);
    }

    #[getter]
    /// Get the current SQL templates directory path.
    ///
    /// Returns:
    ///     Optional[str]: The path to the SQL templates directory, or None if not set.
    fn get_sql_path(&self) -> Option<String> {
        self.sql_path.clone()
    }

    /// Load all SQL templates from the configured directory into memory.
    ///
    /// This method scans all YAML files in the sql_path directory and loads
    /// all templates with keys in format "filename.template_key".
    ///
    /// Raises:
    ///     ValueError: If sql_path is not set or directory doesn't exist.
    ///     IOError: If files cannot be read or parsed.
    ///
    /// Example:
    ///     >>> builder = PyQueryBuilder()
    ///     >>> builder.sql_path = "./sql"
    ///     >>> builder.load_all_templates()  # Loads all *.yaml files
    fn load_all_templates(&mut self) -> PyResult<()> {
        let sql_dir = self.sql_path.as_ref()
            .ok_or_else(|| pyo3::exceptions::PyValueError::new_err("sql_path must be set before loading templates"))?;

        let sql_path = Path::new(sql_dir);
        if !sql_path.exists() {
            return Err(pyo3::exceptions::PyValueError::new_err(format!("SQL directory does not exist: {}", sql_dir)));
        }

        // Clear existing templates
        self.templates.clear();

        // Read all .yaml files in the directory
        let entries = fs::read_dir(sql_path)
            .map_err(|e| pyo3::exceptions::PyIOError::new_err(format!("Failed to read directory {}: {}", sql_dir, e)))?;

        for entry in entries {
            let entry = entry.map_err(|e| pyo3::exceptions::PyIOError::new_err(e.to_string()))?;
            let path = entry.path();
            
            if path.is_file() && path.extension().and_then(|s| s.to_str()) == Some("yaml") {
                let filename = path.file_stem()
                    .and_then(|s| s.to_str())
                    .ok_or_else(|| pyo3::exceptions::PyValueError::new_err("Invalid filename"))?;

                // Load YAML file
                let sql_map = load_yaml(&path)?;
                
                // Add all templates with filename.key format
                for (template_key, template_content) in sql_map {
                    let full_key = format!("{}.{}", filename, template_key);
                    self.templates.insert(full_key, template_content);
                }
            }
        }

        Ok(())
    }

    /// Build a SQL query from a template key with parameters.
    ///
    /// Templates must be loaded into memory first using load_all_templates().
    ///
    /// Args:
    ///     key (str): Template key in format "file.template" (e.g., "users.select_by_id").
    ///     params (Optional[Dict]): Template variables as a dictionary (old API).
    ///     **kwargs: Template variables to substitute in the query (new API).
    ///
    /// Returns:
    ///     str: The rendered SQL query string.
    ///
    /// Raises:
    ///     ValueError: If templates not loaded, template syntax is invalid, 
    ///                or SQL injection is detected.
    ///     KeyError: If the specified template key is not found in memory.
    ///
    /// Example:
    ///     >>> builder = PyQueryBuilder()
    ///     >>> builder.sql_path = "/path/to/sql/templates"
    ///     >>> builder.load_all_templates()
    ///     >>> # New API (recommended)
    ///     >>> sql = builder.build("users.select_by_id", user_id=123)
    ///     >>> # Old API (backward compatibility)
    ///     >>> sql = builder.build("users.select_by_id", {"user_id": 123})
    ///     >>> print(sql)
    ///     SELECT * FROM users WHERE id = 123
    #[pyo3(signature = (key, params=None, **kwargs))]
    fn build(&self, key: &str, params: Option<&Bound<'_, PyDict>>, kwargs: Option<&Bound<'_, PyDict>>) -> PyResult<String> {
        // Get template from memory
        let template = self.templates.get(key)
            .ok_or_else(|| pyo3::exceptions::PyKeyError::new_err(
                format!("Template '{}' not found in memory. Available templates: {:?}", 
                    key, self.templates.keys().collect::<Vec<_>>())
            ))?;
        
        let mut tera = Tera::default();
        tera.add_raw_template("tpl", template).map_err(|e| pyo3::exceptions::PyValueError::new_err(e.to_string()))?;
        let mut context = Context::new();
        
        // Handle both old (params dict) and new (kwargs) API styles
        if let Some(params) = params {
            // Old API: build("template", {"key": "value"})
            for (k, v) in params.iter() {
                let key_str = k.extract::<String>()?;
                if let Ok(val) = v.extract::<String>() {
                    context.insert(&key_str, &val);
                } else if let Ok(val) = v.extract::<i64>() {
                    context.insert(&key_str, &val);
                } else if let Ok(val) = v.extract::<f64>() {
                    context.insert(&key_str, &val);
                } else if let Ok(val) = v.extract::<Vec<String>>() {
                    context.insert(&key_str, &val);
                } else if let Ok(val) = v.extract::<Vec<i64>>() {
                    context.insert(&key_str, &val);
                } else if let Ok(val) = v.extract::<HashMap<String, String>>() {
                    context.insert(&key_str, &val);
                }
            }
        }
        
        if let Some(kwargs) = kwargs {
            // New API: build("template", key="value")
            for (k, v) in kwargs.iter() {
                let key_str = k.extract::<String>()?;
                if let Ok(val) = v.extract::<String>() {
                    context.insert(&key_str, &val);
                } else if let Ok(val) = v.extract::<i64>() {
                    context.insert(&key_str, &val);
                } else if let Ok(val) = v.extract::<f64>() {
                    context.insert(&key_str, &val);
                } else if let Ok(val) = v.extract::<Vec<String>>() {
                    context.insert(&key_str, &val);
                } else if let Ok(val) = v.extract::<Vec<i64>>() {
                    context.insert(&key_str, &val);
                } else if let Ok(val) = v.extract::<HashMap<String, String>>() {
                    context.insert(&key_str, &val);
                }
            }
        }
        
        let rendered = tera.render("tpl", &context).map_err(|e| pyo3::exceptions::PyValueError::new_err(e.to_string()))?;
        
        // SQL 安全检查
        validate_sql_security(&rendered)?;
        
        Ok(rendered)
    }

    /// Get all available template keys loaded in memory.
    ///
    /// Returns:
    ///     List[str]: List of all loaded template keys in format "file.template".
    ///
    /// Example:
    ///     >>> builder = PyQueryBuilder()
    ///     >>> builder.sql_path = "./sql"
    ///     >>> builder.load_all_templates()
    ///     >>> keys = builder.get_template_keys()
    ///     >>> print(keys)
    ///     ['users.select_by_id', 'users.list_all', 'orders.recent']
    fn get_template_keys(&self) -> Vec<String> {
        self.templates.keys().cloned().collect()
    }
}

#[pyfunction]
/// Create a new PyQueryBuilder instance.
///
/// This is a convenience function equivalent to PyQueryBuilder().
///
/// Returns:
///     PyQueryBuilder: A new query builder instance.
///
/// Example:
///     >>> qb = builder()
///     >>> qb.sql_path = "/path/to/templates"
///     >>> sql = qb.build("users.list")
fn builder() -> PyResult<PyQueryBuilder> {
    Ok(PyQueryBuilder::new())
}

fn resolve_key(sql_dir: &str, key: &str) -> PyResult<(PathBuf, String)> {
    let mut parts: Vec<&str> = key.split('.').collect();
    if parts.len() < 2 {
        return Err(pyo3::exceptions::PyValueError::new_err("Key must be in the form 'file.key' or 'dir.file.key'"));
    }
    let template_key = parts.pop().unwrap().to_string();
    let file = parts.join(".");
    let mut path = PathBuf::from(sql_dir);
    path.push(format!("{}.yaml", file));
    Ok((path, template_key))
}

fn load_yaml(path: &Path) -> PyResult<HashMap<String, String>> {
    let content = fs::read_to_string(path)
        .map_err(|e| pyo3::exceptions::PyIOError::new_err(e.to_string()))?;
    let map: HashMap<String, String> = serde_yaml::from_str(&content)
        .map_err(|e| pyo3::exceptions::PyValueError::new_err(e.to_string()))?;
    Ok(map)
}

fn validate_sql_security(sql: &str) -> PyResult<()> {
    let sql_lower = sql.to_lowercase();
    
    // 检查是否为查询语句
    let trimmed = sql_lower.trim();
    if !trimmed.starts_with("select") {
        return Err(pyo3::exceptions::PyValueError::new_err("Only SELECT queries are allowed"));
    }
    
    // 检查危险关键词
    let dangerous_keywords = [
        "drop", "delete", "insert", "update", "create", "alter", 
        "truncate", "exec", "execute", "sp_", "xp_", "union",
        "script", "javascript", "vbscript", "onload", "onerror"
    ];
    
    for keyword in &dangerous_keywords {
        let pattern = format!(r"\b{}\b", regex::escape(keyword));
        let re = Regex::new(&pattern).unwrap();
        if re.is_match(&sql_lower) {
            return Err(pyo3::exceptions::PyValueError::new_err(format!("Dangerous keyword '{}' detected", keyword)));
        }
    }
    
    // 检查潜在的 SQL 注入模式（更精确的模式）
    let injection_patterns = [
        r"--\s*",       // SQL 注释
        r"/\*.*\*/",    // 多行注释
        r";\s*\w+",     // 分号后跟语句
        r"'\s*or\s+'1'\s*=\s*'1'",  // 经典注入
        r"'\s*or\s+1\s*=\s*1",      // 经典注入
        r"'\s*union\s+select",       // UNION 注入
        r"'\s*;\s*drop",            // 删除表注入
    ];
    
    for pattern in &injection_patterns {
        let re = Regex::new(pattern).unwrap();
        if re.is_match(&sql_lower) {
            return Err(pyo3::exceptions::PyValueError::new_err("Potential SQL injection pattern detected"));
        }
    }
    
    Ok(())
}

#[pymodule]
fn query_builder(_py: Python, m: &Bound<'_, PyModule>) -> PyResult<()> {
    m.add_class::<PyQueryBuilder>()?;
    m.add_function(wrap_pyfunction!(builder, m)?)?;
    Ok(())
}