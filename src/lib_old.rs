
use std::fs;
use std::path::{Path, PathBuf};
use std::collections::HashMap;
use pyo3::prelude::*;
use pyo3::types::PyDict;
use tera::{Tera, Context};

#[pyclass]
struct PySQLBuilder {
    sql_dir: String,
}

#[pymethods]
impl PySQLBuilder {
    #[new]
    fn new(sql_dir: Option<String>) -> Self {
        Self {
            sql_dir: sql_dir.unwrap_or_else(|| "sql".to_string()),
        }
    }

    fn build(&self, _py: Python, key: &str, kwargs: Option<&PyDict>) -> PyResult<String> {
        let (file_path, template_key) = resolve_key(&self.sql_dir, key)?;
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
        Ok(rendered)
    }
}

#[pyfunction]
fn builder(sql_dir: Option<String>) -> PyResult<PySQLBuilder> {
    Ok(PySQLBuilder::new(sql_dir))
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


#[pymodule]
fn sql_builder(_py: Python, m: &PyModule) -> PyResult<()> {
    m.add_class::<PySQLBuilder>()?;
    m.add_function(wrap_pyfunction!(builder, m)?)?;
    Ok(())
}
