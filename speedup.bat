@echo off
:: Batch script untuk melakukan ping ke beberapa IP dengan fallback

:: Cek administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Meminta hak administrator...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Set variabel IP
set IP1=192.168.x.x ::House
set IP2=192.168.x.x ::Sekolah wifi = wifirplB@ruijie
set IP3=192.168.x.x :: Sekolah wifi = RPL

:: Coba setiap IP dengan urutan prioritas
call :test_ip %IP1% && goto success
call :test_ip %IP2% && goto success
call :test_ip %IP3% && goto success

:: Jika semua gagal
echo Semua IP gagal diping.
pause
exit /b

:test_ip
echo Memeriksa IP: %1

:: Coba ping 1000 byte dulu
ping -n 1 -l 1000 %1 | find "Reply from %1" >nul
if %errorlevel% equ 0 (
    echo [SUKSES] IP %1 berhasil ping dengan 1000 byte
    ping -l 1000 %1 -t
    exit /b 0
)

:: Coba ping default
ping -n 1 %1 | find "Reply from %1" >nul
if %errorlevel% equ 0 (
    echo [SUKSES] IP %1 berhasil ping default
    ping %1 -t
    exit /b 0
)

echo [GAGAL] IP %1 tidak merespon
exit /b 1

:success
exit /b 0
