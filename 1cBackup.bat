@echo off
setlocal EnableDelayedExpansion

REM -------------------------
REM Настройки
REM -------------------------
set "BASE_DIR=X:\1c_bases"
set "BACKUP_ROOT=\\192.168.18.7\backup$"
set "ZIP=C:\Program Files\7-Zip\7z.exe"
set "LOG_DIR=C:\backup_bat\log"
set "EXCLUDE_FILE=C:\backup_bat\exclude.lst"

REM -------------------------
REM Дата и время
REM -------------------------
for /f %%i in ('wmic os get LocalDateTime ^| find "."') do set dt=%%i
set "YYYY=!dt:~0,4!"
set "MM=!dt:~4,2!"
set "DD=!dt:~6,2!"
set "HH=!dt:~8,2!"
set "MIN=!dt:~10,2!"

set "YEAR_MONTH=!YYYY!-!MM!"
set "DATE_TIME=!YYYY:~2,2!-!MM!-!DD!_!HH!-!MIN!"

set "DEST_DIR=%BACKUP_ROOT%\!YEAR_MONTH!"
set "LOG_FILE=%LOG_DIR%\!DATE_TIME!_backup1c7.txt"

REM -------------------------
REM Создание папок
REM -------------------------
if not exist "!DEST_DIR!" mkdir "!DEST_DIR!"
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"

echo =============================================== >> "!LOG_FILE!"
echo Запуск: %DATE% %TIME% >> "!LOG_FILE!"
echo =============================================== >> "!LOG_FILE!"
echo. >> "!LOG_FILE!"

echo === Начало резервного копирования ===

REM -------------------------
REM Перебор баз
REM -------------------------
for /d %%B in ("%BASE_DIR%\*") do (

    set "BASENAME=%%~nB"
    set "SAFE_NAME=!BASENAME: =_!"
    set "ARCHIVE=!DEST_DIR!\!SAFE_NAME!_!DATE_TIME!.7z"

    echo Архивация: !BASENAME!
    echo Архивация: !BASENAME! >> "!LOG_FILE!"

    "%ZIP%" a -t7z "!ARCHIVE!" "%%~fB\*" ^
    -mx=9 ^
    -xr@"%EXCLUDE_FILE%" >> "!LOG_FILE!" 2>&1

    if !ERRORLEVEL! EQU 0 (
        echo УСПЕШНО >> "!LOG_FILE!"
    ) else (
        echo ОШИБКА >> "!LOG_FILE!"
    )

    echo. >> "!LOG_FILE!"
)

echo =============================================== >> "!LOG_FILE!"
echo Завершено: %DATE% %TIME% >> "!LOG_FILE!"
echo =============================================== >> "!LOG_FILE!"

echo === Завершено ===

endlocal