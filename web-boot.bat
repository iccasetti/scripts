SETLOCAL
REM choco install -y scratch
winget install -h --disable-interactivity "Chimpa Agent"
ECHO %USERNAME% > %TEMP%\WEB-BOOT.LOG
