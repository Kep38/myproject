import pytest
from app import app

@pytest.fixture
def client():
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_home(client):
    rv = client.get('/')
    assert b'Добро пожаловать в математическое приложение!' in rv.data

def test_divide(client):
    rv = client.get('/divide/10/2')
    assert b'Результат: 5.0' in rv.data

def test_divide_by_zero(client):
    rv = client.get('/divide/10/0')
    assert b'Деление на ноль.' in rv.data
    assert rv.status_code == 400
