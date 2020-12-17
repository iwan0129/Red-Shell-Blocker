@echo off

:: https://sites.google.com/site/eneerge/scripts/batchgotadmin
:: Check if the user has admin rights.
::: If the user doesn't have admin rights make attempt to get and relaunch
:---------------------------------------------------------------------------------------------------------
if "%PROCESSOR_ARCHITECTURE%" == "amd64" (
    >nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) else (
    >nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

if not '%ERRORLEVEL%' == '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:---------------------------------------------------------------------------------------------------------

set hostspath="%windir%\System32\drivers\etc\hosts"
set /A add_line = 1

echo Checking Hosts File...
echo.
echo.

CALL :check_entry "0.0.0.0 treasuredata.com"
CALL :check_entry "0.0.0.0 api.treasuredata.com"
CALL :check_entry "0.0.0.0 in.treasuredata.com"
CALL :check_entry "0.0.0.0 cdn.rdshll.com"
CALL :check_entry "0.0.0.0 redshell.io"
CALL :check_entry "0.0.0.0 api.redshell.io"
CALL :check_entry "0.0.0.0 t.redshell.io"
CALL :check_entry "0.0.0.0 innervate.us"

echo.
echo Finnished Checking. You Can Close The Window Now
echo.
echo.

:loop
pause > NUL
goto loop

:check_entry
find /c "%~1" %hostspath% > NUL
if %ERRORLEVEL% == 0 (
    echo %~1 Found
    echo.
) else (
    echo %~1 Missing. Adding It Now   

    if %add_line% == 1 (
       echo. >> %hostspath%
       set /A add_line = 0
    )

    echo %~1 >> %hostspath% 
    echo.
)
EXIT /B 0