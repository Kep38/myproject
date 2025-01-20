# Используем официальный образ Python в качестве базового
FROM python:3.9-slim

# Обновляем pip
RUN pip install --upgrade pip

# Копируем файл requirements.txt в корневой каталог контейнера
COPY requirements.txt .

# Устанавливаем зависимости
RUN pip install --no-cache-dir -r requirements.txt

# Копируем все приложение в контейнер и устанавливаем рабочую директорию
COPY . /app
WORKDIR /app

# Запускаем приложение
CMD ["python", "app/app.py"]

