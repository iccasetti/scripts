SETLOCAL
sc config w32time start= auto &
net start w32time
w32tm /config /manualpeerlist:"tempo.ien.it"
w32tm /resync /nowait & 
schtasks /Delete /TN "upd" /F
choco install -y autoit &
choco install -y mqtt-explorer &
choco install -y chocolateygui &
choco install -y cura &
set UCS=https://raw.githubusercontent.com/iccasetti/scripts/main/files/cura.exe
curl -o %temp%\cura.exe %UCS% && %temp%\cura.exe -y
move %temp%\cura c:\users\default\appdata\roaming
REM winget install -h --disable-interactivity "Chimpa Agent"
REM admin@chimpa.private -> https://cloud.chimpa.eu/iccasetti/api/latest/mdm/windows/discovery_windows
ECHO %USERNAME% > %TEMP%\WEB-BOOT.LOG
