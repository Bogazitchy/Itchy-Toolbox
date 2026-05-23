@echo off
:: ============================================================
::  ITCHY TOOLBOX - Windows Sistem Yonetim Araci
::  Saf CMD/Batch ile yazilmistir. Python gerektirmez.
:: ============================================================
setlocal EnableDelayedExpansion
chcp 65001 >nul
title I T C H Y   T O O L B O X
set "VERSION=0.3"
set "TOOLBOX_FILE=%~f0"
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
mode con cols=120 lines=45
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
echo   %CYN%[2]%RST% Hizmet Yonetimi
echo   %CYN%[3]%RST% Ozellik Yonetimi
echo   %CYN%[4]%RST% PC Zaman Ayarli Kapat
echo   %CYN%[5]%RST% Ping Olcer / DNS Degistirici
echo   %CYN%[6]%RST% Lisans Yonetimi
echo   %CYN%[7]%RST% Sistem Hakkinda
echo   %CYN%[8]%RST% Kayitli WiFi Bilgileri
echo   %CYN%[9]%RST% Kurulum Profilleri
echo   %CYN%[10]%RST% Windows Onarim
echo   %CYN%[11]%RST% Yedekleme / Geri Yukleme
echo   %CYN%[12]%RST% Sistem Araclari
echo   %CYN%[13]%RST% Ag Onarim / Rapor
echo   %CYN%[14]%RST% Yonetici Olarak Yeniden Baslat
echo.
echo   %GRY%-----------------------------------------------------------------------%RST%
echo   %DIM%[sayi] sec   [q] cikis%RST%
echo.

set "choice="
set /p "choice=  %GRN%Secim: %RST%" || goto :EXIT

if /i "!choice!"=="q" goto :EXIT
if "!choice!"=="1" goto :APP_INSTALLER
if "!choice!"=="2" goto :SERVICE_MENU
if "!choice!"=="3" goto :FEATURE_MENU
if "!choice!"=="4" goto :SHUTDOWN_TIMER
if "!choice!"=="5" goto :PING_DNS_MENU
if "!choice!"=="6" goto :LICENSE_MENU
if "!choice!"=="7" goto :SYSTEM_INFO
if "!choice!"=="8" goto :WIFI_INFO
if "!choice!"=="9" goto :STANDARD_INSTALLER
if "!choice!"=="10" goto :WINDOWS_REPAIR
if "!choice!"=="11" goto :BACKUP_RECOVERY_MENU
if "!choice!"=="12" goto :SYSTEM_TOOLS_MENU
if "!choice!"=="13" goto :NETWORK_REPORT_MENU
if "!choice!"=="14" call :RELAUNCH_ADMIN
goto :MAIN_MENU


:: ============================================================
:: UYGULAMA YUKLEYICI
:: ============================================================
:APP_INSTALLER
mode con cols=120 lines=64
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
set "APP[2]=MSSTORE:9NKSQGP7F2NH|WhatsApp"
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
set "APP[17]=REALiX.HWiNFO|HWiNFO"
set "APP[18]=CPUID.HWMonitor|HWMonitor"
set "APP[19]=CPUID.CPU-Z|CPU-Z"
set "APP[20]=TechPowerUp.GPU-Z|GPU-Z"
set "APP[21]=Geeks3D.FurMark.2|FurMark"
set "APP[22]=NirSoft.BatteryInfoView|BatteryInfo"
set "APP[23]=CUSTOM_CRYSTALDISKINFO|CrystalDiskInfo"
set "APP[24]=CrystalDewWorld.CrystalDiskMark|CrystalDiskMark"
set "APP[25]=AntibodySoftware.WizTree|WizTree"
set "APP[26]=voidtools.Everything|Everything"
set "APP[27]=Rufus.Rufus|Rufus"
set "APP[28]=Ventoy.Ventoy|Ventoy"
set "APP[29]=Bytedance.CapCut|CapCut"
set "APP[30]=GIMP.GIMP|GIMP"
set "APP[31]=OBSProject.OBSStudio|OBS Studio"
set "APP[32]=Skillbrains.Lightshot|Lightshot"
set "APP[33]=HandBrake.HandBrake|HandBrake"
set "APP[34]=CodecGuide.K-LiteCodecPack.Standard|K-Lite Codec Pack"
set "APP[35]=VideoLAN.VLC|VLC Media Player"
set "APP[36]=Daum.PotPlayer|PotPlayer"
set "APP[37]=CUSTOM_SPOTIFY|Spotify"
set "APP[38]=qBittorrent.qBittorrent|qBittorrent"
set "APP[39]=Tonec.InternetDownloadManager|Internet Download Manager"
set "APP[40]=Adobe.Acrobat.Reader.64-bit|Adobe Acrobat Reader"
set "APP[41]=TrackerSoftware.PDF-XChangeEditor|PDF-XChange Editor"
set "APP[42]=TheDocumentFoundation.LibreOffice|LibreOffice"
set "APP[43]=FastCopy.FastCopy|FastCopy"
set "APP[44]=Piriform.Recuva|Recuva"
set "APP[45]=CUSTOM_DMDE|DMDE"
set "APP[46]=AnyDesk.AnyDesk|AnyDesk"
set "APP[47]=CUSTOM_ALPEMIX|Alpemix"
set "APP[48]=CUSTOM_RUSTDESK|RustDesk"
set "APP[49]=CUSTOM_MALWAREBYTES|Malwarebytes"
set "APP[50]=Malwarebytes.AdwCleaner|AdwCleaner"
set "APP[51]=Notepad++.Notepad++|Notepad++"
set "APP[52]=Microsoft.VisualStudioCode|Visual Studio Code"
set "APP[53]=GitHub.GitHubDesktop|GitHub Desktop"
set "APP[54]=Git.Git|Git"
set "APP[55]=OpenJS.NodeJS|Node.js"
set "APP[56]=Unity.UnityHub|Unity Hub"
set "APP[57]=Microsoft.VCRedist.2015+.x64|VC++ 2015-2022 x64"
set "APP[58]=Microsoft.VCRedist.2015+.x86|VC++ 2015-2022 x86"
set "APP[59]=Microsoft.DotNet.DesktopRuntime.8|.NET Desktop Runtime 8"
set "APP[60]=Microsoft.DirectX|DirectX Runtime"
set "APP[61]=CUSTOM_IOBIT_UNLOCKER|IObit Unlocker"
set "APP[62]=RevoUninstaller.RevoUninstaller|Revo Uninstaller"
set "APP[63]=Microsoft.Sysinternals.Suite|Sysinternals Suite"
set "APP[64]=7zip.7zip|7-Zip"
set "APP[65]=LogMeIn.Hamachi|Hamachi"
set "APP[66]=GlassWire.GlassWire|GlassWire"
set "APP[67]=Stremio.Stremio|Stremio"
set "APP[68]=PuTTY.PuTTY|PuTTY"
set "APP[69]=RARLab.WinRAR|WinRAR"
set "APP[70]=CUSTOM|Itchy YouTube Downloader"
set "APP[71]=CUSTOM|Itchy Backup"
set "APP[72]=RevoUninstaller.RevoUninstaller|Revo"
set "APP[73]=Wagnardsoft.DisplayDriverUninstaller|DDU"
set "APP[74]=CUSTOM_JAVA_UNINSTALLER|Java Uninstaller"
set "APP_COUNT=74"
exit /b


:PRINT_APP_CATEGORIES
call :LOAD_APP_GRID
echo   %GRY%┌───────────────────────────────────┬───────────────────────────────────┬───────────────────────────────────┐%RST%
for /l %%r in (1,1,!APP_GRID_ROWS!) do (
    call :MAKE_APP_GRID_CELL 1 %%r app_cell_1
    call :MAKE_APP_GRID_CELL 2 %%r app_cell_2
    call :MAKE_APP_GRID_CELL 3 %%r app_cell_3
    echo   %GRY%│%RST%!app_cell_1!%GRY%│%RST%!app_cell_2!%GRY%│%RST%!app_cell_3!%GRY%│%RST%
)
echo   %GRY%└───────────────────────────────────┴───────────────────────────────────┴───────────────────────────────────┘%RST%
exit /b


:LOAD_APP_GRID
set "APP_GRID_ROWS=34"
for %%c in (1 2 3) do for /l %%r in (1,1,!APP_GRID_ROWS!) do set "APP_GRID[%%c,%%r]="
set "APP_GRID[1,1]=CAT|Mesajlasma"
set "APP_GRID[1,2]=APP|1"
set "APP_GRID[1,3]=APP|2"
set "APP_GRID[1,4]=APP|3"
set "APP_GRID[1,5]=APP|4"
set "APP_GRID[1,6]=CAT|Oyun Kutuphanesi"
set "APP_GRID[1,7]=APP|5"
set "APP_GRID[1,8]=APP|6"
set "APP_GRID[1,9]=APP|7"
set "APP_GRID[1,10]=APP|8"
set "APP_GRID[1,11]=CAT|Tarayici"
set "APP_GRID[1,12]=APP|9"
set "APP_GRID[1,13]=APP|10"
set "APP_GRID[1,14]=APP|11"
set "APP_GRID[1,15]=APP|12"
set "APP_GRID[1,16]=APP|13"
set "APP_GRID[1,17]=APP|14"
set "APP_GRID[1,18]=APP|15"
set "APP_GRID[1,19]=APP|16"
set "APP_GRID[1,20]=CAT|Donanim"
set "APP_GRID[1,21]=APP|17"
set "APP_GRID[1,22]=APP|18"
set "APP_GRID[1,23]=APP|19"
set "APP_GRID[1,24]=APP|20"
set "APP_GRID[1,25]=APP|21"
set "APP_GRID[1,26]=APP|22"
set "APP_GRID[1,27]=CAT|Disk-Depolama"
set "APP_GRID[1,28]=APP|23"
set "APP_GRID[1,29]=APP|24"
set "APP_GRID[1,30]=APP|25"
set "APP_GRID[1,31]=APP|26"
set "APP_GRID[1,32]=CAT|USB-ISO"
set "APP_GRID[1,33]=APP|27"
set "APP_GRID[1,34]=APP|28"
set "APP_GRID[2,1]=CAT|Multimedya"
set "APP_GRID[2,2]=APP|29"
set "APP_GRID[2,3]=APP|30"
set "APP_GRID[2,4]=APP|31"
set "APP_GRID[2,5]=APP|32"
set "APP_GRID[2,6]=APP|33"
set "APP_GRID[2,7]=CAT|Video-Ses Oynatici"
set "APP_GRID[2,8]=APP|34"
set "APP_GRID[2,9]=APP|35"
set "APP_GRID[2,10]=APP|36"
set "APP_GRID[2,11]=APP|37"
set "APP_GRID[2,12]=CAT|Indirme Araclari"
set "APP_GRID[2,13]=APP|38"
set "APP_GRID[2,14]=APP|39"
set "APP_GRID[2,15]=CAT|Belgeler"
set "APP_GRID[2,16]=APP|40"
set "APP_GRID[2,17]=APP|41"
set "APP_GRID[2,18]=APP|42"
set "APP_GRID[2,19]=CAT|Backup-Recovery"
set "APP_GRID[2,20]=APP|43"
set "APP_GRID[2,21]=APP|44"
set "APP_GRID[2,22]=APP|45"
set "APP_GRID[2,23]=CAT|Uzak Destek"
set "APP_GRID[2,24]=APP|46"
set "APP_GRID[2,25]=APP|47"
set "APP_GRID[2,26]=APP|48"
set "APP_GRID[2,27]=CAT|Guvenlik Tarama"
set "APP_GRID[2,28]=APP|49"
set "APP_GRID[2,29]=APP|50"
set "APP_GRID[3,1]=CAT|Gelistirme"
set "APP_GRID[3,2]=APP|51"
set "APP_GRID[3,3]=APP|52"
set "APP_GRID[3,4]=APP|53"
set "APP_GRID[3,5]=APP|54"
set "APP_GRID[3,6]=APP|55"
set "APP_GRID[3,7]=APP|56"
set "APP_GRID[3,8]=CAT|Runtime"
set "APP_GRID[3,9]=APP|57"
set "APP_GRID[3,10]=APP|58"
set "APP_GRID[3,11]=APP|59"
set "APP_GRID[3,12]=APP|60"
set "APP_GRID[3,13]=CAT|Temizlik"
set "APP_GRID[3,14]=APP|61"
set "APP_GRID[3,15]=APP|62"
set "APP_GRID[3,16]=APP|63"
set "APP_GRID[3,17]=CAT|Diger"
set "APP_GRID[3,18]=APP|64"
set "APP_GRID[3,19]=APP|65"
set "APP_GRID[3,20]=APP|66"
set "APP_GRID[3,21]=APP|67"
set "APP_GRID[3,22]=APP|68"
set "APP_GRID[3,23]=APP|69"
set "APP_GRID[3,24]=CAT|Itchy Programlari"
set "APP_GRID[3,25]=APP|70"
set "APP_GRID[3,26]=APP|71"
set "APP_GRID[3,27]=CAT|Uninstaller"
set "APP_GRID[3,28]=APP|72"
set "APP_GRID[3,29]=APP|73"
set "APP_GRID[3,30]=APP|74"
exit /b


:MAKE_APP_GRID_CELL
set "grid_entry=!APP_GRID[%~1,%~2]!"
set "grid_blank=                                   "
if not defined grid_entry (
    set "%~3=!grid_blank:~0,35!"
    exit /b
)
for /f "tokens=1,2 delims=|" %%a in ("!grid_entry!") do (
    set "grid_type=%%a"
    set "grid_value=%%b"
)
if "!grid_type!"=="CAT" (
    set "grid_text= ▼ !grid_value!                                   "
    set "grid_text=!grid_text:~0,35!"
    set "%~3=%GRY%!grid_text!%RST%"
    exit /b
)
set "grid_idx=!grid_value!"
set "grid_pkg="
set "grid_name="
for /f "tokens=1,2 delims=|" %%a in ("!APP[%grid_idx%]!") do (
    set "grid_pkg=%%a"
    set "grid_name=%%b"
)
if !grid_idx! lss 10 (set "grid_num= !grid_idx!") else set "grid_num=!grid_idx!"
set "grid_mark="
if "!grid_pkg!"=="CUSTOM" set "grid_mark=*"
if "!grid_pkg:~0,7!"=="CUSTOM_" set "grid_mark=*"
set "grid_name_pad= !grid_name!!grid_mark!                                "
set "grid_name_pad=!grid_name_pad:~0,32!"
set "grid_color=%CYN%"
if !grid_idx! geq 5 if !grid_idx! leq 8 set "grid_color=%YLW%"
if !grid_idx! geq 17 if !grid_idx! leq 28 set "grid_color=%YLW%"
if !grid_idx! geq 29 if !grid_idx! leq 34 set "grid_color=%YLW%"
if !grid_idx! geq 38 if !grid_idx! leq 39 set "grid_color=%YLW%"
if !grid_idx! geq 43 if !grid_idx! leq 50 set "grid_color=%YLW%"
if !grid_idx! geq 52 set "grid_color=%YLW%"
set "%~3=%GRN%!grid_num!-%grid_color%!grid_name_pad!%RST%"
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
        set "line=  %YLW%!cat_label!%RST%"
        set "first_row=0"
    ) else (
        set "line=  %YLW%                      %RST%"
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
if "!pkg:~0,7!"=="CUSTOM_" set "mark=*"
set "cell=[!num!] !name!!mark!                                    "
set "cell=!cell:~0,31!"
set "%outvar%=!cell!"
exit /b


:: ============================================================
:: KURULUM PROFILLERI
:: ============================================================
:STANDARD_INSTALLER
cls
call :BANNER
echo.
echo   %GRY%Ana Menu -- Kurulum Profilleri%RST%
echo   %YLW%%BLD%-- Kurulum Profilleri%RST%
echo   %GRY%-----------------------------------------------------------------------%RST%
echo.

call :LOAD_APPS
echo   %CYN%[1]%RST% Standart cihaz
echo       Adobe Reader, Chrome, AnyDesk, PotPlayer, WinRAR, Alpemix
echo   %CYN%[2]%RST% Teknik servis
echo       Standart set, 7-Zip, CrystalDiskInfo, WizTree, Everything, Rufus, Revo, Sysinternals
echo   %CYN%[3]%RST% Oyun ve medya
echo       Steam, EA App, OBS, codec, VLC, PotPlayer, Spotify, HandBrake, DirectX, VC++ Runtime
echo   %CYN%[4]%RST% Gelistirici
echo       Notepad++, VS Code, Git, Node.js, .NET Runtime, VC++ Runtime, Sysinternals
echo   %CYN%[5]%RST% Winget uygulama listesini disari aktar
echo   %CYN%[6]%RST% Winget uygulama listesinden kur
echo.
echo   %DIM%Profiller tek tikla sik kullanilan setleri kurar. Ayrintili secim icin Uygulama Yukleyici kullanilir.%RST%
echo   %DIM%[x] geri   [q] cikis%RST%
echo.

set "choice="
set /p "choice=  %GRN%Secim: %RST%" || goto :EXIT

if /i "!choice!"=="q" goto :EXIT
if /i "!choice!"=="x" goto :MAIN_MENU
if "!choice!"=="1" call :INSTALL_PROFILE "Standart cihaz" "40 9 46 36 69 47"
if "!choice!"=="2" call :INSTALL_PROFILE "Teknik servis" "40 9 46 36 69 47 64 23 25 26 27 72 63"
if "!choice!"=="3" call :INSTALL_PROFILE "Oyun ve medya" "6 8 31 33 34 35 36 37 57 58 60"
if "!choice!"=="4" call :INSTALL_PROFILE "Gelistirici" "51 52 54 55 57 58 59 63"
if "!choice!"=="5" call :WINGET_EXPORT
if "!choice!"=="6" call :WINGET_IMPORT
goto :STANDARD_INSTALLER


:INSTALL_PROFILE
echo.
echo   %YLW%-- %~1 profili kuruluyor...%RST%
echo.
set "ok_count=0"
set "fail_count=0"
for %%i in (%~2) do (
    call :INSTALL_ONE %%i
)
echo.
echo   %GRY%-----------------------------------------------------------------------%RST%
echo   %GRN%[+] Basarili: !ok_count!%RST%   %RED%[-] Basarisiz: !fail_count!%RST%
echo.
pause
exit /b


:WINGET_EXPORT
set "winget_list=%USERPROFILE%\Desktop\Itchy-Winget-Apps.json"
echo.
echo   %YLW%-- Winget uygulama listesi disari aktariliyor...%RST%
winget export -o "!winget_list!" --accept-source-agreements
if !errorlevel! == 0 (
    echo   %GRN%[+] Kaydedildi: !winget_list!%RST%
) else (
    echo   %RED%[-] Liste disari aktarilamadi.%RST%
)
pause
exit /b


:WINGET_IMPORT
echo.
set "winget_list=%USERPROFILE%\Desktop\Itchy-Winget-Apps.json"
set /p "winget_list=  Winget JSON yolu [!winget_list!]: "
if "!winget_list!"=="" set "winget_list=%USERPROFILE%\Desktop\Itchy-Winget-Apps.json"
if not exist "!winget_list!" (
    echo   %RED%[-] Dosya bulunamadi: !winget_list!%RST%
    pause
    exit /b
)
echo.
echo   %YLW%-- Winget listedeki uygulamalari kuruyor...%RST%
winget import -i "!winget_list!" --accept-source-agreements --accept-package-agreements
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

if "!pkg!"=="CUSTOM_CRYSTALDISKINFO" (
    call :DOWNLOAD_AND_START "https://sourceforge.net/projects/crystaldiskinfo/files/latest/download" "CrystalDiskInfo-Setup.exe" "CrystalDiskInfo"
    exit /b
)

if "!pkg!"=="CUSTOM_SPOTIFY" (
    call :INSTALL_SPOTIFY
    exit /b
)

if "!pkg!"=="CUSTOM_DMDE" (
    call :INSTALL_DMDE
    exit /b
)

if "!pkg!"=="CUSTOM_RUSTDESK" (
    call :INSTALL_RUSTDESK
    exit /b
)

if "!pkg!"=="CUSTOM_MALWAREBYTES" (
    call :DOWNLOAD_AND_START "https://downloads.malwarebytes.com/file/mb-windows" "MBSetup.exe" "Malwarebytes"
    exit /b
)

if "!pkg!"=="CUSTOM_IOBIT_UNLOCKER" (
    call :DOWNLOAD_AND_START "https://cdn.iobit.com/dl/unlocker-setup.exe" "IObitUnlocker-Setup.exe" "IObit Unlocker"
    exit /b
)

if "!pkg!"=="CUSTOM_JAVA_UNINSTALLER" (
    call :DOWNLOAD_AND_START "https://javadl-esd-secure.oracle.com/update/jut/JavaUninstallTool.exe" "JavaUninstallTool.exe" "Java Uninstaller"
    exit /b
)

if "!pkg!"=="CUSTOM_MEMORYDIAG" (
    start "" mdsched.exe
    echo     %GRN%[+] Windows Bellek Tanilama acildi%RST%
    set /a ok_count+=1
    exit /b
)

if "!pkg!"=="CUSTOM" (
    echo     %YLW%[~] Ozel kurulum henuz tanimlanmamis, atlandi.%RST%
    set /a fail_count+=1
    exit /b
)

if "!pkg:~0,8!"=="MSSTORE:" (
    set "store_id=!pkg:~8!"
    winget install --id "!store_id!" -e --source msstore --accept-source-agreements --accept-package-agreements --silent
    if !errorlevel! == 0 (
        echo     %GRN%[+] Kuruldu%RST%
        set /a ok_count+=1
    ) else (
        echo     %RED%[-] Basarisiz%RST%
        set /a fail_count+=1
    )
    exit /b
)

winget install --id "!pkg!" -e --source winget --accept-source-agreements --accept-package-agreements --silent
if !errorlevel! == 0 (
    echo     %GRN%[+] Kuruldu%RST%
    set /a ok_count+=1
) else (
    echo     %YLW%[~] Ilk deneme basarisiz. winget kaynagi guncellenip tekrar deneniyor...%RST%
    winget source update --name winget
    winget install --id "!pkg!" -e --source winget --accept-source-agreements --accept-package-agreements --silent
    if !errorlevel! == 0 (
        echo     %GRN%[+] Kuruldu%RST%
        set /a ok_count+=1
    ) else (
        echo     %RED%[-] Basarisiz%RST%
        set /a fail_count+=1
    )
)
exit /b


:DOWNLOAD_AND_START
set "dl_url=%~1"
set "dl_file=%~2"
set "dl_name=%~3"
echo     %YLW%[~] !dl_name! resmi kaynaktan indiriliyor...%RST%
powershell -NoProfile -ExecutionPolicy Bypass -Command "$dir=Join-Path $env:TEMP 'ItchyDownloads'; New-Item -ItemType Directory -Force -Path $dir ^| Out-Null; $out=Join-Path $dir '!dl_file!'; try { Invoke-WebRequest -Uri '!dl_url!' -OutFile $out -UseBasicParsing; Start-Process -FilePath $out; exit 0 } catch { Write-Host $_.Exception.Message; exit 1 }"
if !errorlevel! == 0 (
    echo     %GRN%[+] Indirildi ve baslatildi%RST%
    set /a ok_count+=1
) else (
    echo     %RED%[-] Indirme/baslatma basarisiz%RST%
    set /a fail_count+=1
)
exit /b


:INSTALL_SPOTIFY
echo     %YLW%[~] Spotify kurulumu hazirlaniyor...%RST%
net session >nul 2>&1
if !errorlevel! == 0 (
    set "spotify_cache=%TEMP%\ItchySpotify"
    set "spotify_installer="
    if not exist "!spotify_cache!" mkdir "!spotify_cache!" >nul 2>&1
    echo     %YLW%[~] Yonetici modunda Spotify icin makine kurulumu deneniyor...%RST%
    winget download --id Spotify.Spotify -e --source winget --download-directory "!spotify_cache!" --accept-source-agreements
    for /r "!spotify_cache!" %%f in (*.exe) do set "spotify_installer=%%f"
    if exist "!spotify_installer!" (
        "!spotify_installer!" /extract "%ProgramFiles%\Spotify"
        if !errorlevel! == 0 (
            echo     %GRN%[+] Spotify makine kurulumu tamamlandi%RST%
            set /a ok_count+=1
        ) else (
            echo     %RED%[-] Spotify makine kurulumu basarisiz%RST%
            set /a fail_count+=1
        )
    ) else (
        echo     %RED%[-] Spotify indirilemedi. Programi yonetici olmadan acip tekrar deneyin.%RST%
        set /a fail_count+=1
    )
    exit /b
)
winget install --id Spotify.Spotify -e --source winget --accept-source-agreements --accept-package-agreements --silent
if !errorlevel! == 0 (
    echo     %GRN%[+] Kuruldu%RST%
    set /a ok_count+=1
) else (
    echo     %RED%[-] Basarisiz%RST%
    set /a fail_count+=1
)
exit /b


:INSTALL_DMDE
set "dmde_target=%TEMP%\ItchyDownloads\dmde-win64.zip"
set "dmde_dir=%ProgramFiles%\DMDE"
echo     %YLW%[~] DMDE resmi siteden indiriliyor...%RST%
powershell -NoProfile -ExecutionPolicy Bypass -Command "$dir=Split-Path -Parent '!dmde_target!'; New-Item -ItemType Directory -Force -Path $dir ^| Out-Null; try { $page=Invoke-WebRequest -Uri 'https://dmde.com/download.html' -UseBasicParsing; $href=($page.Links ^| Where-Object { $_.href -match 'win64-gui\.zip$' } ^| Select-Object -First 1).href; if(-not $href){ $match=[regex]::Match($page.Content,'download/[^'' >]+win64-gui\.zip'); if($match.Success){ $href=$match.Value } }; if(-not $href){ throw 'DMDE indirme linki bulunamadi' }; if($href -notmatch '^https?://'){ $href='https://dmde.com/'+$href.TrimStart('/') }; Invoke-WebRequest -Uri $href -OutFile '!dmde_target!' -UseBasicParsing; New-Item -ItemType Directory -Force -Path '!dmde_dir!' ^| Out-Null; Expand-Archive -Path '!dmde_target!' -DestinationPath '!dmde_dir!' -Force; $exe=Get-ChildItem '!dmde_dir!' -Recurse -Filter 'dmde.exe' ^| Select-Object -First 1; if($exe){ Start-Process -FilePath $exe.FullName; exit 0 } else { exit 1 } } catch { Write-Host $_.Exception.Message; exit 1 }"
if !errorlevel! == 0 (
    echo     %GRN%[+] DMDE indirildi, cikarildi ve baslatildi%RST%
    set /a ok_count+=1
) else (
    echo     %RED%[-] DMDE kurulumu basarisiz%RST%
    set /a fail_count+=1
)
exit /b


:INSTALL_RUSTDESK
set "rustdesk_target=%TEMP%\ItchyDownloads\RustDesk-Setup.exe"
echo     %YLW%[~] RustDesk GitHub uzerinden indiriliyor...%RST%
powershell -NoProfile -ExecutionPolicy Bypass -Command "$dir=Split-Path -Parent '!rustdesk_target!'; New-Item -ItemType Directory -Force -Path $dir ^| Out-Null; try { $release=Invoke-RestMethod -Uri 'https://api.github.com/repos/rustdesk/rustdesk/releases/latest'; $asset=$release.assets ^| Where-Object { $_.name -match 'x86_64.*\.exe$' -and $_.name -notmatch 'portable' } ^| Select-Object -First 1; if(-not $asset){ throw 'RustDesk indirme dosyasi bulunamadi' }; Invoke-WebRequest -Uri $asset.browser_download_url -OutFile '!rustdesk_target!' -UseBasicParsing; Start-Process -FilePath '!rustdesk_target!'; exit 0 } catch { Write-Host $_.Exception.Message; exit 1 }"
if !errorlevel! == 0 (
    echo     %GRN%[+] Indirildi ve baslatildi%RST%
    set /a ok_count+=1
) else (
    echo     %RED%[-] RustDesk indirilemedi%RST%
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
:: HIZMET YONETIMI
:: ============================================================
:SERVICE_MENU
cls
call :BANNER
echo.
echo   %GRY%Ana Menu -- Hizmet Yonetimi%RST%
echo   %YLW%%BLD%-- Hizmet Yonetimi%RST%
echo   %GRY%-----------------------------------------------------------------------%RST%
echo.
call :LOAD_SERVICES
call :PRINT_SERVICE_GRID
echo.
echo   %DIM%[numara] sec   [x] geri   [q] cikis%RST%
echo.
set "choice="
set /p "choice=  %GRN%Secim: %RST%" || goto :EXIT
if /i "!choice!"=="q" goto :EXIT
if /i "!choice!"=="x" goto :MAIN_MENU
call :SERVICE_DETAIL "!choice!"
goto :SERVICE_MENU


:LOAD_SERVICES
set "SVC_COUNT=48"
set "SVC[1]=Bluetooth|BthAvctpSvc,bthserv|Bluetooth cihazlari"
set "SVC[2]=Telefon|PhoneSvc|Telefon baglantisi"
set "SVC[3]=Yazici|Spooler|Yazdirma kuyrugu"
set "SVC[4]=Tarayici ve Kamera|stisvc,FrameServer|Tarayici, kamera ve OBS kaynaklari"
set "SVC[5]=Kalem ve Dokunmatik|TabletInputService|Kalem, dokunmatik ve el yazisi"
set "SVC[6]=Bitlocker|BDESVC|Surucu sifreleme"
set "SVC[7]=Tarifeli Aglar|DusmSvc|Kota ve veri kullanimi"
set "SVC[8]=IP Yardimcisi|iphlpsvc|IPv6, tunel ve gelismis ag"
set "SVC[9]=Mobil Etkin Nokta|icssvc|Internet paylasimi"
set "SVC[10]=Radyo ve Ucak Modu|RmSvc|Laptop radyo/ucak modu"
set "SVC[11]=Windows Simdi Baglan|WcnSvc|WPS baglantilari"
set "SVC[12]=Wifi|WlanSvc|Kablosuz ag"
set "SVC[13]=Konum|lfsvc|Windows konum hizmeti"
set "SVC[14]=Miracast|WdiServiceHost,WdiSystemHost|Kablosuz ekran ve tani hizmetleri"
set "SVC[15]=Akis|FDResPub,SSDPSRV,upnphost|Ag uzeri kesif ve paylasim"
set "SVC[16]=Hizli Getir-Baslat|SysMain|Superfetch/SysMain"
set "SVC[17]=Windows Search|WSearch|Indeksleme"
set "SVC[18]=Hizli Kullanici Degistir|seclogon|Ikincil oturum acma"
set "SVC[19]=Yazi Tipi Onbellegi|FontCache|Font onbellegi"
set "SVC[20]=Windows Insider|wisvc|Insider program hizmeti"
set "SVC[21]=Biyometrik|WbioSrvc|Parmak izi ve Windows Hello"
set "SVC[22]=Disk Birlestirme|defragsvc|Optimize suruculer/TRIM"
set "SVC[23]=Yonlendirici|Router|Yonlendirme ve uzak erisim"
set "SVC[24]=Akilli Kart|SCardSvr,ScDeviceEnum,SCPolicySvc|Cipli kart okuyucu"
set "SVC[25]=Kurumsal|AppIDSvc,AssignedAccessManagerSvc|Kiosk/AppLocker/Intune"
set "SVC[26]=Simdi Yurutuluyor|NPSMSvc|Medya oturum yoneticisi"
set "SVC[27]=Performans Gunlukleri|pla|Performans gunlukleri"
set "SVC[28]=Oyun DVR ve Yayin|BcastDVRUserService|Xbox ekran kaydi"
set "SVC[29]=Sistem Geri Yukleme|swprv,VSS|Golge kopya ve geri yukleme"
set "SVC[30]=Karma Gerceklik|SharedRealitySvc|VR/karma gerceklik"
set "SVC[31]=Xbox|XblAuthManager,XblGameSave,XboxGipSvc,XboxNetApiSvc|Xbox hizmetleri"
set "SVC[32]=Teslim En Iyilestirme|DoSvc|Windows Update/Store dagitim"
set "SVC[33]=Uzak Masaustu|TermService,SessionEnv,UmRdpService|RDP baglantisi"
set "SVC[34]=Ekran Yakalama|CaptureService|Ekran yakalama"
set "SVC[35]=Ebeveyn Denetimleri|WpcMonSvc|Aile denetimleri"
set "SVC[36]=Sesli Komut|TokenBroker,OneSyncSvc|Cortana/sesli uygulamalar"
set "SVC[37]=RetailDemo|RetailDemo|Magaza teshir modu"
set "SVC[38]=Kisiler|PimIndexMaintenanceSvc,OneSyncSvc|Kisiler esitleme"
set "SVC[39]=Telemetri|DiagTrack,dmwappushservice|Kullanici verisi/tani"
set "SVC[40]=Sorun Giderme|diagnosticshub.standardcollector.service,DPS,WdiServiceHost,WdiSystemHost|Tani ve sorun giderme"
set "SVC[41]=Sensorler|SensorService,SensrSvc,SensorDataService|Laptop sensorleri"
set "SVC[42]=Otomatik Saat Dilimi|tzautoupdate|Saat dilimi guncelleme"
set "SVC[43]=Mobil Veri|WwanSvc|3G/4G/5G SIM"
set "SVC[44]=Ana Bilgisayari Esitle|OneSyncSvc|Takvim/kisi esitleme"
set "SVC[45]=Temalar|Themes|Windows temalari"
set "SVC[46]=Indirilen Haritalar|MapsBroker|Cevrimdisi haritalar"
set "SVC[47]=Cuzdan|WalletService|Windows cuzdan"
set "SVC[48]=Otomatik Oynat|ShellHWDetection|Otomatik oynat"
exit /b


:PRINT_SERVICE_GRID
for /l %%r in (1,1,24) do (
    call :MAKE_SERVICE_CELL %%r cell1
    set /a "right=%%r+24"
    call :MAKE_SERVICE_CELL !right! cell2
    echo   !cell1!!cell2!
)
exit /b


:MAKE_SERVICE_CELL
set "idx=%~1"
for /f "tokens=1 delims=|" %%a in ("!SVC[%idx%]!") do set "svc_name=%%a"
if %~1 lss 10 (set "num=0%~1") else set "num=%~1"
set "cell=[!num!] !svc_name!                              "
set "cell=!cell:~0,44!"
set "%~2=!cell!"
exit /b


:SERVICE_DETAIL
set "svc_idx=%~1"
for /f "delims=0123456789" %%a in ("!svc_idx!") do exit /b
if "!svc_idx!"=="" exit /b
if !svc_idx! lss 1 exit /b
if !svc_idx! gtr !SVC_COUNT! exit /b
for /f "tokens=1,2,3 delims=|" %%a in ("!SVC[%svc_idx%]!") do (
    set "svc_name=%%a"
    set "svc_ids=%%b"
    set "svc_desc=%%c"
)
cls
call :BANNER
echo.
echo   %YLW%%BLD%-- [!svc_idx!] !svc_name!%RST%
echo   %GRY%-----------------------------------------------------------------------%RST%
echo   !svc_desc!
echo   Servisler: !svc_ids!
echo.
echo   %DIM%[s] durum   [k] kapat/devre disi birak   [a] ac/otomatik yap   [x] geri%RST%
echo.
set "svc_action="
set /p "svc_action=  %GRN%Secim: %RST%" || exit /b
if /i "!svc_action!"=="s" call :SERVICE_STATUS "!svc_ids!"
if /i "!svc_action!"=="k" call :SERVICE_APPLY "!svc_ids!" disable
if /i "!svc_action!"=="a" call :SERVICE_APPLY "!svc_ids!" enable
pause
exit /b


:SERVICE_STATUS
set "ids=%~1"
set "ids=!ids:,= !"
for %%s in (!ids!) do (
    echo.
    echo   %CYN%-- %%s%RST%
    sc query "%%s" | findstr /i "SERVICE_NAME STATE"
)
exit /b


:SERVICE_APPLY
set "ids=%~1"
set "action=%~2"
set "ids=!ids:,= !"
if "!action!"=="disable" (
    echo   %YLW%Servisler durdurulup devre disi birakiliyor...%RST%
    for %%s in (!ids!) do (
        sc stop "%%s" >nul 2>&1
        sc config "%%s" start= disabled >nul 2>&1
        if !errorlevel! == 0 (echo   [+] %%s) else echo   [-] %%s
    )
) else (
    echo   %YLW%Servisler otomatik yapilip baslatiliyor...%RST%
    for %%s in (!ids!) do (
        sc config "%%s" start= auto >nul 2>&1
        sc start "%%s" >nul 2>&1
        if !errorlevel! == 0 (echo   [+] %%s) else echo   [-] %%s
    )
)
exit /b


:: ============================================================
:: OZELLIK YONETIMI
:: ============================================================
:FEATURE_MENU
cls
call :BANNER
echo.
echo   %GRY%Ana Menu -- Ozellik Yonetimi%RST%
echo   %YLW%%BLD%-- Ozellik Yonetimi%RST%
echo   %GRY%-----------------------------------------------------------------------%RST%
echo.
call :LOAD_FEATURES
call :PRINT_FEATURE_GRID
echo.
echo   %DIM%[numara] sec   [x] geri   [q] cikis%RST%
echo.
set "choice="
set /p "choice=  %GRN%Secim: %RST%" || goto :EXIT
if /i "!choice!"=="q" goto :EXIT
if /i "!choice!"=="x" goto :MAIN_MENU
call :FEATURE_DETAIL "!choice!"
goto :FEATURE_MENU


:LOAD_FEATURES
set "FEAT_COUNT=45"
set "FEAT[1]=Fax|feature|FaxServicesClientPackage|Windows Fax"
set "FEAT[2]=Wordpad|cap|Microsoft.Windows.WordPad~~~~0.0.1.0|WordPad"
set "FEAT[3]=Not Defteri|cap|Microsoft.Windows.Notepad~~~~0.0.1.0|Not Defteri"
set "FEAT[4]=Adim Kaydedici|none||psr.exe araci"
set "FEAT[5]=Powershell ISE|feature|MicrosoftWindowsPowerShellISE|PowerShell kod editoru"
set "FEAT[6]=Matematik Ifade Taniyici|feature|MathRecognizer|TabletPC matematik taniyici"
set "FEAT[7]=Linux Altyapi|feature|Microsoft-Windows-Subsystem-Linux|WSL"
set "FEAT[8]=Hizli Destek|cap|App.Support.QuickAssist~~~~0.0.1.0|Quick Assist"
set "FEAT[9]=Hello Face|cap|Hello.Face.18967~~~~0.0.1.0|Yuz tanima"
set "FEAT[10]=OpenSSH|cap|OpenSSH.Client~~~~0.0.1.0|OpenSSH istemci"
set "FEAT[11]=ProjFS|feature|Client-ProjFS|Ongorulen dosya sistemi"
set "FEAT[12]=Sistem Geri Yukleme|svc|swprv,VSS|Golge kopya servisleri"
set "FEAT[13]=Calisma Klasorleri|feature|WorkFolders-Client|Work folders"
set "FEAT[14]=Windows Hata Raporlama|svc|WerSvc|Hata raporlama"
set "FEAT[15]=TFTP|feature|TFTP|TFTP istemci"
set "FEAT[16]=Telnet|feature|TelnetClient|Telnet istemci"
set "FEAT[17]=TCP/IP|none||Temel ag bileseni"
set "FEAT[18]=TIFF IFilter|feature|TIFFIFilter|TIFF arama filtresi"
set "FEAT[19]=WinSat|none||Sistem degerlendirme araci"
set "FEAT[20]=RetailDemo|feature|Client-EmbeddedShellLauncher|Retail demo bagimli"
set "FEAT[21]=Karma Gerceklik|cap|Analog.Holographic.Desktop~~~~0.0.1.0|Mixed Reality"
set "FEAT[22]=CEIP Telemetri|svc|DiagTrack,dmwappushservice|Musteri deneyimi"
set "FEAT[23]=Cihaz Kilitleme|feature|Client-DeviceLockdown|Device lockdown"
set "FEAT[24]=Cok Noktali Baglayici|feature|MultiPoint-Connector|Ortak PC"
set "FEAT[25]=BranchCache|feature|Client-DeviceLockdown|Ortak ag onbellek"
set "FEAT[26]=PDF Olarak Yazdir|feature|Printing-PrintToPDFServices-Features|PDF yazici"
set "FEAT[27]=XPS Belge Yazici|feature|Printing-XPSServices-Features|XPS yazici"
set "FEAT[28]=Ag Dosya Sistemi|feature|ServicesForNFS-ClientOnly|NFS istemci"
set "FEAT[29]=Fotograf Goruntuleyici|none||Eski goruntu acici"
set "FEAT[30]=Uzaktan Yardim|none||msra.exe araci"
set "FEAT[31]=SMB1|feature|SMB1Protocol|Eski SMB paylasim"
set "FEAT[32]=SMB Direct|feature|SMBDirect|SMB Direct"
set "FEAT[33]=Uzak Masaustu|svc|TermService,SessionEnv,UmRdpService|RDP"
set "FEAT[34]=MSMQ|feature|MSMQ-Container|Microsoft Message Queue"
set "FEAT[35]=3D Ekran Koruyucu|none||Ekran koruyucu dosyalari"
set "FEAT[36]=MobilPC|feature|MobilityCenter|Windows Mobility Center"
set "FEAT[37]=Kamera Deneyimi|svc|FrameServer|Kamera"
set "FEAT[38]=Metin Tahmini|none||Klavye ayari"
set "FEAT[39]=Ag Baglanti Yardimcisi|svc|NcaSvc|Network Connectivity Assistant"
set "FEAT[40]=Identity Foundation|feature|Windows-Identity-Foundation|WIF"
set "FEAT[41]=Yerel Grup Ilkesi|none||gpedit.msc Home surumde yok"
set "FEAT[42]=Flipgrid|none||Teams egitim bileseni"
set "FEAT[43]=Veri Merkezi Kopru|feature|DataCenterBridging|Kurumsal ag"
set "FEAT[44]=Active Directory LDS|feature|DirectoryServices-ADAM-Client|AD LDS"
set "FEAT[45]=Windows Tani Altyapisi|svc|DPS,WdiServiceHost,WdiSystemHost|Sorun giderme"
exit /b


:PRINT_FEATURE_GRID
for /l %%r in (1,1,23) do (
    call :MAKE_FEATURE_CELL %%r cell1
    set /a "right=%%r+23"
    if !right! leq !FEAT_COUNT! (call :MAKE_FEATURE_CELL !right! cell2) else set "cell2="
    echo   !cell1!!cell2!
)
exit /b


:MAKE_FEATURE_CELL
set "idx=%~1"
for /f "tokens=1 delims=|" %%a in ("!FEAT[%idx%]!") do set "feat_name=%%a"
if %~1 lss 10 (set "num=0%~1") else set "num=%~1"
set "cell=[!num!] !feat_name!                              "
set "cell=!cell:~0,44!"
set "%~2=!cell!"
exit /b


:FEATURE_DETAIL
set "feat_idx=%~1"
for /f "delims=0123456789" %%a in ("!feat_idx!") do exit /b
if "!feat_idx!"=="" exit /b
if !feat_idx! lss 1 exit /b
if !feat_idx! gtr !FEAT_COUNT! exit /b
for /f "tokens=1,2,3,4 delims=|" %%a in ("!FEAT[%feat_idx%]!") do (
    set "feat_name=%%a"
    set "feat_type=%%b"
    set "feat_id=%%c"
    set "feat_desc=%%d"
)
cls
call :BANNER
echo.
echo   %YLW%%BLD%-- [!feat_idx!] !feat_name!%RST%
echo   %GRY%-----------------------------------------------------------------------%RST%
echo   !feat_desc!
echo.
if "!feat_type!"=="none" (
    echo   %YLW%Bu madde icin otomatik ac/kapat komutu eklenmedi.%RST%
    pause
    exit /b
)
echo   %DIM%[s] durum   [k] kapat/kaldir   [a] ac/kur   [x] geri%RST%
echo.
set "feat_action="
set /p "feat_action=  %GRN%Secim: %RST%" || exit /b
if /i "!feat_action!"=="s" call :FEATURE_APPLY status
if /i "!feat_action!"=="k" call :FEATURE_APPLY disable
if /i "!feat_action!"=="a" call :FEATURE_APPLY enable
pause
exit /b


:FEATURE_APPLY
set "feature_action=%~1"
if "!feat_type!"=="svc" (
    if "!feature_action!"=="status" call :SERVICE_STATUS "!feat_id!"
    if "!feature_action!"=="disable" call :SERVICE_APPLY "!feat_id!" disable
    if "!feature_action!"=="enable" call :SERVICE_APPLY "!feat_id!" enable
    exit /b
)
if "!feat_type!"=="feature" (
    if "!feature_action!"=="status" powershell -NoProfile -Command "Get-WindowsOptionalFeature -Online -FeatureName '!feat_id!' | Select-Object FeatureName,State"
    if "!feature_action!"=="disable" powershell -NoProfile -Command "Disable-WindowsOptionalFeature -Online -FeatureName '!feat_id!' -NoRestart"
    if "!feature_action!"=="enable" powershell -NoProfile -Command "Enable-WindowsOptionalFeature -Online -FeatureName '!feat_id!' -All -NoRestart"
    exit /b
)
if "!feat_type!"=="cap" (
    if "!feature_action!"=="status" powershell -NoProfile -Command "Get-WindowsCapability -Online -Name '!feat_id!' | Select-Object Name,State"
    if "!feature_action!"=="disable" powershell -NoProfile -Command "Remove-WindowsCapability -Online -Name '!feat_id!'"
    if "!feature_action!"=="enable" powershell -NoProfile -Command "Add-WindowsCapability -Online -Name '!feat_id!'"
    exit /b
)
exit /b


:: ============================================================
:: PC ZAMAN AYARLI KAPAT
:: ============================================================
:SHUTDOWN_TIMER
cls
call :BANNER
echo.
echo   %YLW%%BLD%-- PC Zaman Ayarli Kapat%RST%
echo   %GRY%-----------------------------------------------------------------------%RST%
echo.
echo   Dakika girersen PC o sure sonra kapanir.
echo   %DIM%[i] mevcut kapatma talimatini iptal et   [x] geri   [q] cikis%RST%
echo.
set "mins="
set /p "mins=  %GRN%Dakika/Secim: %RST%" || goto :EXIT
if /i "!mins!"=="q" goto :EXIT
if /i "!mins!"=="x" goto :MAIN_MENU
if /i "!mins!"=="i" (
    shutdown /a
    pause
    goto :SHUTDOWN_TIMER
)
for /f "delims=0123456789" %%a in ("!mins!") do goto :SHUTDOWN_TIMER
set /a "secs=!mins!*60"
shutdown /s /t !secs!
echo.
echo   %GRN%[+] Kapatma talimati verildi: !mins! dakika sonra.%RST%
pause
goto :MAIN_MENU


:: ============================================================
:: PING OLCER / DNS DEGISTIRICI
:: ============================================================
:PING_DNS_MENU
cls
call :BANNER
echo.
echo   %YLW%%BLD%-- Ping Olcer / DNS Degistirici%RST%
echo   %GRY%-----------------------------------------------------------------------%RST%
echo.
call :PING_DNS_SUMMARY
echo.
echo   %CYN%[p]%RST% URL/alan adi ping olc
echo   %CYN%[d]%RST% URL/alan adi DNS olc
echo   %CYN%[1]%RST% DNS sunucularini test et
echo   %CYN%[2]%RST% DNS degistir
echo   %CYN%[3]%RST% DNS otomatik yap
echo.
echo   %DIM%[x] geri   [q] cikis%RST%
echo.
set "choice="
set /p "choice=  %GRN%Secim: %RST%" || goto :EXIT
if /i "!choice!"=="q" goto :EXIT
if /i "!choice!"=="x" goto :MAIN_MENU
if /i "!choice!"=="p" call :CUSTOM_PING
if /i "!choice!"=="d" call :CUSTOM_DNS
if "!choice!"=="1" call :DNS_TESTS
if "!choice!"=="2" call :DNS_SET_MENU
if "!choice!"=="3" call :DNS_AUTO
goto :PING_DNS_MENU


:PING_DNS_SUMMARY
echo   %GRY%Site                         Ping ms      DNS ms      Durum%RST%
echo   %GRY%-----------------------------------------------------------------------%RST%
powershell -NoProfile -Command "$sites='google.com','facebook.com','youtube.com','instagram.com','kick.com','reddit.com'; foreach($site in $sites){ $ping='--'; $dns='--'; $state='OK'; try { $p=New-Object Net.NetworkInformation.Ping; $r=$p.Send($site,1200); if($r.Status -eq 'Success'){$ping=[string]$r.RoundtripTime}else{$state=[string]$r.Status} } catch { $state='Ping hata' }; try { $sw=[Diagnostics.Stopwatch]::StartNew(); $null=[Net.Dns]::GetHostAddresses($site); $sw.Stop(); $dns=[string][math]::Round($sw.Elapsed.TotalMilliseconds,1) } catch { if($state -eq 'OK'){$state='DNS hata'} }; '{0,-28} {1,7}      {2,7}      {3}' -f $site,$ping,$dns,$state }"
exit /b


:DNS_TESTS
for %%d in (1.1.1.1 94.140.14.14 9.9.9.9 76.76.2.0 8.8.8.8) do (
    echo.
    echo   %CYN%-- DNS %%d%RST%
    powershell -NoProfile -Command "$m=Measure-Command { $null=Resolve-DnsName google.com -Server %%d -ErrorAction SilentlyContinue }; 'Ms: '+[math]::Round($m.TotalMilliseconds,1)"
)
pause
exit /b


:CUSTOM_PING
echo.
set "target="
set /p "target=  Ping URL/alan adi: "
call :NORMALIZE_HOST "!target!"
if "!host!"=="" exit /b
echo.
echo   %CYN%-- !host!%RST%
ping -n 4 "!host!"
pause
exit /b


:CUSTOM_DNS
echo.
set "target="
set /p "target=  DNS URL/alan adi: "
call :NORMALIZE_HOST "!target!"
if "!host!"=="" exit /b
echo.
echo   %CYN%-- !host!%RST%
powershell -NoProfile -Command "$sw=[Diagnostics.Stopwatch]::StartNew(); try { Resolve-DnsName '!host!' -ErrorAction Stop; $sw.Stop(); 'DNS sure: '+[math]::Round($sw.Elapsed.TotalMilliseconds,1)+' ms' } catch { 'DNS sorgusu basarisiz: '+$_.Exception.Message }"
pause
exit /b


:NORMALIZE_HOST
set "host=%~1"
set "host=!host:https://=!"
set "host=!host:http://=!"
for /f "tokens=1 delims=/" %%h in ("!host!") do set "host=%%h"
exit /b


:DNS_SET_MENU
echo.
echo   %CYN%[1]%RST% Cloudflare 1.1.1.1 / 1.0.0.1
echo   %CYN%[2]%RST% AdGuard 94.140.14.14 / 94.140.15.15
echo   %CYN%[3]%RST% Quad9 9.9.9.9 / 149.112.112.112
echo   %CYN%[4]%RST% ControlD 76.76.2.0 / 76.76.10.0
echo   %CYN%[5]%RST% Google 8.8.8.8 / 8.8.4.4
echo.
set "dns_choice="
set /p "dns_choice=  %GRN%DNS: %RST%" || exit /b
if "!dns_choice!"=="1" powershell -NoProfile -Command "foreach($a in Get-NetAdapter){ if($a.Status -eq 'Up'){ Set-DnsClientServerAddress -InterfaceIndex $a.InterfaceIndex -ServerAddresses 1.1.1.1,1.0.0.1 } }"
if "!dns_choice!"=="2" powershell -NoProfile -Command "foreach($a in Get-NetAdapter){ if($a.Status -eq 'Up'){ Set-DnsClientServerAddress -InterfaceIndex $a.InterfaceIndex -ServerAddresses 94.140.14.14,94.140.15.15 } }"
if "!dns_choice!"=="3" powershell -NoProfile -Command "foreach($a in Get-NetAdapter){ if($a.Status -eq 'Up'){ Set-DnsClientServerAddress -InterfaceIndex $a.InterfaceIndex -ServerAddresses 9.9.9.9,149.112.112.112 } }"
if "!dns_choice!"=="4" powershell -NoProfile -Command "foreach($a in Get-NetAdapter){ if($a.Status -eq 'Up'){ Set-DnsClientServerAddress -InterfaceIndex $a.InterfaceIndex -ServerAddresses 76.76.2.0,76.76.10.0 } }"
if "!dns_choice!"=="5" powershell -NoProfile -Command "foreach($a in Get-NetAdapter){ if($a.Status -eq 'Up'){ Set-DnsClientServerAddress -InterfaceIndex $a.InterfaceIndex -ServerAddresses 8.8.8.8,8.8.4.4 } }"
echo.
echo   %GRN%[+] DNS komutu calistirildi.%RST%
pause
exit /b


:DNS_AUTO
powershell -NoProfile -Command "foreach($a in Get-NetAdapter){ if($a.Status -eq 'Up'){ Set-DnsClientServerAddress -InterfaceIndex $a.InterfaceIndex -ResetServerAddresses } }"
echo.
echo   %GRN%[+] DNS otomatik moda alindi.%RST%
pause
exit /b


:: ============================================================
:: WINDOWS ONARIM
:: ============================================================
:WINDOWS_REPAIR
cls
call :BANNER
echo.
echo   %YLW%%BLD%-- Windows Onarim%RST%
echo   %GRY%-----------------------------------------------------------------------%RST%
echo.
echo   %CYN%[1]%RST% CHKDSK online disk tarama
echo   %CYN%[2]%RST% DISM / SFC sistem dosyasi onarimi
echo   %CYN%[3]%RST% Disk Cleanup
echo   %CYN%[4]%RST% Event Viewer
echo   %CYN%[5]%RST% Task Manager
echo   %CYN%[6]%RST% MemoryDiag
echo   %CYN%[7]%RST% Geri yukleme noktasi olustur
echo   %CYN%[8]%RST% Windows Update bilesenlerini sifirla
echo   %CYN%[9]%RST% Ag onarim komutlari
echo.
echo   %DIM%[x] geri   [q] cikis%RST%
echo.
set "choice="
set /p "choice=  %GRN%Secim: %RST%" || goto :EXIT
if /i "!choice!"=="q" goto :EXIT
if /i "!choice!"=="x" goto :MAIN_MENU
if "!choice!"=="1" call :REPAIR_CHKDSK
if "!choice!"=="2" call :REPAIR_DISM_SFC
if "!choice!"=="3" start "" cleanmgr.exe
if "!choice!"=="4" start "" eventvwr.msc
if "!choice!"=="5" start "" taskmgr.exe
if "!choice!"=="6" start "" mdsched.exe
if "!choice!"=="7" call :CREATE_RESTORE_POINT
if "!choice!"=="8" call :RESET_WINDOWS_UPDATE
if "!choice!"=="9" call :NETWORK_REPAIR
goto :WINDOWS_REPAIR


:REPAIR_CHKDSK
echo.
set "repair_drive=C:"
set /p "repair_drive=  Taranacak surucu [C:]: "
if "!repair_drive!"=="" set "repair_drive=C:"
echo.
echo   %YLW%-- chkdsk !repair_drive! /scan%RST%
chkdsk !repair_drive! /scan
pause
exit /b


:REPAIR_DISM_SFC
echo.
echo   %YLW%-- DISM RestoreHealth basladi...%RST%
DISM.exe /Online /Cleanup-Image /RestoreHealth
echo.
echo   %YLW%-- SFC Scannow basladi...%RST%
sfc /scannow
pause
exit /b


:CREATE_RESTORE_POINT
echo.
echo   %YLW%-- Sistem geri yukleme noktasi olusturuluyor...%RST%
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Enable-ComputerRestore -Drive ($env:SystemDrive+'\') -ErrorAction SilentlyContinue; Checkpoint-Computer -Description 'Itchy Toolbox' -RestorePointType 'MODIFY_SETTINGS' -ErrorAction Stop; '[+] Geri yukleme noktasi olusturuldu.' } catch { '[-] Olusturulamadi: '+$_.Exception.Message; exit 1 }"
pause
exit /b


:RESET_WINDOWS_UPDATE
echo.
echo   %YLW%-- Windows Update onbellegi sifirlaniyor...%RST%
echo   %DIM%BITS, Windows Update ve CryptSvc gecici olarak durdurulur.%RST%
net stop bits
net stop wuauserv
net stop cryptsvc
set "wu_cache=SoftwareDistribution.Itchy.!RANDOM!.old"
set "wu_catroot=catroot2.Itchy.!RANDOM!.old"
if exist "%windir%\SoftwareDistribution" ren "%windir%\SoftwareDistribution" "!wu_cache!"
if exist "%windir%\System32\catroot2" ren "%windir%\System32\catroot2" "!wu_catroot!"
net start cryptsvc
net start wuauserv
net start bits
echo.
echo   %GRN%[+] Windows Update sifirlama komutlari tamamlandi.%RST%
pause
exit /b


:NETWORK_REPAIR
echo.
echo   %YLW%-- Ag onarim komutlari calisiyor...%RST%
ipconfig /flushdns
netsh winsock reset
netsh int ip reset
echo.
echo   %YLW%[~] Winsock/IP sifirlama sonrasi yeniden baslatma gerekebilir.%RST%
pause
exit /b


:: ============================================================
:: YEDEKLEME / GERI YUKLEME
:: ============================================================
:BACKUP_RECOVERY_MENU
cls
call :BANNER
echo.
echo   %YLW%%BLD%-- Yedekleme / Geri Yukleme%RST%
echo   %GRY%-----------------------------------------------------------------------%RST%
echo.
echo   %CYN%[1]%RST% Geri yukleme noktasi olustur
echo   %CYN%[2]%RST% Sistem Geri Yukleme'yi ac
echo   %CYN%[3]%RST% Dosya Gecmisi'ni ac
echo   %CYN%[4]%RST% Windows Yedekleme ayarlarini ac
echo   %CYN%[5]%RST% Winget uygulama listesini disari aktar
echo   %CYN%[6]%RST% Winget uygulama listesinden kur
echo.
echo   %DIM%[x] geri   [q] cikis%RST%
echo.
set "choice="
set /p "choice=  %GRN%Secim: %RST%" || goto :EXIT
if /i "!choice!"=="q" goto :EXIT
if /i "!choice!"=="x" goto :MAIN_MENU
if "!choice!"=="1" call :CREATE_RESTORE_POINT
if "!choice!"=="2" start "" rstrui.exe
if "!choice!"=="3" start "" control.exe /name Microsoft.FileHistory
if "!choice!"=="4" start "" ms-settings:backup
if "!choice!"=="5" call :WINGET_EXPORT
if "!choice!"=="6" call :WINGET_IMPORT
goto :BACKUP_RECOVERY_MENU


:: ============================================================
:: SISTEM ARACLARI
:: ============================================================
:SYSTEM_TOOLS_MENU
cls
call :BANNER
echo.
echo   %YLW%%BLD%-- Sistem Araclari%RST%
echo   %GRY%-----------------------------------------------------------------------%RST%
echo.
echo   %CYN%[1]%RST% Aygit Yoneticisi
echo   %CYN%[2]%RST% Disk Yonetimi
echo   %CYN%[3]%RST% Hizmetler
echo   %CYN%[4]%RST% Gorev Zamanlayici
echo   %CYN%[5]%RST% Baslangic klasoru
echo   %CYN%[6]%RST% Windows Update ayarlari
echo   %CYN%[7]%RST% Ortam degiskenleri
echo   %CYN%[8]%RST% Sysinternals Suite kur
echo.
echo   %DIM%[x] geri   [q] cikis%RST%
echo.
set "choice="
set /p "choice=  %GRN%Secim: %RST%" || goto :EXIT
if /i "!choice!"=="q" goto :EXIT
if /i "!choice!"=="x" goto :MAIN_MENU
if "!choice!"=="1" start "" devmgmt.msc
if "!choice!"=="2" start "" diskmgmt.msc
if "!choice!"=="3" start "" services.msc
if "!choice!"=="4" start "" taskschd.msc
if "!choice!"=="5" start "" explorer.exe shell:startup
if "!choice!"=="6" start "" ms-settings:windowsupdate
if "!choice!"=="7" start "" SystemPropertiesAdvanced.exe
if "!choice!"=="8" (
    call :LOAD_APPS
    set "ok_count=0"
    set "fail_count=0"
    call :INSTALL_ONE 63
    pause
)
goto :SYSTEM_TOOLS_MENU


:: ============================================================
:: AG ONARIM / RAPOR
:: ============================================================
:NETWORK_REPORT_MENU
cls
call :BANNER
echo.
echo   %YLW%%BLD%-- Ag Onarim / Rapor%RST%
echo   %GRY%-----------------------------------------------------------------------%RST%
echo.
echo   %CYN%[1]%RST% Ag onarim komutlari
echo   %CYN%[2]%RST% IP ve bagdastirici bilgisini goster
echo   %CYN%[3]%RST% Detayli sistem raporu olustur
echo   %CYN%[4]%RST% Detayli ag raporu olustur
echo   %CYN%[5]%RST% Yonetici Olarak Yeniden Baslat
echo.
echo   %DIM%[x] geri   [q] cikis%RST%
echo.
set "choice="
set /p "choice=  %GRN%Secim: %RST%" || goto :EXIT
if /i "!choice!"=="q" goto :EXIT
if /i "!choice!"=="x" goto :MAIN_MENU
if "!choice!"=="1" call :NETWORK_REPAIR
if "!choice!"=="2" (
    ipconfig /all
    pause
)
if "!choice!"=="3" call :CREATE_SYSTEM_REPORT
if "!choice!"=="4" call :CREATE_NETWORK_REPORT
if "!choice!"=="5" call :RELAUNCH_ADMIN
goto :NETWORK_REPORT_MENU


:CREATE_SYSTEM_REPORT
set "report_file=%USERPROFILE%\Desktop\Itchy-System-Report.html"
set "report_script=%~dp0Itchy.Reports.ps1"
echo.
echo   %YLW%-- Detayli HTML sistem raporu olusturuluyor...%RST%
if not exist "!report_script!" (
    echo   %RED%[-] Rapor uretici bulunamadi: !report_script!%RST%
    pause
    exit /b
)
powershell -NoProfile -ExecutionPolicy Bypass -File "!report_script!" -Type System -OutputPath "!report_file!"
if exist "!report_file!" (
    echo   %GRN%[+] Kaydedildi: !report_file!%RST%
) else (
    echo   %RED%[-] Sistem raporu olusturulamadi.%RST%
)
pause
exit /b


:CREATE_NETWORK_REPORT
set "report_file=%USERPROFILE%\Desktop\Itchy-Network-Report.html"
set "report_script=%~dp0Itchy.Reports.ps1"
echo.
echo   %YLW%-- Detayli HTML ag raporu olusturuluyor...%RST%
if not exist "!report_script!" (
    echo   %RED%[-] Rapor uretici bulunamadi: !report_script!%RST%
    pause
    exit /b
)
powershell -NoProfile -ExecutionPolicy Bypass -File "!report_script!" -Type Network -OutputPath "!report_file!"
if exist "!report_file!" (
    echo   %GRN%[+] Kaydedildi: !report_file!%RST%
) else (
    echo   %RED%[-] Ag raporu olusturulamadi.%RST%
)
pause
exit /b


:RELAUNCH_ADMIN
net session >nul 2>&1
if !errorlevel! == 0 (
    echo.
    echo   %GRN%[+] Program zaten yonetici olarak calisiyor.%RST%
    pause
    exit /b
)
echo.
echo   %YLW%-- Yonetici izni isteniyor...%RST%
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath $env:ComSpec -ArgumentList '/c','""!TOOLBOX_FILE!""' -Verb RunAs"
exit /b


:: ============================================================
:: LISANS YONETIMI
:: ============================================================
:LICENSE_MENU
cls
call :BANNER
echo.
echo   %YLW%%BLD%-- Lisans Yonetimi%RST%
echo   %GRY%-----------------------------------------------------------------------%RST%
echo.
echo   %CYN%[1]%RST% Windows lisans durumunu goster
echo   %CYN%[2]%RST% Windows lisans anahtari gir
echo   %CYN%[3]%RST% Office lisans durumunu goster
echo   %CYN%[4]%RST% Office lisans anahtari gir
echo.
echo   %DIM%[x] geri   [q] cikis%RST%
echo.
set "choice="
set /p "choice=  %GRN%Secim: %RST%" || goto :EXIT
if /i "!choice!"=="q" goto :EXIT
if /i "!choice!"=="x" goto :MAIN_MENU
if "!choice!"=="1" cscript //nologo %windir%\system32\slmgr.vbs /dli
if "!choice!"=="2" call :WINDOWS_KEY
if "!choice!"=="3" call :OFFICE_STATUS
if "!choice!"=="4" call :OFFICE_KEY
pause
goto :LICENSE_MENU


:WINDOWS_KEY
set "key="
set /p "key=  Windows urun anahtari: "
if not "!key!"=="" cscript //nologo %windir%\system32\slmgr.vbs /ipk !key!
exit /b


:FIND_OSPP
set "OSPP="
for %%p in ("%ProgramFiles%\Microsoft Office\Office16\OSPP.VBS" "%ProgramFiles(x86)%\Microsoft Office\Office16\OSPP.VBS" "%ProgramFiles%\Microsoft Office\Office15\OSPP.VBS" "%ProgramFiles(x86)%\Microsoft Office\Office15\OSPP.VBS") do (
    if exist %%~p set "OSPP=%%~p"
)
exit /b


:OFFICE_STATUS
call :FIND_OSPP
if "!OSPP!"=="" (
    echo   %RED%[-] OSPP.VBS bulunamadi.%RST%
) else (
    cscript //nologo "!OSPP!" /dstatus
)
exit /b


:OFFICE_KEY
call :FIND_OSPP
if "!OSPP!"=="" (
    echo   %RED%[-] OSPP.VBS bulunamadi.%RST%
    exit /b
)
set "key="
set /p "key=  Office urun anahtari: "
if not "!key!"=="" cscript //nologo "!OSPP!" /inpkey:!key!
exit /b


:: ============================================================
:: SISTEM HAKKINDA
:: ============================================================
:SYSTEM_INFO
cls
call :BANNER
echo.
echo   %YLW%%BLD%-- Sistem Hakkinda%RST%
echo   %GRY%-----------------------------------------------------------------------%RST%
echo.
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='SilentlyContinue'; $cs=Get-CimInstance Win32_ComputerSystem; $os=Get-CimInstance Win32_OperatingSystem; $bb=Get-CimInstance Win32_BaseBoard; $bios=Get-CimInstance Win32_BIOS; $cpu=Get-CimInstance Win32_Processor; $gpu=Get-CimInstance Win32_VideoController; $disk=Get-CimInstance Win32_DiskDrive; $ram=Get-CimInstance Win32_PhysicalMemory; if(-not $os){ 'Sistem bilgisi okunamadi. Yonetici olarak calistirmayi deneyin.'; exit }; 'Bilgisayar adi: '+$env:COMPUTERNAME; 'Kullanici adi: '+$env:USERNAME; 'Sistem: '+$os.Caption+' '+$os.OSArchitecture; 'Format/Kurulum tarihi: '+$os.InstallDate; 'Kurulum turu: '+$os.InstallationType; 'Saat dilimi: '+(Get-TimeZone).DisplayName; 'Anakart: '+$bb.Manufacturer+' '+$bb.Product; 'BIOS: '+$bios.SMBIOSBIOSVersion; 'Islemci: '+$cpu.Name; 'Cekirdek/Thread: '+$cpu.NumberOfCores+'/'+$cpu.NumberOfLogicalProcessors; 'L2/L3 KB: '+$cpu.L2CacheSize+'/'+$cpu.L3CacheSize; 'Frekans MHz: '+$cpu.MaxClockSpeed; ''; 'Diskler:'; foreach($d in $disk){ '- '+$d.Model+' '+[math]::Round($d.Size/1GB,1)+' GB' }; ''; 'RAM:'; foreach($m in $ram){ '- '+$m.Manufacturer+' '+[math]::Round($m.Capacity/1GB,1)+' GB '+$m.Speed+' MHz Slot:'+$m.BankLabel }; ''; 'Ekran karti:'; foreach($g in $gpu){ '- '+$g.Name+' VRAM:'+([math]::Round($g.AdapterRAM/1GB,1))+' GB Surucu:'+$g.DriverVersion+' Tarih:'+$g.DriverDate }"
echo.
pause
goto :MAIN_MENU


:: ============================================================
:: KAYITLI WIFI BILGILERI
:: ============================================================
:WIFI_INFO
cls
call :BANNER
echo.
echo   %YLW%%BLD%-- Kayitli WiFi Bilgileri%RST%
echo   %GRY%-----------------------------------------------------------------------%RST%
echo.
powershell -NoProfile -ExecutionPolicy Bypass -Command "$dir=Join-Path $env:TEMP 'ItchyWifiProfiles'; Remove-Item $dir -Recurse -Force -ErrorAction SilentlyContinue; New-Item -ItemType Directory -Path $dir | Out-Null; netsh wlan export profile key=clear folder=$dir | Out-Null; $files=Get-ChildItem $dir -Filter *.xml -ErrorAction SilentlyContinue; if(-not $files){ 'Kayitli WiFi profili bulunamadi veya WiFi hizmeti kapali.'; exit }; foreach($f in $files){ [xml]$x=Get-Content $f.FullName; $ssid=$x.WLANProfile.SSIDConfig.SSID.name; $key=$x.WLANProfile.MSM.security.sharedKey.keyMaterial; if(-not $key){$key='(sifre yok / okunamadi)'}; 'SSID: '+$ssid; 'Sifre: '+$key; '' }; Remove-Item $dir -Recurse -Force -ErrorAction SilentlyContinue"
echo.
pause
goto :MAIN_MENU


:: ============================================================
:: SPLASH - Acilis Ekrani
:: ============================================================
:SPLASH
cls
echo.
echo.
echo                     %GRY%█████ █████  ████ █   █ █   █%RST%     %YLW%█████  ███   ███  █     ████   ███  █   █%RST%
echo                     %GRY%  █     █   █     █   █  █ █ %RST%     %YLW%  █   █   █ █   █ █     █   █ █   █  █ █ %RST%
echo                     %GRY%  █     █   █     █████   █  %RST%     %YLW%  █   █   █ █   █ █     ████  █   █   █  %RST%
echo                     %GRY%  █     █   █     █   █   █  %RST%     %YLW%  █   █   █ █   █ █     █   █ █   █  █ █ %RST%
echo                     %GRY%█████   █    ████ █   █   █  %RST%     %YLW%  █    ███   ███  █████ ████   ███  █   █%RST%
echo.
echo                                      %GRY%created by: M.Mert%RST%
echo                                      %GRY%Windows Sistem Yonetim Araci  v%VERSION%%RST%
echo                                      %GRY%Gelistirici: Itchy%RST%
echo.
echo                                      %DIM%Yukluyor...%RST%
ping -n 3 127.0.0.1 >nul
exit /b


:: ============================================================
:: BANNER
:: ============================================================
:BANNER
echo.
echo      %GRY%█████ █████  ████ █   █ █   █%RST%     %YLW%█████  ███   ███  █     ████   ███  █   █%RST%
echo      %GRY%  █     █   █     █   █  █ █ %RST%     %YLW%  █   █   █ █   █ █     █   █ █   █  █ █ %RST%
echo      %GRY%  █     █   █     █████   █  %RST%     %YLW%  █   █   █ █   █ █     ████  █   █   █  %RST%
echo      %GRY%  █     █   █     █   █   █  %RST%     %YLW%  █   █   █ █   █ █     █   █ █   █  █ █ %RST%
echo      %GRY%█████   █    ████ █   █   █  %RST%     %YLW%  █    ███   ███  █████ ████   ███  █   █%RST%
echo                                      %GRY%created by: M.Mert%RST%
echo      %GRY%itchy toolbox v%VERSION%    PC:%YLW% !MY_PC! %GRY%  IP:%YLW% !MY_IP! %GRY%  Tarih:%YLW% %DATE%%RST%
echo      %GRY%----------------------------------------------------------------------------------------------------%RST%
exit /b


:: ============================================================
:: CIKIS
:: ============================================================
:EXIT
cls
echo.
echo   %YLW%%BLD%Gorusuruz^^!%RST%
echo   %CYN%Itchy Toolbox'i kullandiginiz icin tesekkurler.%RST%
echo.
ping -n 3 127.0.0.1 >nul
exit /b 0
