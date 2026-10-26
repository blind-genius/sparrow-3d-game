@echo off
chcp 65001 > nul
echo ========================================================
echo   اتصال و ارسال بازی پرواز گنجشک سه بعدی به گیت‌هاب
echo ========================================================
echo.
set /p REPO_URL="لطفاً آدرس مخزن گیت‌هاب خود را وارد کنید (مثال: https://github.com/username/sparrow-game.git): "

if "%REPO_URL%"=="" (
    echo آدرسی وارد نشد! عملیات لغو شد.
    pause
    exit /b
)

echo.
echo در حال تنظیم آدرس مخزن و شاخه master...
git remote remove origin 2>nul
git remote add origin %REPO_URL%
git branch -M master

echo در حال ارسال کدها به گیت‌هاب...
git push -u origin master

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================================
    echo   ارسال با موفقیت انجام شد!
    echo   اکنون سرورهای ابری گیت‌هاب در حال کامپایل خودکار فایل APK هستند.
    echo   برای دانلود فایل APK، به تب Actions در صفحه مخزن گیت‌هاب بروید.
    echo ========================================================
) else (
    echo.
    echo خطایی در ارسال به گیت‌هاب رخ داد. لطفاً دسترسی اینترنت و احراز هویت گیت‌هاب را بررسی کنید.
)

pause
