#!/bin/bash
# Скрипт сверки баз(индивидуально)

echo "Проверка восстановления базы"
echo "Сверка before_restore.txt и after_restore.txt"

diff ~/pm07/backup/before_restore.txt ~/pm07/backup/after_restore.txt > /dev/null

if [ $? -eq 0 ]; then
    echo "[УСПЕХ] Данные в исходной и восстановленной базах полностью идентичны"
else
    echo "[ОШИБКА] Данные НЕ СОВПАДАЮТ"
    exit 1
fi
