@echo off
chcp 65001 >nul 2>&1
echo ==========================================
echo   Research Paper Management System
echo ==========================================
echo.

REM Check if Ant is installed
where ant >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Apache Ant is not installed or not in PATH
    echo Download from: https://ant.apache.org/bindownload.cgi
    pause
    exit /b 1
)

REM Get XAMPP Tomcat path (adjust if your XAMPP is installed elsewhere)
set TOMCAT_HOME=C:\xampp\tomcat
set PROJECT_NAME=ResearchPaperManagement

REM Check if XAMPP Tomcat exists
if not exist "%TOMCAT_HOME%" (
    echo ERROR: Tomcat not found at %TOMCAT_HOME%
    echo Please update TOMCAT_HOME in this batch file
    pause
    exit /b 1
)

echo [1/4] Building project...
call ant clean compile dist
if %errorlevel% neq 0 (
    echo ERROR: Build failed!
    pause
    exit /b 1
)

echo.
echo [2/4] Removing old deployment...
if exist "%TOMCAT_HOME%\webapps\%PROJECT_NAME%.war" del "%TOMCAT_HOME%\webapps\%PROJECT_NAME%.war"
if exist "%TOMCAT_HOME%\webapps\%PROJECT_NAME%" rmdir /s /q "%TOMCAT_HOME%\webapps\%PROJECT_NAME%"

echo.
echo [3/4] Extracting WAR file...
powershell -Command "Add-Type -AssemblyName System.IO.Compression.FileSystem; [System.IO.Compression.ZipFile]::ExtractToDirectory('%CD%\dist\%PROJECT_NAME%.war', '%TOMCAT_HOME%\webapps\%PROJECT_NAME%')"
if %errorlevel% neq 0 (
    echo ERROR: Extraction failed!
    pause
    exit /b 1
)

echo.
echo [4/4] Opening browser...
start http://localhost:8080/%PROJECT_NAME%

echo.
echo ==========================================
echo   Done! App should open in browser
echo   Make sure Apache and MySQL are running
echo ==========================================
pause
