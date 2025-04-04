REM Boot checks

SETLOCAL

ECHO %computername% |findstr /i SERVER && EXIT 

rem RD /Q /S %TEMP%

:PWR
powercfg /x standby-timeout-ac 0
powercfg /x hibernate-timeout-ac 0

:FIRE
netsh advfirewall firewall add rule name="veyon_server" dir=in action=allow program="C:\Program Files\Veyon\veyon-server.exe" enable=yes
netsh advfirewall firewall add rule name="veyon_wcli" dir=in action=allow program="C:\Program Files\Veyon\veyon-wcli.exe" enable=yes
netsh advfirewall firewall add rule name="veyon_worker" dir=in action=allow program="C:\Program Files\Veyon\veyon-worker.exe" enable=yes
netsh advfirewall firewall add rule name="veyon_service" dir=in action=allow program="C:\Program Files\Veyon\veyon-service.exe" enable=yes

netsh advfirewall firewall add rule name="lm" dir=in action=allow program="C:\Program Files (x86)\LiteManager Pro - Server\ROMServer.exe" enable=yes

:TIMERS
REM regolo l'orologio e lo imposto perché recuperi sempre l'ora dal web 
sc config w32time start= auto &
net start w32time
w32tm /config /manualpeerlist:"tempo.ien.it"
w32tm /resync /nowait 
net localgroup masters && GOTO POL
net localgroup masters /add
net localgroup masters docenti /add


SET LS=192.168.100.2
REM verifico che il server web locale sia raggiungibile (se non sono a scuola non lo è)
ping -n 1 -i 1 %LS% || GOTO :OFFSITE

:INVALSI
REM SET IL=http://192.168.100.2/sw/INVALSI2025.lnk
REM curl -o %temp%\INVALSI2025.lnk %IL% && copy /Y %temp%\INVALSI2025.lnk c:\users\public\desktop

:POL
REM aggiorno le policy di sicurezza (utile per )
set UCS=http://192.168.100.2/sw/Registry.pol
curl -o %temp%\Registry.pol %UCS% && move /Y %temp%\Registry.pol C:\Windows\System32\GroupPolicy\Machine
REM gpupdate /force & 

:BOOTSC
dir c:\bin\bb.bat || mklink c:\bin\bb.bat C:\Windows\System32\GroupPolicy\Machine\Scripts\Startup\boot.bat

:LNKS
SET L=c:\users\public\desktop\LinkUtili.url
echo [InternetShortcut] > %L%
echo URL=https://sites.google.com/iccasetti.org/info >> %L%

:PRN
wmic printer list brief |findstr /i DIDATTICA && GOTO VEYON
set UCP=http://192.168.100.2/sw/d.prn
curl -o %temp%\d.prn %UCP% && C:\Windows\System32\spool\tools\PrintBrm.exe -R -f %temp%\d.prn

:VEYON
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

dir c:\apps\cds\c*.exe && GOTO SCRATCHLINK
set UCS=http://192.168.100.2/sw/cds.exe
curl -o %temp%\cds.exe %UCS% && %temp%\cds.exe -y
move %temp%\CdS c:\Apps\
copy "c:\apps\cds\Cricut Design Space.lnk" c:\users\public\desktop

:SCRATCHLINK
dir "%programfiles(x86)%\scratch link\scratchlink.exe" && GOTO COL
set UCS=http://192.168.100.2/sw/ScratchLinkSetup.msi
curl -o %temp%\scratchlink.msi %UCS% && %temp%\scratchlink.msi /passive /norestart

:COL
REM dir "C:\Program Files (x86)\Collaudo2024-2025" && GOTO BUP
REM set UCS=http://192.168.100.2/sw/col.exe
REM curl -o %temp%\col.exe %UCS% && %temp%\col.exe /verysilent /norestart

:BUP
schtasks |findstr bootupd2  && GOTO FIX
schtasks |findstr bootupd && schktasks /Delete /TN bootupd /F
curl http://192.168.100.2/sw/bootupd.xml -o %temp%\bootupd.xml 
schtasks.exe /Create /XML %temp%\bootupd.xml /tn bootupd2


:OFFSITE

:FIX
icacls c:\apps\cds /grant everyone:F /T

:LOG
REM winget install -h --disable-interactivity "Chimpa Agent"
REM admin@chimpa.private -> https://cloud.chimpa.eu/iccasetti/api/latest/mdm/windows/discovery_windows
ECHO %USERNAME% > %TEMP%\wb.LOG

