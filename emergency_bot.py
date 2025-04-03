import telebot
import mysql.connector

TOKEN = "TELEGRAM_TOKEN"
bot = telebot.TeleBot(TOKEN)

# Налаштування підключення до бази даних (використовуйте ті ж параметри, що і у bot.py)
DB_HOST = "localhost"
DB_USER = "USER"
DB_PASSWORD = "PASSWORD"
DB_NAME = "DB_NAME"

def get_subscribers():
    try:
        connection = mysql.connector.connect(
            host=DB_HOST,
            user=DB_USER,
            password=DB_PASSWORD,
            database=DB_NAME
        )
        cursor = connection.cursor()
        cursor.execute("SELECT chat_id FROM emergency_bot_subscribers")
        subscribers = [row[0] for row in cursor.fetchall()]
        cursor.close()
        connection.close()
        return subscribers
    except mysql.connector.Error as err:
        print(f"Помилка підключення до бази: {err}")
        return []

subscribers = get_subscribers()
for chat_id in subscribers:
    bot.send_message(chat_id, "БОТ ВИЛЕТІВ")
