#!/bin/bash
WORK="$HOME/pm07"
LOG_FILE="$WORK/logs/app.log"
DB_NAME="pm07_v03"

log() {
    local level="$1"
    local msg="$2"
    echo "$(date '+%Y-%m-%d %H:%M:%S') [$level] $msg" >> "$LOG_FILE"
}

db_query() {
    mysql --defaults-extra-file=$WORK/.my.cnf -u readonly -D "$DB_NAME" -N -B -e "$1" 2>> "$LOG_FILE"
    return $?
}

run_task() {
    file="$WORK/out/daily_stats.txt"
    db_query "SELECT 'patients',COUNT(*) FROM patients UNION ALL SELECT 
    'doctors',COUNT(*) FROM doctors UNION ALL SELECT 
    'appointments',COUNT(*) FROM appointments;" > "$file"

    if [ $? -ne 0 ]; then
        return 1
    fi

    log INFO "report=$file"
}

log INFO "=== Старт скрипта ==="
run_task
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    log INFO "Успешно завершено"
else
    log ERROR "Ошибка выполнения, код: $EXIT_CODE"
fi

exit $EXIT_CODE
