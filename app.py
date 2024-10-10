import sentry_sdk
from flask import Flask

# Инициализация Sentry
sentry_sdk.init(
    dsn="https://e69b420afb64490f4222cf8a3b0dfca9@o4508099311108096.ingest.de.sentry.io/4508099331358800",
    traces_sample_rate=1.0,  # Захват 100% транзакций
    profiles_sample_rate=1.0,  # Захват 100% профилей
)

app = Flask(__name__)

@app.route('/')
def home():
    return "Добро пожаловать в математическое приложение!"

@app.route('/info')
def info():
    return "Это приложение для выполнения простых математических операций."

@app.route('/divide/<int:numerator>/<int:denominator>')
def divide(numerator, denominator):
    try:
        if denominator == 0:
            raise ValueError("Делитель не может быть равен нулю.")
        result = numerator / denominator
        return f"Результат деления: {result}"
    except ValueError as e:
        app.logger.error(f"Произошла ошибка: {e}")
        return str(e), 400

@app.route('/subtract/<int:minuend>/<int:subtrahend>')
def subtract(minuend, subtrahend):
    result = minuend - subtrahend
    return f"Результат вычитания: {result}"

if __name__ == "__main__":
    app.run(debug=True)  # Включите режим отладки для более удобного тестирования

