@echo off
title DATADEL - Installation des dependances
color 0b
cls

echo ========================================================
echo        DATADEL - INSTALLATION AUTOMATIQUE
echo ========================================================
echo.

python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERREUR] Python n'est pas detecte !
    echo Veuillez installer Python 3 et cocher "Add to PATH".
    echo.
    pause
    exit /b
)

echo [*] Python detecte. Verification de la version...
python --version
echo.

echo [*] Mise a jour de PIP...
python -m pip install --upgrade pip
echo.

if exist "requirements.txt" (
    echo [*] Installation des dependances depuis requirements.txt...
    python -m pip install -r requirements.txt
) else (
    echo [ERREUR] Le fichier requirements.txt est introuvable !
    echo Veuillez le creer avec les noms des librairies (ex: requests).
    echo.
    pause
    exit /b
)

echo.
echo ========================================================
echo [OK] INSTALLATION TERMINEE !
echo Vous pouvez maintenant lancer datadel.bat
echo ========================================================
echo.
pause
