@echo off
setlocal enabledelayedexpansion

:: Chemin de base
set "BASE_DIR=.\export"

echo 📁 Création des dossiers dans %BASE_DIR%...
echo.

:: Boucle sur chaque OS et architecture
for %%O in (windows linux macos) do (
    for %%A in (x86_x64 arm64) do (
        mkdir "%BASE_DIR%\%%O\%%A" 2>nul
        echo   [OK] %BASE_DIR%\%%O\%%A
    )
)

echo.
echo ✨ Arborescence créée avec succès !
pause