@echo off
SETLOCAL EnableDelayedExpansion

REM =====================================================
REM Locked environment
REM =====================================================
set REQUIRED_PYTHON_VERSION=3.12.0
set REQUIRED_PIP_VERSION=23.2.1

REM =====================================================
REM 1. Check python exists
REM =====================================================
where python >nul 2>&1 || (
    echo ERROR: Python not found
    echo Required: Python %REQUIRED_PYTHON_VERSION%
    exit /b 1
)

REM =====================================================
REM 2. Block Microsoft Store Python
REM =====================================================
for %%P in (python.exe) do set PYTHON_EXE=%%~dp$PATH:P
echo %PYTHON_EXE% | find "WindowsApps" >nul && (
    echo ERROR: Microsoft Store Python detected
    exit /b 1
)

REM =====================================================
REM 3. Python version check (exact)
REM =====================================================
for /f "tokens=2 delims= " %%V in ('python --version 2^>^&1') do set PY_VER=%%V
IF NOT "%PY_VER%"=="%REQUIRED_PYTHON_VERSION%" (
    echo ERROR: Python %PY_VER% detected
    echo Required: Python %REQUIRED_PYTHON_VERSION%
    exit /b 1
)
echo Python %PY_VER% detected.

REM =====================================================
REM 4. pip version check
REM =====================================================
for /f "tokens=2 delims= " %%P in ('python -m pip --version') do set PIP_VER=%%P
IF NOT "%PIP_VER%"=="23.2.1" (
    echo ERROR: pip %PIP_VER% detected
    echo Required: pip 23.2.1
    exit /b 1
)
echo pip %PIP_VER% detected.

REM =====================================================
REM 5. Python dependency check (external script)
REM =====================================================
REM Capture output from Python script
for /f "delims=" %%L in ('python "%~dp0check_deps.py" 2^>^&1') do (
    set LINE=%%L
    echo !LINE!
    echo !LINE! | find "INVALID_DEPENDENCIES" >nul
    if !ERRORLEVEL! EQU 0 (
        set MISSING=1
    )
    if defined MISSING (
        REM Collect missing dependency lines
        if not "!LINE!"=="INVALID_DEPENDENCIES" (
            set DEP=!LINE!
            echo.
            echo ERROR: Missing or wrong Python dependency detected:
            echo   !DEP!
            echo.
            echo Fix by running:
            echo   python -m pip install !DEP!
        )
    )
)

IF DEFINED MISSING (
    exit /b 1
)

REM =====================================================
REM Success
REM =====================================================
echo.
echo Python environment validated successfully
ENDLOCAL
exit /b 0
