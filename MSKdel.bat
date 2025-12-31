@echo off
mode con: cols=100 lines=35
color 0B
title DATADEL - AUTOMATED DELETION PROTOCOL
cls

:: --- CONFIGURATION ---
set PYTHON_EXE=C:\Users\SPARK\AppData\Local\Programs\Python\Python313\python.exe
set SCRIPT_PATH=C:\Users\SPARK\Desktop\datadel\datadel.py
:: ---------------------

:LANG_SELECT
cls
echo.
echo.
echo      /$$$$$$$   /$$$$$$  /$$$$$$$$ /$$$$$$  /$$$$$$$  /$$$$$$$$ /$$
echo     ^| $$__  $$ /$$__  $$^|__  $$ __/$$__  $$^| $$__  $$^| $$_____/^| $$
echo     ^| $$  \ $$^| $$  \ $$   ^| $$  ^| $$  \ $$^| $$  \ $$^| $$      ^| $$
echo     ^| $$  ^| $$^| $$$$$$$$   ^| $$  ^| $$$$$$$$^| $$  ^| $$^| $$$$$   ^| $$
echo     ^| $$  ^| $$^| $$__  $$   ^| $$  ^| $$__  $$^| $$  ^| $$^| $$__/   ^| $$
echo     ^| $$  ^| $$^| $$  ^| $$   ^| $$  ^| $$  ^| $$^| $$  ^| $$^| $$      ^| $$
echo     ^| $$$$$$$/^| $$  ^| $$   ^| $$  ^| $$  ^| $$^| $$$$$$$/^| $$$$$$$$^| $$$$$$$$
echo     ^|_______/ ^|__/  ^|__/   ^|__/  ^|__/  ^|__/^|_______/ ^|________/^|________/
echo.
echo      ======================================================================
echo              R G P D   D E L E T I O N   P R O T O C O L   v 2.0
echo              By MSKarma
echo      ======================================================================
echo.
echo      SELECT LANGUAGE / CHOISISSEZ LA LANGUE :
echo.
echo        [1]  ENGLISH
echo        [2]  FRANCAIS
echo.
echo      ======================================================================
set /p lang="> SELECTION : "

if "%lang%"=="1" goto MENU_EN
if "%lang%"=="2" goto MENU_FR
goto LANG_SELECT

:: =============================================================================
::                              ENGLISH SECTION
:: =============================================================================
:MENU_EN
cls
echo.
echo      ======================================================================
echo              M A I N   M E N U
echo      ======================================================================
echo.
echo        [1]  INITIALIZE PROTOCOL (Launch Deletion Bot)
echo        [2]  ACCESS TARGET DATABASE (List Services)
echo        [3]  ABORT MISSION (Exit)
echo.
echo      ======================================================================
set /p choix="> INSTRUCTION : "

if "%choix%"=="1" goto SEARCH_EN
if "%choix%"=="2" goto LIST_EN
if "%choix%"=="3" exit
goto MENU_EN

:SEARCH_EN
cls
echo.
echo      ======================================================================
echo              T A R G E T   I D E N T I F I C A T I O N
echo      ======================================================================
echo.
echo      Enter target service name (e.g., Reddit, Amazon, Google...)
echo.
set /p service="> TARGET : "
if "%service%"=="" goto SEARCH_EN

cls
echo.
echo      ======================================================================
echo              A U T H E N T I C A T I O N   R E Q U I R E D
echo      ======================================================================
echo.
echo      [!] Credentials are passed to the Selenium bot in real-time.
echo          They are NOT stored or saved anywhere.
echo.
set /p login="> USERNAME/EMAIL : "
set /p pass="> PASSWORD : "

cls
echo.
echo      ======================================================================
echo              E X E C U T I O N   I N   P R O G R E S S . . .
echo      ======================================================================
echo.
echo      [*] Initializing Selenium Engine...
echo      [*] Opening Secure Browser Session...
echo      [*] Injecting Credentials...
echo.
echo      ----------------------------------------------------------------------
echo      DO NOT CLOSE THE CHROME WINDOW
echo      ----------------------------------------------------------------------
echo.

"%PYTHON_EXE%" "%SCRIPT_PATH%" %service% --login "%login%" --password "%pass%"

echo.
echo      ======================================================================
echo              M I S S I O N   C O M P L E T E
echo      ======================================================================
echo.
pause
goto MENU_EN

:LIST_EN
cls
echo.
echo      ======================================================================
echo              T A R G E T   D A T A B A S E
echo      ======================================================================
echo.
powershell -NoProfile -Command "$json = Get-Content '%~dp0services.json' | ConvertFrom-Json; $json.PSObject.Properties.Name | Sort-Object | ForEach-Object { Write-Host '      [+] ' $_ }"
echo.
echo.
pause
goto MENU_EN

:: =============================================================================
::                              SECTION FRANCAISE
:: =============================================================================
:MENU_FR
cls
echo.
echo      ======================================================================
echo              M E N U   P R I N C I P A L
echo      ======================================================================
echo.
echo        [1]  INITIALISER LE PROTOCOLE (Lancer le robot)
echo        [2]  CONSULTER LA BASE DE DONNEES CIBLES
echo        [3]  AVORTER LA MISSION (Quitter)
echo.
echo      ======================================================================
set /p choix="> INSTRUCTION : "

if "%choix%"=="1" goto SEARCH_FR
if "%choix%"=="2" goto LIST_FR
if "%choix%"=="3" exit
goto MENU_FR

:SEARCH_FR
cls
echo.
echo      ======================================================================
echo              C I B L A G E   D U   S E R V I C E
echo      ======================================================================
echo.
echo      Entrez le nom de la cible (ex: Reddit, Amazon, Google...)
echo.
set /p service="> CIBLE : "
if "%service%"=="" goto SEARCH_FR

cls
echo.
echo      ======================================================================
echo              A U T H E N T I F I C A T I O N   R E Q U I S E
echo      ======================================================================
echo.
echo      [!] Ces identifiants sont transmis au robot Selenium en temps reel.
echo          Ils ne sont ni stockes ni enregistres.
echo.
set /p login="> IDENTIFIANT (Email/User) : "
set /p pass="> MOT DE PASSE : "

cls
echo.
echo      ======================================================================
echo              E X E C U T I O N   E N   C O U R S . . .
echo      ======================================================================
echo.
echo      [*] Initialisation du moteur Selenium...
echo      [*] Ouverture du navigateur securise...
echo      [*] Injection des identifiants...
echo.
echo      ----------------------------------------------------------------------
echo      NE FERMEZ PAS LA FENETRE CHROME QUI VA S'OUVRIR
echo      ----------------------------------------------------------------------
echo.

"%PYTHON_EXE%" "%SCRIPT_PATH%" %service% --login "%login%" --password "%pass%"

echo.
echo      ======================================================================
echo              M I S S I O N   T E R M I N E E
echo      ======================================================================
echo.
pause
goto MENU_FR

:LIST_FR
cls
echo.
echo      ======================================================================
echo              B A S E   D E   D O N N E E S   C I B L E S
echo      ======================================================================
echo.
powershell -NoProfile -Command "$json = Get-Content '%~dp0services.json' | ConvertFrom-Json; $json.PSObject.Properties.Name | Sort-Object | ForEach-Object { Write-Host '      [+] ' $_ }"
echo.
echo.
pause
goto MENU_FR
