def test_example():
    assert 1 + 1 == 2

import logging
from flask import Flask

app = Flask(__name__)

# Настройка логирования
logging.basicConfig(level=logging.INFO)

@app.route('/')
def home():
    app.logger.info('Home page accessed')
    return "Hello, World!"

