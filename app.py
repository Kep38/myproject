import sentry_sdk
from flask import Flask

# Инициализация Sentry
sentry_sdk.init(
    dsn=********
    traces_sample_rate=1.0,
    profiles_sample_rate=1.0,
)

app = Flask(__name__)

@app.route('/')
def home():
    return "Добро пожаловать в математическое приложение!"

@app.route('/divide/<int:numerator>/<int:denominator>')
def divide(numerator, denominator):
    try:
        if denominator == 0:
            raise ValueError("Деление на ноль.")
        result = numerator / denominator
        return f"Результат: {result}"
    except ValueError as e:
        app.logger.error(f"Ошибка: {e}")
        return str(e), 400

if __name__ == "__main__":
    app.run(debug=True)
