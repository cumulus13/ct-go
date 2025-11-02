@echo off
REM ct-go build script for Windows
REM Author: cumulus13
REM Description: Build ct binary for multiple platforms

setlocal enabledelayedexpansion

REM Configuration
set BINARY_NAME=ct
set VERSION=1.0.0
set BUILD_DIR=build
set LDFLAGS=-ldflags="-s -w -X main.version=%VERSION%"

REM Colors (using PowerShell for colored output)
set "GREEN=[32m"
set "YELLOW=[33m"
set "RED=[31m"
set "BLUE=[34m"
set "NC=[0m"

REM Check if argument provided
set TARGET=%1
if "%TARGET%"=="" set TARGET=all

REM Print header
echo.
echo ==================================
echo   CT-GO Build Script
echo   Version: %VERSION%
echo ==================================
echo.

REM Check if Go is installed
where go >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [31mError: Go is not installed![0m
    echo [33mPlease install Go from https://golang.org/dl/[0m
    exit /b 1
)

for /f "tokens=*" %%i in ('go version') do set GO_VERSION=%%i
echo [32m✓ %GO_VERSION%[0m
echo.

REM Process command
if /i "%TARGET%"=="all" goto BUILD_ALL
if /i "%TARGET%"=="windows" goto BUILD_WINDOWS
if /i "%TARGET%"=="linux" goto BUILD_LINUX
if /i "%TARGET%"=="darwin" goto BUILD_DARWIN
if /i "%TARGET%"=="darwin-arm" goto BUILD_DARWIN_ARM
if /i "%TARGET%"=="clean" goto CLEAN_ONLY
if /i "%TARGET%"=="help" goto SHOW_HELP

echo [31mError: Unknown option '%TARGET%'[0m
echo.
goto SHOW_HELP

:BUILD_ALL
echo [33mBuilding for all platforms...[0m
echo.
call :CLEAN_BUILD
call :CREATE_BUILD_DIR
call :BUILD_WINDOWS_FUNC
call :BUILD_LINUX_FUNC
call :BUILD_DARWIN_AMD64_FUNC
call :BUILD_DARWIN_ARM64_FUNC
call :SHOW_SUMMARY
goto END

:BUILD_WINDOWS
echo [33mBuilding for Windows only...[0m
echo.
call :CLEAN_BUILD
call :CREATE_BUILD_DIR
call :BUILD_WINDOWS_FUNC
call :SHOW_SUMMARY
goto END

:BUILD_LINUX
echo [33mBuilding for Linux only...[0m
echo.
call :CLEAN_BUILD
call :CREATE_BUILD_DIR
call :BUILD_LINUX_FUNC
call :SHOW_SUMMARY
goto END

:BUILD_DARWIN
echo [33mBuilding for macOS Intel only...[0m
echo.
call :CLEAN_BUILD
call :CREATE_BUILD_DIR
call :BUILD_DARWIN_AMD64_FUNC
call :SHOW_SUMMARY
goto END

:BUILD_DARWIN_ARM
echo [33mBuilding for macOS ARM only...[0m
echo.
call :CLEAN_BUILD
call :CREATE_BUILD_DIR
call :BUILD_DARWIN_ARM64_FUNC
call :SHOW_SUMMARY
goto END

:CLEAN_ONLY
call :CLEAN_BUILD
echo [32m✓ Cleanup complete[0m
goto END

:CLEAN_BUILD
echo [33mCleaning previous builds...[0m
if exist %BUILD_DIR% rmdir /s /q %BUILD_DIR%
if exist %BINARY_NAME%.exe del /q %BINARY_NAME%.exe
if exist %BINARY_NAME% del /q %BINARY_NAME%
echo [32m✓ Clean complete[0m
echo.
goto :EOF

:CREATE_BUILD_DIR
if not exist %BUILD_DIR% mkdir %BUILD_DIR%
goto :EOF

:BUILD_WINDOWS_FUNC
echo [33mBuilding for Windows (amd64)...[0m
set GOOS=windows
set GOARCH=amd64
go build -ldflags="-s -w" -o %BUILD_DIR%\%BINARY_NAME%-windows-amd64.exe .\ct
if %ERRORLEVEL% EQU 0 (
    echo [32m✓ Windows build complete: %BUILD_DIR%\%BINARY_NAME%-windows-amd64.exe[0m
) else (
    echo [31m✗ Windows build failed[0m
    exit /b 1
)
echo.
goto :EOF

:BUILD_LINUX_FUNC
echo [33mBuilding for Linux (amd64)...[0m
set GOOS=linux
set GOARCH=amd64
go build -ldflags="-s -w" -o %BUILD_DIR%\%BINARY_NAME%-linux-amd64 .\ct
if %ERRORLEVEL% EQU 0 (
    echo [32m✓ Linux build complete: %BUILD_DIR%\%BINARY_NAME%-linux-amd64[0m
) else (
    echo [31m✗ Linux build failed[0m
    exit /b 1
)
echo.
goto :EOF

:BUILD_DARWIN_AMD64_FUNC
echo [33mBuilding for macOS Intel (amd64)...[0m
set GOOS=darwin
set GOARCH=amd64
go build -ldflags="-s -w" -o %BUILD_DIR%\%BINARY_NAME%-darwin-amd64 .\ct
if %ERRORLEVEL% EQU 0 (
    echo [32m✓ macOS Intel build complete: %BUILD_DIR%\%BINARY_NAME%-darwin-amd64[0m
) else (
    echo [31m✗ macOS Intel build failed[0m
    exit /b 1
)
echo.
goto :EOF

:BUILD_DARWIN_ARM64_FUNC
echo [33mBuilding for macOS ARM (arm64)...[0m
set GOOS=darwin
set GOARCH=arm64
go build -ldflags="-s -w" -o %BUILD_DIR%\%BINARY_NAME%-darwin-arm64 .\ct
if %ERRORLEVEL% EQU 0 (
    echo [32m✓ macOS ARM build complete: %BUILD_DIR%\%BINARY_NAME%-darwin-arm64[0m
) else (
    echo [31m✗ macOS ARM build failed[0m
    exit /b 1
)
echo.
goto :EOF

:SHOW_SUMMARY
echo ==================================
echo   Build Summary
echo ==================================
echo.
if exist %BUILD_DIR% (
    echo [32mBuild artifacts in %BUILD_DIR%:[0m
    dir /b %BUILD_DIR%
    echo.
    echo [34mTotal size:[0m
    for /f "tokens=3" %%a in ('dir %BUILD_DIR% ^| findstr "bytes"') do echo %%a bytes
)
echo.
echo [32m✓ All builds completed successfully![0m
echo.
goto :EOF

:SHOW_HELP
echo Usage: %0 [options]
echo.
echo Options:
echo   all           Build for all platforms (default)
echo   windows       Build for Windows only
echo   linux         Build for Linux only
echo   darwin        Build for macOS Intel only
echo   darwin-arm    Build for macOS ARM only
echo   clean         Clean build artifacts only
echo   help          Show this help message
echo.
echo Examples:
echo   %0              # Build for all platforms
echo   %0 windows      # Build for Windows only
echo   %0 clean        # Clean build artifacts
goto END

:END
endlocal