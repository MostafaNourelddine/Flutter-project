@echo off
REM Flutter Chrome Runner
REM Replace the path below with your Flutter installation path
set FLUTTER_PATH=C:\src\flutter\bin\flutter.bat

REM If Flutter is in a different location, uncomment and modify one of these:
REM set FLUTTER_PATH=C:\Users\%USERNAME%\flutter\bin\flutter.bat
REM set FLUTTER_PATH=%LOCALAPPDATA%\flutter\bin\flutter.bat

if exist "%FLUTTER_PATH%" (
    echo Installing dependencies...
    call "%FLUTTER_PATH%" pub get
    echo.
    echo Running in Chrome...
    call "%FLUTTER_PATH%" run -d chrome
) else (
    echo Flutter not found at: %FLUTTER_PATH%
    echo.
    echo Please edit this file and set FLUTTER_PATH to your Flutter installation location.
    echo Common locations:
    echo   - C:\src\flutter\bin\flutter.bat
    echo   - C:\Users\%USERNAME%\flutter\bin\flutter.bat
    echo   - %LOCALAPPDATA%\flutter\bin\flutter.bat
    pause
)


