REM Boot checks

SETLOCAL

ECHO %computername% |findstr /i SERVER && EXIT 

:TIMERS
REM regolo l'orologio e lo imposto perché recuperi sempre l'ora dal web 
sc config w32time start= auto &
net start w32time
w32tm /config /manualpeerlist:"tempo.ien.it"
w32tm /resync /nowait 
net localgroup masters && GOTO LNKS
net localgroup masters /add
net localgroup masters docenti /add

:LNKS
echo URL=https://ide.mblock.cc/ >> %L%
SET L=c:\users\public\desktop\LinkUtili.url
echo [InternetShortcut] > %L%
echo URL=https://sites.google.com/iccasetti.org/ >> %L%

:PRN
wmic printer list brief |findstr /i LEXMARK && GOTO VEYON
set UCP=https://cc.112pc.it/userfiles/macerie@verderam.com/Sw/monte.prn?download=1
curl -o %temp%\monte.prn %UCP% && C:\Windows\System32\spool\tools\PrintBrm.exe -R -f %temp%\monte.prn

:VEYON
EXIT 

sc query |findstr /i veyon && GOTO VEYONCONF
set UCS=http://192.168.100.2/sw/veyonSetup.exe
set CNF=http://192.168.100.2/sw/vs.json
curl -o %temp%\vs.json %CNF% 
curl -o %temp%\vs.exe %UCS% && %temp%\vs.exe /S /ApplyConfig=%TEMP%\vs.json 
GOTO CURA

:VEYONCONF
set CNF=http://192.168.100.2/sw/vs.json
curl -o %temp%\vs.json %CNF% 
"C:\PROGRAM FILES\VEYON\veyon-cli.exe" config import %temp%\vs.json

:CURA
wmic product where "name like '%Ultimaker Cura%'" && GOTO CDS
set UCS=http://192.168.100.2/sw/cura.msi
curl -o %temp%\cura.msi %UCS% && %temp%\cura.msi /passive /norestart
set UCS=http://192.168.100.2/sw/cura.exe
curl -o %temp%\cura.exe %UCS% && %temp%\cura.exe -y
move %temp%\cura c:\users\default\appdata\roaming

:CDS

dir c:\apps\cds\c*.exe && GOTO FIX
set UCS=http://192.168.100.2/sw/cds.exe
curl -o %temp%\cds.exe %UCS% && %temp%\cds.exe -y
move %temp%\CdS c:\Apps\
copy "c:\apps\cds\Cricut Design Space.lnk" c:\users\public\desktop

:OFFSITE

:FIX
icacls c:\apps\cds /grant everyone:F /T

:LOG
REM winget install -h --disable-interactivity "Chimpa Agent"
REM admin@chimpa.private -> https://cloud.chimpa.eu/iccasetti/api/latest/mdm/windows/discovery_windows
ECHO %USERNAME% > %TEMP%\wb.LOG
