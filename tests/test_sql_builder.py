import pytest
from sql_builder import builder

def test_if_else():
    sb = builder()
    assert (
        sb.build("tera_demo.if_else", name="Tom").strip()
        == "select * from user\nwhere name = 'Tom'"
    )
    assert (
        sb.build("tera_demo.if_else").strip()
        == "select * from user\nwhere 1=1"
    )

def test_for_list():
    sb = builder()
    sql = sb.build("tera_demo.for_list", ids=[1,2,3])
    assert "1,2,3" in sql.replace(" ", "")

def test_complex():
    sb = builder()
    sql = sb.build("tera_demo.complex", user_id=1, data={"age": 18, "city": "Beijing"})
    assert "age = '18'" in sql
    assert "city = 'Beijing'" in sql
    assert "where id = 1" in sql

if __name__ == "__main__":
    pytest.main([__file__])
