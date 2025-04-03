import telebot

TOKEN = "TELEGRAM_TOKEN"
bot = telebot.TeleBot(TOKEN)
chat_id = 'chat_id'

bot.send_message(chat_id, "БОТ ВИЛЕТІВ ")

