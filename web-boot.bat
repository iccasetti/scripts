SETLOCAL
choco install -y autoit
sc config w32time start= auto
net start w32time
w32tm /resync & 
REM winget install -h --disable-interactivity "Chimpa Agent"
REM admin@chimpa.private -> https://cloud.chimpa.eu/iccasetti/api/latest/mdm/windows/discovery_windows
ECHO %USERNAME% > %TEMP%\WEB-BOOT.LOG
