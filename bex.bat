SETLOCAL
sc config w32time start= auto &
net start w32time
w32tm /config /manualpeerlist:"tempo.ien.it"
w32tm /resync /nowait & 
net localgroup masters /add
net localgroup masters docenti /add
REM schtasks /Delete /TN "upd" /F
REM REG DELETE "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy Objects\{46B3FB07-BBF9-493F-BC99-D6521BA4C043}Machine\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /VA /F
REM choco install -y cricutdesignspace & 
REM choco install -y autoit &
REM choco install -y mqtt-explorer &
REM choco install -y chocolateygui &
REM choco install -y cura &
REM set UCS=https://raw.githubusercontent.com/iccasetti/scripts/main/files/cura.exe
set UCS=http://192.168.100.2/sw/cura.msi
curl -o %temp%\cura.msi %UCS% && %temp%\cura.msi /passive /norestart
set UCS=http://192.168.100.2/sw/cura.exe
curl -o %temp%\cura.exe %UCS% && %temp%\cura.exe -y
move %temp%\cura c:\users\default\appdata\roaming
set UCS=http://192.168.100.2/sw/Registry.pol
curl -o %temp%\Registry.pol %UCS% && move %temp%\Registry.pol C:\Windows\System32\GroupPolicy\Machine
gpupdate /force & 
set UCP=http://192.168.100.2/sw/d.prn
curl -o %temp%\d.prn %UCP% && C:\Windows\System32\spool\tools\PrintBrm.exe -R -f %temp%\d.prn
set UCS=http://192.168.100.2/sw/veyonSetup.exe
set CNF=http://192.168.100.2/sw/vs.json
curl -o %temp%\vs.json %CNF% 
curl -o %temp%\vs.exe %UCS% && %temp%\vs.exe /S 
REM winget install -h --disable-interactivity "Chimpa Agent"
REM admin@chimpa.private -> https://cloud.chimpa.eu/iccasetti/api/latest/mdm/windows/discovery_windows
ECHO %USERNAME% > %TEMP%\fixa.LOG
