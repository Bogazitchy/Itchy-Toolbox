@echo off
:: ============================================================
::  ITCHY TOOLBOX - Windows Sistem Yonetim Araci
::  Saf CMD/Batch ile yazilmistir. Python gerektirmez.
:: ============================================================
setlocal EnableDelayedExpansion
chcp 65001 >nul
title Itchy Toolbox
mode con cols=120 lines=45

:: ANSI renk destegi (Win10+)
for /f %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "RST=%ESC%[0m"
set "BLD=%ESC%[1m"
set "DIM=%ESC%[2m"
set "RED=%ESC%[91m"
set "GRN=%ESC%[92m"
set "YLW=%ESC%[93m"
set "MAG=%ESC%[95m"
set "CYN=%ESC%[96m"
set "GRY=%ESC%[90m"

:: Sistem bilgisi
set "MY_IP=Bilinmiyor"
for /f "tokens=2 delims=:" %%i in ('ipconfig 2^>nul ^| findstr /i "IPv4" 2^>nul') do (
    if "!MY_IP!"=="Bilinmiyor" set "MY_IP=%%i"
)
for /f "tokens=* delims= " %%i in ("!MY_IP!") do set "MY_IP=%%i"
set "MY_PC=%COMPUTERNAME%"

call :SPLASH

:: ============================================================
:: ANA MENU
:: ============================================================
:MAIN_MENU
cls
call :BANNER
echo.
echo   %YLW%%BLD%-- Ana Menu%RST%
echo   %GRY%-----------------------------------------------------------------------%RST%
echo.

net session >nul 2>&1
if !errorlevel! == 0 (
    echo   Durum: %GRN%[+] Yonetici%RST%
) else (
    echo   Durum: %YLW%[~] Standart kullanici ^(bazi islemler calismaz^)%RST%
)
echo.

echo   %CYN%[1]%RST% Uygulama Yukleyici
echo   %CYN%[2]%RST% Standart Program Kurulumu
echo   %CYN%[3]%RST% Hizmet Yonetimi
echo   %CYN%[4]%RST% Ozellik Yonetimi
echo   %CYN%[5]%RST% PC Zaman Ayarli Kapat
echo   %CYN%[6]%RST% Ping Olcer / DNS Degistirici
echo   %CYN%[7]%RST% Lisans Yonetimi
echo   %CYN%[8]%RST% Sistem Hakkinda
echo   %CYN%[9]%RST% Kayitli WiFi Bilgileri
echo.
echo   %GRY%-----------------------------------------------------------------------%RST%
echo   %DIM%[sayi] sec   [q] cikis%RST%
echo.

set "choice="
set /p "choice=  %GRN%Secim: %RST%" || goto :EXIT

if /i "!choice!"=="q" goto :EXIT
if "!choice!"=="1" goto :APP_INSTALLER
if "!choice!"=="2" goto :STANDARD_INSTALLER
if "!choice!"=="3" goto :NOT_IMPL_SVC
if "!choice!"=="4" goto :NOT_IMPL_FEAT
if "!choice!"=="5" goto :NOT_IMPL_SHUT
if "!choice!"=="6" goto :NOT_IMPL_PING
if "!choice!"=="7" goto :NOT_IMPL_LIC
if "!choice!"=="8" goto :NOT_IMPL_SYS
if "!choice!"=="9" goto :NOT_IMPL_WIFI
goto :MAIN_MENU


:: ============================================================
:: UYGULAMA YUKLEYICI
:: ============================================================
:APP_INSTALLER
cls
call :BANNER
echo.
echo   %GRY%Ana Menu -- Uygulama Yukleyici%RST%
echo   %YLW%%BLD%-- Uygulama Yukleyici%RST%
echo   %GRY%-----------------------------------------------------------------------%RST%
echo.

where winget >nul 2>&1
if !errorlevel! neq 0 (
    echo   %RED%[*] winget bulunamadi^^!%RST%
    echo   %DIM%Microsoft Store'dan "App Installer" kurmaniz gerekiyor.%RST%
    echo.
)

call :LOAD_APPS

echo   %DIM%Kategoriler yan yana duzende listelenir. * ozel kurulumdur.%RST%
echo.
call :PRINT_APP_CATEGORIES
echo.
echo   %GRY%-----------------------------------------------------------------------%RST%
echo   %DIM%Coklu secim: 1,15,16   [a] tumu   [x] geri   [q] cikis%RST%
echo.

set "choice="
set /p "choice=  %GRN%Secim: %RST%" || goto :EXIT

if /i "!choice!"=="q" goto :EXIT
if /i "!choice!"=="x" goto :MAIN_MENU
if /i "!choice!"=="" goto :APP_INSTALLER
if /i "!choice!"=="a" (
    call :INSTALL_ALL
    goto :APP_INSTALLER
)

call :INSTALL_SELECTION "!choice!"
goto :APP_INSTALLER


:LOAD_APPS
set "APP[1]=Discord.Discord|Discord"
set "APP[2]=WhatsApp.WhatsApp|WhatsApp"
set "APP[3]=Telegram.TelegramDesktop|Telegram"
set "APP[4]=Zoom.Zoom|Zoom"
set "APP[5]=EpicGames.EpicGamesLauncher|Epic Games"
set "APP[6]=Valve.Steam|Steam"
set "APP[7]=Ubisoft.Connect|Ubisoft Connect"
set "APP[8]=ElectronicArts.EADesktop|EA App"
set "APP[9]=Google.Chrome|Google Chrome"
set "APP[10]=Microsoft.Edge|Microsoft Edge"
set "APP[11]=Opera.Opera|Opera"
set "APP[12]=Opera.OperaGX|Opera GX"
set "APP[13]=Mozilla.Firefox|Mozilla Firefox"
set "APP[14]=Brave.Brave|Brave"
set "APP[15]=TorProject.TorBrowser|Tor Browser"
set "APP[16]=Zen-Team.Zen-Browser|Zen Browser"
set "APP[17]=Bytedance.CapCut|CapCut"
set "APP[18]=GIMP.GIMP|GIMP"
set "APP[19]=OBSProject.OBSStudio|OBS Studio"
set "APP[20]=Skillbrains.Lightshot|Lightshot"
set "APP[21]=HandBrake.HandBrake|HandBrake"
set "APP[22]=CodecGuide.K-LiteCodecPack.Standard|K-Lite Codec Pack"
set "APP[23]=VideoLAN.VLC|VLC Media Player"
set "APP[24]=Daum.PotPlayer|PotPlayer"
set "APP[25]=Spotify.Spotify|Spotify"
set "APP[26]=qBittorrent.qBittorrent|qBittorrent"
set "APP[27]=Tonec.InternetDownloadManager|Internet Download Manager"
set "APP[28]=Adobe.Acrobat.Reader.64-bit|Adobe Acrobat Reader"
set "APP[29]=TrackerSoftware.PDFXChangeEditor|PDF-XChange Editor"
set "APP[30]=TheDocumentFoundation.LibreOffice|LibreOffice"
set "APP[31]=Notepad++.Notepad++|Notepad++"
set "APP[32]=Microsoft.VisualStudioCode|Visual Studio Code"
set "APP[33]=GitHub.GitHubDesktop|GitHub Desktop"
set "APP[34]=Git.Git|Git"
set "APP[35]=OpenJS.NodeJS|Node.js"
set "APP[36]=Unity.UnityHub|Unity Hub"
set "APP[37]=IObit.IObitUnlocker|IObit Unlocker"
set "APP[38]=RevoUninstaller.RevoUninstaller|Revo Uninstaller"
set "APP[39]=7zip.7zip|7-Zip"
set "APP[40]=AnyDeskSoftwareGmbH.AnyDesk|AnyDesk"
set "APP[41]=LogMeIn.Hamachi|Hamachi"
set "APP[42]=GlassWire.GlassWire|GlassWire"
set "APP[43]=Stremio.Stremio|Stremio"
set "APP[44]=PuTTY.PuTTY|PuTTY"
set "APP[45]=RARLab.WinRAR|WinRAR"
set "APP[46]=CUSTOM_ALPEMIX|Alpemix"
set "APP[47]=CUSTOM|Itchy YouTube Downloader"
set "APP[48]=CUSTOM|Itchy Backup"
set "APP_COUNT=48"
exit /b


:PRINT_APP_CATEGORIES
call :PRINT_CATEGORY "Mesajlasma" 1 4
call :PRINT_CATEGORY "Oyun Kutuphanesi" 5 8
call :PRINT_CATEGORY "Tarayici" 9 16
call :PRINT_CATEGORY "Multimedya" 17 21
call :PRINT_CATEGORY "Video-Ses Oynatici" 22 25
call :PRINT_CATEGORY "Indirme Araclari" 26 27
call :PRINT_CATEGORY "Belgeler" 28 30
call :PRINT_CATEGORY "Gelistirme" 31 36
call :PRINT_CATEGORY "Temizlik" 37 38
call :PRINT_CATEGORY "Diger" 39 46
call :PRINT_CATEGORY "Itchy Programlari" 47 48
exit /b


:PRINT_CATEGORY
set "cat_label=-- %~1                      "
set "cat_label=!cat_label:~0,22!"
set "cat_start=%~2"
set "cat_end=%~3"
set "col_count=3"
set "first_row=1"
for /l %%s in (!cat_start!,!col_count!,!cat_end!) do (
    if "!first_row!"=="1" (
        set "line=  %MAG%!cat_label!%RST%"
        set "first_row=0"
    ) else (
        set "line=  %MAG%                      %RST%"
    )
    for /l %%o in (0,1,2) do (
        set /a "idx=%%s+%%o"
        if !idx! leq !cat_end! (
            call :MAKE_APP_CELL !idx! cell
            set "line=!line!!cell!"
        )
    )
    echo(!line!
)
exit /b


:MAKE_APP_CELL
set "idx=%~1"
set "outvar=%~2"
set "pkg="
set "name="
for /f "tokens=1,2 delims=|" %%a in ("!APP[%idx%]!") do (
    set "pkg=%%a"
    set "name=%%b"
)
if !idx! lss 10 (
    set "num=0!idx!"
) else (
    set "num=!idx!"
)
set "mark= "
if "!pkg!"=="CUSTOM" set "mark=*"
if "!pkg!"=="CUSTOM_ALPEMIX" set "mark=*"
set "cell=[!num!] !name!!mark!                                    "
set "cell=!cell:~0,31!"
set "%outvar%=!cell!"
exit /b


:: ============================================================
:: STANDART PROGRAM KURULUMU
:: ============================================================
:STANDARD_INSTALLER
cls
call :BANNER
echo.
echo   %GRY%Ana Menu -- Standart Program Kurulumu%RST%
echo   %YLW%%BLD%-- Standart Program Kurulumu%RST%
echo   %GRY%-----------------------------------------------------------------------%RST%
echo.

call :LOAD_APPS
echo   %MAG%Kurulacak programlar%RST%
echo.
call :MAKE_APP_CELL 28 cell1
call :MAKE_APP_CELL 9 cell2
call :MAKE_APP_CELL 40 cell3
echo   !cell1!!cell2!!cell3!
call :MAKE_APP_CELL 24 cell1
call :MAKE_APP_CELL 45 cell2
call :MAKE_APP_CELL 46 cell3
echo   !cell1!!cell2!!cell3!
echo.
echo   %DIM%Bu secenek Adobe Reader, Chrome, AnyDesk, PotPlayer, WinRAR ve Alpemix kurar.%RST%
echo   %DIM%[k] kuruluma basla   [x] geri   [q] cikis%RST%
echo.

set "choice="
set /p "choice=  %GRN%Secim: %RST%" || goto :EXIT

if /i "!choice!"=="q" goto :EXIT
if /i "!choice!"=="x" goto :MAIN_MENU
if /i "!choice!"=="k" (
    call :INSTALL_STANDARD_SET
    goto :STANDARD_INSTALLER
)
goto :STANDARD_INSTALLER


:INSTALL_STANDARD_SET
echo.
echo   %YLW%-- Standart programlar kuruluyor...%RST%
echo.
set "ok_count=0"
set "fail_count=0"
for %%i in (28 9 40 24 45 46) do (
    call :INSTALL_ONE %%i
)
echo.
echo   %GRY%-----------------------------------------------------------------------%RST%
echo   %GRN%[+] Basarili: !ok_count!%RST%   %RED%[-] Basarisiz: !fail_count!%RST%
echo.
pause
exit /b


:INSTALL_SELECTION
set "raw=%~1"
set "raw=!raw:,= !"
echo.
echo   %YLW%-- Secili uygulamalar kuruluyor...%RST%
echo.
set "ok_count=0"
set "fail_count=0"
for %%n in (!raw!) do (
    set "num=%%n"
    call :INSTALL_ONE !num!
)
echo.
echo   %GRY%-----------------------------------------------------------------------%RST%
echo   %GRN%[+] Basarili: !ok_count!%RST%   %RED%[-] Basarisiz: !fail_count!%RST%
echo.
pause
exit /b


:INSTALL_ONE
set "idx=%~1"
if "!idx!"=="" exit /b
for /f "delims=0123456789" %%a in ("!idx!") do (
    echo   %RED%[-] Gecersiz numara: !idx!%RST%
    set /a fail_count+=1
    exit /b
)
if !idx! lss 1 (
    echo   %RED%[-] Gecersiz numara: !idx!%RST%
    set /a fail_count+=1
    exit /b
)
if !idx! gtr %APP_COUNT% (
    echo   %RED%[-] Gecersiz numara: !idx!%RST%
    set /a fail_count+=1
    exit /b
)

for /f "tokens=1,2 delims=|" %%a in ("!APP[%idx%]!") do (
    set "pkg=%%a"
    set "name=%%b"
)

echo   %CYN%-- [!idx!] !name!%RST%

if "!pkg!"=="CUSTOM_ALPEMIX" (
    call :INSTALL_ALPEMIX
    exit /b
)

if "!pkg!"=="CUSTOM" (
    echo     %YLW%[~] Ozel kurulum henuz tanimlanmamis, atlandi.%RST%
    set /a fail_count+=1
    exit /b
)

winget install --id "!pkg!" -e --source winget --accept-source-agreements --accept-package-agreements --silent
if !errorlevel! == 0 (
    echo     %GRN%[+] Kuruldu%RST%
    set /a ok_count+=1
) else (
    echo     %RED%[-] Basarisiz%RST%
    set /a fail_count+=1
)
exit /b


:INSTALL_ALPEMIX
set "alpemix_target=%TEMP%\Alpemix.exe"
echo     %YLW%[~] Resmi Alpemix sitesinden indiriliyor...%RST%
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Invoke-WebRequest -Uri 'https://www.alpemix.com/site/Alpemix.exe' -OutFile $env:TEMP\Alpemix.exe -UseBasicParsing; exit 0 } catch { exit 1 }"
if !errorlevel! neq 0 (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Invoke-WebRequest -Uri 'https://www.alpemix.com/tr/alpemix-indir-Windows' -OutFile $env:TEMP\Alpemix.html -UseBasicParsing; exit 0 } catch { exit 1 }"
    echo     %RED%[-] Alpemix otomatik indirilemedi. Resmi indirme sayfasi: https://www.alpemix.com/tr/alpemix-indir-Windows%RST%
    set /a fail_count+=1
    exit /b
)
start "" "!alpemix_target!"
echo     %GRN%[+] Alpemix indirildi ve baslatildi%RST%
set /a ok_count+=1
exit /b


:INSTALL_ALL
echo.
echo   %YLW%-- TUM uygulamalar kuruluyor...%RST%
echo.
set "ok_count=0"
set "fail_count=0"
for /l %%i in (1,1,%APP_COUNT%) do (
    call :INSTALL_ONE %%i
)
echo.
echo   %GRY%-----------------------------------------------------------------------%RST%
echo   %GRN%[+] Basarili: !ok_count!%RST%   %RED%[-] Basarisiz: !fail_count!%RST%
echo.
pause
exit /b


:: ============================================================
:: PLACEHOLDER MODULLER
:: ============================================================
:NOT_IMPL_SVC
call :NOT_IMPL "Hizmet Yonetimi"
goto :MAIN_MENU

:NOT_IMPL_FEAT
call :NOT_IMPL "Ozellik Yonetimi"
goto :MAIN_MENU

:NOT_IMPL_SHUT
call :NOT_IMPL "PC Zaman Ayarli Kapat"
goto :MAIN_MENU

:NOT_IMPL_PING
call :NOT_IMPL "Ping Olcer / DNS Degistirici"
goto :MAIN_MENU

:NOT_IMPL_LIC
call :NOT_IMPL "Lisans Yonetimi"
goto :MAIN_MENU

:NOT_IMPL_SYS
call :NOT_IMPL "Sistem Hakkinda"
goto :MAIN_MENU

:NOT_IMPL_WIFI
call :NOT_IMPL "Kayitli WiFi Bilgileri"
goto :MAIN_MENU

:NOT_IMPL
cls
call :BANNER
echo.
echo   %YLW%%BLD%-- %~1%RST%
echo   %GRY%-----------------------------------------------------------------------%RST%
echo.
echo   %YLW%[~] Bu modul henuz gelistirme asamasinda.%RST%
echo   %DIM%Bir sonraki guncellemede eklenecek.%RST%
echo.
pause
exit /b


:: ============================================================
:: SPLASH - Acilis Ekrani
:: ============================================================
:SPLASH
cls
echo.
echo.
echo   %MAG%%BLD%===============================================================%RST%
echo   %MAG%%BLD%                         ITCHY TOOLBOX                         %RST%
echo   %MAG%%BLD%===============================================================%RST%
echo.
echo   %GRY%                   Windows Sistem Yonetim Araci v0.1%RST%
echo   %GRY%                   Gelistirici: Itchy%RST%
echo.
echo   %DIM%  Yukluyor...%RST%
ping -n 3 127.0.0.1 >nul
exit /b


:: ============================================================
:: BANNER
:: ============================================================
:BANNER
echo.
echo   %MAG%%BLD%+---------------------------------------------------------------+%RST%
echo   %MAG%%BLD%                          ITCHY TOOLBOX                         %RST%
echo   %MAG%%BLD%+---------------------------------------------------------------+%RST%
echo   %GRY%  PC: %YLW%!MY_PC!   %GRY%^|   IP: %YLW%!MY_IP!   %GRY%^|   v0.1%RST%
echo   %GRY%-----------------------------------------------------------------------%RST%
exit /b


:: ============================================================
:: CIKIS
:: ============================================================
:EXIT
cls
echo.
echo   %MAG%%BLD%Gorusuruz^^!%RST%
echo   %CYN%Itchy Toolbox'i kullandiginiz icin tesekkurler.%RST%
echo.
ping -n 3 127.0.0.1 >nul
exit /b 0
