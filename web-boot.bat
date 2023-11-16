SETLOCAL
REM choco install -y scratch
winget install -h --disable-interactivity "Chimpa Agent"
REM admin@chimpa.private -> https://cloud.chimpa.eu/iccasetti/api/latest/mdm/windows/discovery_windows
ECHO %USERNAME% > %TEMP%\WEB-BOOT.LOG
