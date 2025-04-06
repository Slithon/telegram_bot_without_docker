#!/bin/bash
set -e

# ==================== Налаштування змінних ====================
# Git репозиторій
REPO_URL="https://github.com/Slithon/telegram_bot_without_docker"
REPO_DIR="telegram_bot_without_docker"

# MySQL налаштування
MYSQL_ROOT_PASSWORD="your_mysql_root_password"
BOT_DB_NAME="DB_NAME"
BOT_DB_USER="USER"
BOT_DB_PASSWORD="PASSWORD"

# Налаштування для оновлення файлу бота
YOUR_TOKEN="your_actual_telegram_token"
first_moderator_id="your_moderator_id"
BOT_FILE="bot.py"   # Файл, у якому потрібно замінити змінні
emergency_bot_FILE="emergency_bot.py"
sys_auto_upd=1

# ==================== Non-interactive режим для apt-get ====================
if [ "$sys_auto_upd" = "1" ]; then
  export DEBIAN_FRONTEND=noninteractive
  sudo apt-get update -y > /dev/null 2>&1
  sudo apt-get upgrade -y > /dev/null 2>&1
fi

# ==================== Встановлення Git (якщо не встановлено) ====================
if ! command -v git &> /dev/null; then
    echo "Встановлення Git..."
    sudo apt-get update -y
    sudo apt-get install -y git
fi
# ==================== Встановлення MySQL (якщо не встановлено) ====================
if ! command -v mysql &> /dev/null; then
    echo "Встановлення MySQL Server..."
    sudo apt-get update -y
    sudo apt-get install -y mysql-server
    sudo systemctl enable mysql
fi
if [ ! -d "$REPO_DIR" ]; then

# ==================== Запуск MySQL ====================
echo "Запуск MySQL..."
sudo systemctl start mysql

# ==================== Налаштування MySQL для бота ====================
echo "Налаштовуємо MySQL..."
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS \`${BOT_DB_NAME}\`;"
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE USER IF NOT EXISTS '${BOT_DB_USER}'@'localhost' IDENTIFIED BY '${BOT_DB_PASSWORD}';"
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON \`${BOT_DB_NAME}\`.* TO '${BOT_DB_USER}'@'localhost';"
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"
echo "База даних '${BOT_DB_NAME}' та користувач '${BOT_DB_USER}' налаштовані."
fi


# ==================== Клонування репозиторію ====================
if [ ! -d "$REPO_DIR" ]; then
    echo "Клонування репозиторію..."
    git clone "$REPO_URL"
fi

# ==================== Оновлення репозиторію перед запуском бота ====================
echo "Перевірка оновлень репозиторію перед запуском бота..."
cd "$REPO_DIR"
git fetch --all
git reset --hard origin/$(git rev-parse --abbrev-ref HEAD)

# ==================== Автоматична заміна полів у файлі бота ====================
if [ -f "$BOT_FILE" ]; then
    echo "Оновлення налаштувань у файлі $BOT_FILE..."
    sed -i 's|TOKEN = "TELEGRAM_TOKEN"|TOKEN = "'"$YOUR_TOKEN"'"|' "$BOT_FILE"
    sed -i 's|first_moderator_id = "MODERATOR"|first_moderator_id = "'"$first_moderator_id"'"|' "$BOT_FILE"
    sed -i 's|DB_USER = "USER"|DB_USER = "'"$BOT_DB_USER"'"|' "$BOT_FILE"
    sed -i 's|DB_PASSWORD = "PASSWORD"|DB_PASSWORD = "'"$BOT_DB_PASSWORD"'"|' "$BOT_FILE"
    sed -i 's|DB_NAME = "DB_NAME"|DB_NAME = "'"$BOT_DB_NAME"'"|' "$BOT_FILE"
else
    echo "Файл $BOT_FILE не знайдено. Пропускаємо оновлення налаштувань."
fi
if [ -f "$emergency_bot_FILE" ]; then
    echo "Оновлення налаштувань у файлі $emergency_bot_FILE..."
    sed -i 's|TOKEN = "TELEGRAM_TOKEN"|TOKEN = "'"$YOUR_TOKEN"'"|' "$emergency_bot_FILE"
    sed -i 's|DB_USER = "USER"|DB_USER = "'"$BOT_DB_USER"'"|' "$emergency_bot_FILE"
    sed -i 's|DB_PASSWORD = "PASSWORD"|DB_PASSWORD = "'"$BOT_DB_PASSWORD"'"|' "$emergency_bot_FILE"
    sed -i 's|DB_NAME = "DB_NAME"|DB_NAME = "'"$BOT_DB_NAME"'"|' "$emergency_bot_FILE"
else
    echo "Файл $emergency_bot_FILE не знайдено. Пропускаємо оновлення налаштувань."
fi


# ==================== Встановлення Python3 та venv (якщо не встановлено) ====================
if ! command -v python3 &> /dev/null; then
    echo "Встановлення Python3..."
    sudo apt-get update -y
    sudo apt-get install -y python3.12
fi
apt-get install python3-venv  -y > /dev/null 2>&1

# ==================== Створення та активація віртуального середовища ====================
if [ ! -d "venv" ]; then
    echo "Створення віртуального середовища..."
    python3 -m venv venv
fi

source venv/bin/activate

# ==================== Встановлення залежностей Python ====================
if [ -f "requirements.txt" ]; then
    echo "Встановлення Python-залежностей..."
    pip install --upgrade pip
    pip install -r requirements.txt
else
    echo "Файл requirements.txt не знайдено. Пропускаємо встановлення залежностей."
fi

# ==================== Запуск бота ====================
echo "Запуск бота..."
while true; do
    # Спроба запустити основний бот
    if ! python3 bot.py; then
        echo "Помилка виконання Python-скрипта!" >&2
        python3 emergency_bot.py
    fi
    # Затримка 120 секунд перед наступною спробою
    sleep 120
done
