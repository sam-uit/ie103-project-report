@echo off
REM ============================================================================
REM BOOKING MANAGEMENT SYSTEM - START SCRIPT (Windows)
REM ============================================================================

echo.
echo ============================================
echo   BOOKING MANAGEMENT SYSTEM
echo   Starting Frontend and Backend...
echo ============================================
echo.

REM Check Node.js
where node >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Node.js is not installed
    echo Please install Node.js from https://nodejs.org/
    pause
    exit /b 1
)

echo [OK] Node.js installed: 
node -v

REM Check npm
where npm >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo [ERROR] npm is not installed
    pause
    exit /b 1
)

echo [OK] npm installed:
npm -v
echo.

REM Install dependencies if needed
if not exist "node_modules" (
    echo [INFO] Installing all dependencies using workspaces...
    call npm install
)

echo.
echo [INFO] Checking configuration files...

REM Check frontend .env
if not exist "frontend\.env" (
    echo [WARN] Frontend .env not found. Copying from frontend\.env.example...
    copy frontend\.env.example frontend\.env
)

REM Check backend .env
if not exist "backend\.env" (
    echo [WARN] Backend .env not found. Copying from backend\.env.example...
    copy backend\.env.example backend\.env
    echo [WARN] Please configure backend\.env with your database credentials
)

echo.
echo ============================================
echo   Starting servers...
echo.
echo   Frontend: http://localhost:5174
echo   Backend:  http://localhost:3000
echo.
echo   Press Ctrl+C to stop both servers
echo ============================================
echo.

REM Start both servers
call npm run dev
