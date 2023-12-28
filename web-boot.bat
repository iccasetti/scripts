REM Boot checks

SETLOCAL

:TIME
sc config w32time start= auto &
net start w32time
w32tm /config /manualpeerlist:"tempo.ien.it"
w32tm /resync /nowait 
net localgroup masters && GOTO POL
net localgroup masters /add
net localgroup masters docenti /add

SET LS=192.168.100.2
ping -n 1 -i 1 %LS% || GOTO :OFFSITE

:POL
set UCS=http://%LS%/sw/Registry.pol
curl -o %temp%\Registry.pol %UCS% && move %temp%\Registry.pol C:\Windows\System32\GroupPolicy\Machine
gpupdate /force & 

:PRN
wmic printer list brief |findstr /i DIDATTICA && GOTO VEYON
set UCP=http://%LS%/sw/d.prn
curl -o %temp%\d.prn %UCP% && C:\Windows\System32\spool\tools\PrintBrm.exe -R -f %temp%\d.prn

:VEYON
sc query |findstr /i veyon && GOTO VEYONCONF
set UCS=http://%LS%/sw/veyonSetup.exe
set CNF=http://%LS%/sw/vs.json
curl -o %temp%\vs.json %CNF% 
curl -o %temp%\vs.exe %UCS% && %temp%\vs.exe /S /ApplyConfig=%TEMP%\vs.json 
GOTO CURA

:VEYONCONF
set CNF=http://%LS%/sw/vs.json
curl -o %temp%\vs.json %CNF% 
"C:\PROGRAM FILES\VEYON\veyon-cli.exe" config import %temp%\vs.json

:CURA
wmic product where "name like '%Ultimaker Cura%'" && GOTO CDS
set UCS=http://%LS%/sw/cura.msi
curl -o %temp%\cura.msi %UCS% && %temp%\cura.msi /passive /norestart
set UCS=http://%LS%/sw/cura.exe
curl -o %temp%\cura.exe %UCS% && %temp%\cura.exe -y
move %temp%\cura c:\users\default\appdata\roaming

:CDS
dir c:\apps\cds\c*.exe && GOTO LOG
set UCS=http://%LS%/sw/cds.exe
curl -o %temp%\cds.exe %UCS% && %temp%\cds.exe -y
move %temp%\CdS c:\Apps\CdS
copy "c:\apps\cds\Cricut Design Space.lnk" c:\users\public\desktop

:OFFSITE

:LOG
REM winget install -h --disable-interactivity "Chimpa Agent"
REM admin@chimpa.private -> https://cloud.chimpa.eu/iccasetti/api/latest/mdm/windows/discovery_windows
ECHO %USERNAME% > %TEMP%\wb.LOG
