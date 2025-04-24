@echo off
setlocal EnableDelayedExpansion
set VM_NAME=pfsense
set PFSENSE_IP=192.168.1.2
set SHOWN_ONLINE_MSG=0

:: Ask user with timeout
echo Do you want to start Watchdog for pfSense? [Y/n] (auto-continue in 10s):
choice /c YN /n /t 10 /d Y >nul

if errorlevel 2 (
    cls
    echo Exiting...
    echo.
    timeout /t 5
    exit
)

echo Starting watchdog...

:: Show ping output to screen once
echo.
echo Testing connection to pfSense at %PFSENSE_IP% ...
echo.
ping -n 3 %PFSENSE_IP%
echo.

cls

:loop
ping -n 3 %PFSENSE_IP% >nul
if errorlevel 1 (
    echo pfSense not responding. Starting VM...

    "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "%VM_NAME%" poweroff
    
     timeout /t 5 >nul

    "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" startvm "%VM_NAME%" --type gui

    call :countdown 240 "Waiting for pfSense to finish booting"

    set SHOWN_ONLINE_MSG=0
) else (
    if !SHOWN_ONLINE_MSG! == 0 (
        echo.
        echo   WatchDog
        echo   ========
        echo   pfSense is online...
        echo.
        echo   "  / \__"
        echo   " (    @\___"
        echo   " /         O"
        echo   "/   (_____ /"
        echo   "/_____/   U"
        echo      ppk
	echo.
        set SHOWN_ONLINE_MSG=1
    )
)

timeout /t 10 >nul
goto loop

::-------------------------
:: Countdown Subroutine
::-------------------------
:countdown
set /a seconds=%1
set "message=%~2"

:countloop
cls
<nul set /p="%message%... !seconds! seconds remaining"
ping -n 2 127.0.0.1 >nul
set /a seconds-=1
if !seconds! GTR 0 goto countloop
cls
exit /b
