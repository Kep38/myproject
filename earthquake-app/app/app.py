import os
import requests
from flask import Flask, render_template
from flask_sqlalchemy import SQLAlchemy
from flask_socketio import SocketIO, emit
import datetime

# Инициализация приложения
app = Flask(__name__)

# Получаем данные из переменных окружения для подключения к базе данных
db_user = os.environ.get('DB_USER')
db_password = os.environ.get('DB_PASSWORD')
db_host = os.environ.get('DB_HOST')
db_port = os.environ.get('DB_PORT')
db_name = os.environ.get('DB_NAME')

# Проверяем, заданы ли все необходимые переменные окружения для подключения к базе данных
if db_user and db_password and db_host and db_port and db_name:
    app.config['SQLALCHEMY_DATABASE_URI'] = f'postgresql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}'
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    db = SQLAlchemy(app)
else:
    db = None

# Инициализация сокетов
socketio = SocketIO(app)

# Модель для хранения данных о землетрясениях
class Earthquake(db.Model if db else object):
    id = db.Column(db.Integer, primary_key=True) if db else None
    location = db.Column(db.String(120), nullable=False) if db else None
    magnitude = db.Column(db.Float, nullable=False) if db else None
    time = db.Column(db.DateTime, default=datetime.datetime.utcnow) if db else None

# Главная страница с отображением событий
@app.route('/')
def index():
    if db:
        earthquakes = Earthquake.query.all()
    else:
        earthquakes = []
    return render_template('index.html', earthquakes=earthquakes)

# Функция для получения данных о землетрясениях с API USGS
def fetch_earthquake_data():
    USGS_API_URL = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson"
    response = requests.get(USGS_API_URL)
    data = response.json()
    earthquakes = []
    for feature in data['features']:
        earthquakes.append({
            'location': feature['properties']['place'],
            'magnitude': feature['properties']['mag'],
            'time': datetime.datetime.fromtimestamp(feature['properties']['time'] / 1000).strftime('%Y-%m-%d %H:%M:%S')
        })
    return earthquakes

# Отправка данных о землетрясениях клиентам
@socketio.on('connect')
def handle_connect():
    earthquakes = fetch_earthquake_data()
    for earthquake in earthquakes:
        emit('new_earthquake', earthquake)

# Запуск приложения
if __name__ == '__main__':
    socketio.run(app, host='0.0.0.0', port=5000, debug=True, allow_unsafe_werkzeug=True)
