import smtplib
from email.mime.text import MIMEText
import sentry_sdk
from sentry_sdk.integrations.flask import FlaskIntegration

# Инициализация Sentry
sentry_sdk.init(
    dsn="ВАШ_DSN_КЛЮЧ_ЗДЕСЬ",  # Замените на ваш DSN-ключ Sentry
    integrations=[FlaskIntegration()]
)

def send_email(subject, body):
    sender_email = "red571@list.ru"
    receiver_email = "red571@list.ru"
    password = "FYbbfpqbawXnfFzPy5Ju"

    # Создаем сообщение
    msg = MIMEText(body)
    msg['Subject'] = subject
    msg['From'] = sender_email
    msg['To'] = receiver_email

    # Отправляем сообщение
    try:
        with smtplib.SMTP_SSL('smtp.mail.ru', 465) as server:
            server.login(sender_email, password)
            server.sendmail(sender_email, receiver_email, msg.as_string())
            print("Email sent successfully!")
    excep

