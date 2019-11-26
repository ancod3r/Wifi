@echo off
CLS
color A
title Networking. . .
 ECHO.
 ECHO =============================
 ECHO Running Admin shell
 ECHO =============================

:init
 setlocal DisableDelayedExpansion
 set cmdInvoke=1
 set winSysFolder=System32
 set "batchPath=%~0"
 for %%k in (%0) do set batchName=%%~nk
 set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
 setlocal EnableDelayedExpansion

:checkPrivileges
  NET FILE 1>NUL 2>NUL
  if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
  if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
  ECHO.
  ECHO **************************************
  ECHO Invoking UAC for Privilege Escalation
  ECHO **************************************

  ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
  ECHO args = "ELEV " >> "%vbsGetPrivileges%"
  ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
  ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
  ECHO Next >> "%vbsGetPrivileges%"

  if '%cmdInvoke%'=='1' goto InvokeCmd 

  ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
  goto ExecElevation

:InvokeCmd
  ECHO args = "/c """ + "!batchPath!" + """ " + args >> "%vbsGetPrivileges%"
  ECHO UAC.ShellExecute "%SystemRoot%\%winSysFolder%\cmd.exe", args, "", "runas", 1 >> "%vbsGetPrivileges%"

:ExecElevation
 "%SystemRoot%\%winSysFolder%\WScript.exe" "%vbsGetPrivileges%" %*
 exit /B

:gotPrivileges
 setlocal & cd /d %~dp0
 if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)
if not "%1" == "max" start /MAX cmd /c %0 max & exit/b

:menu
cls
Set /a num=(%Random% %%9)+1
color %num%
echo.
echo.
echo 			Hello, %username% Choose Your Option.I'll Do Rest Of The Things :)
echo.
echo.
echo  1. Create Hotspot Name Hello , Password Is 087654321
echo.
echo  2. Stop Hotspot
echo.
echo  3. Boost WiFi Speed
echo.
echo  4. Set Wifi Speed To Defalt Settings (May Decrease WiFi Speed)
echo.
echo  5. View Parameters
echo.
echo  6. Find Your Saved WiFi Password
echo.
echo  7. Exit
echo.
set /p abcd=Select Your Option:  
if %abcd%==1 goto Hotspot
if %abcd%==2 goto stop Hotspot
if %abcd%==3 goto SpeedUp
if %abcd%==4 goto SetToDefalt
if %abcd%==5 goto Global Parameters
if %abcd%==6 goto password
if %abcd%==7 goto end
goto menu

:Hotspot
cls
Set /a num=(%Random% %%9)+1
color %num%
netsh wlan set hostednetwork mode=allow ssid=Hello key=087654321
netsh wlan start hostednetwork
pause
goto menu

:stop Hotspot
cls
Set /a num=(%Random% %%9)+1
color %num%
netsh wlan stop hostednetwork
pause
goto menu

:Global Parameters
cls
Set /a num=(%Random% %%9)+1
color %num%
echo Here is a view of your Global Parameters
echo.
netsh int tcp show global
echo Press any key to go to menu. . .
pause>nul
goto menu

:SpeedUp
cd/
cls
Set /a num=(%Random% %%9)+1
color %num%
echo Here is a view of your Global Parameters
echo.
netsh int tcp show global
pause
cls
netsh int tcp set global chimney=enabled
netsh int tcp set global autotuninglevel=normal
netsh int tcp set global congestionprovider=ctcp
netsh int tcp show global
pause
goto menu

:SetToDefalt
cd/
cls
Set /a num=(%Random% %%9)+1
color %num%
echo Here is a view of your Global Parameters
echo.
netsh int tcp show global
pause
cls
netsh int tcp set global chimney=default
netsh int tcp set global autotuninglevel=normal
netsh int tcp set global congestionprovider=none
netsh int tcp show global
pause
goto menu
:password
cls
color A
netsh wlan show profile
msg * "write (netsh wlan show profile name=HereYourWiFiName key=clear) Hit Enter under Security settings you will find Key Content There is your password"
echo.
echo.
echo "Copy This Line From netsh To clear And Paste (netsh wlan show profile name=HereYourWiFiName key=clear) Hit Enter under Security settings you will find Key Content There is your password"
echo.
echo.
cmd \k
pause>nul

:end
exit
