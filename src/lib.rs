use std::fs;
use std::path::{Path, PathBuf};
use std::collections::HashMap;
use pyo3::prelude::*;
use pyo3::types::PyDict;
use tera::{Tera, Context};
use regex::Regex;

#[pyclass]
struct PyQueryBuilder {
    sql_path: Option<String>,
}

#[pymethods]
impl PyQueryBuilder {
    #[new]
    fn new() -> Self {
        Self {
            sql_path: None,
        }
    }

    #[setter]
    fn set_sql_path(&mut self, path: String) {
        self.sql_path = Some(path);
    }

    #[getter]
    fn get_sql_path(&self) -> Option<String> {
        self.sql_path.clone()
    }

    fn build(&self, _py: Python, key: &str, kwargs: Option<&PyDict>) -> PyResult<String> {
        let sql_dir = self.sql_path.as_ref()
            .ok_or_else(|| pyo3::exceptions::PyValueError::new_err("sql_path must be set before building queries"))?;
        
        let (file_path, template_key) = resolve_key(sql_dir, key)?;
        let sql_map = load_yaml(&file_path)?;
        let template = sql_map.get(&template_key)
            .ok_or_else(|| pyo3::exceptions::PyKeyError::new_err(format!("Key '{}' not found in {:?}", template_key, file_path)))?;
        
        let mut tera = Tera::default();
        tera.add_raw_template("tpl", template).map_err(|e| pyo3::exceptions::PyValueError::new_err(e.to_string()))?;
        let mut context = Context::new();
        
        if let Some(kwargs) = kwargs {
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
}

#[pyfunction]
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
fn query_builder(_py: Python, m: &PyModule) -> PyResult<()> {
    m.add_class::<PyQueryBuilder>()?;
    m.add_function(wrap_pyfunction!(builder, m)?)?;
    Ok(())
}