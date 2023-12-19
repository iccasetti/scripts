SETLOCAL
sc config w32time start= auto &
net start w32time
w32tm /config /manualpeerlist:"tempo.ien.it"
w32tm /resync /nowait & 
schtasks /Delete /TN "upd" /F
REM REG DELETE "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy Objects\{46B3FB07-BBF9-493F-BC99-D6521BA4C043}Machine\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /VA /F
choco install -y cricutdesignspace & 
REM choco install -y autoit &
REM choco install -y mqtt-explorer &
REM choco install -y chocolateygui &
REM choco install -y cura &
REM set UCS=https://raw.githubusercontent.com/iccasetti/scripts/main/files/cura.exe
REM curl -o %temp%\cura.exe %UCS% && %temp%\cura.exe -y
REM move %temp%\cura c:\users\default\appdata\roaming
set UCS=https://raw.githubusercontent.com/iccasetti/scripts/main/files/Registry.pol
curl -o %temp%\Registry.pol %UCS% && move %temp%\Registry.pol C:\Windows\System32\GroupPolicy\Machine
REM winget install -h --disable-interactivity "Chimpa Agent"
REM admin@chimpa.private -> https://cloud.chimpa.eu/iccasetti/api/latest/mdm/windows/discovery_windows
ECHO %USERNAME% > %TEMP%\WEB-BOOT.LOG
