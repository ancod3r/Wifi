@echo off
CLS
color A
title Networking. . .
 ECHO.
 ECHO =============================
 ECHO Running Admin shell
 ECHO =============================
:: It is Treated as Virus in OS Because of Admin Privillages
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
echo 			Hello, %username% Choose Your Option :)
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
echo  6. Get Your Saved WiFi Password
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
::SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
::netsh wlan show driver | find /i "Hosted" > temp.txt
::set /p suport=<temp.txt
::set oky=%suport:~32,3%
::if /i "!%oky%!" EQU "!Yes!" (
::netsh wlan show interface | find /I "Hosted" > temp1.txt
::set /p hostd=<temp.txt
::set var=%hostd:~29,3%
::if /i "!%var%!" EQU "!Not!" (
::netsh wlan set hostednetwork mode=allow ssid=Hello key=087654321>NUL
::netsh wlan start hostednetwork>NUL
::echo Wifi Name: Hello , Password: 087654321
::pause
::) else (
::  echo "Hotspot Alrady Running. . .!"
::pause
::)
::) else (
::  echo "Hotspot cannot be established Driver Not Supportd!"
::pause
::)
::del temp1.txt
::del temp.txt
SETLOCAL ENABLEDELAYEDEXPANSION
netsh wlan show driver | find /i "network" > temp.txt
set /p suport=<temp.txt
set okye=%suport:~32,3%
if /i not"!%okye%!"EQU"!Yes!" (
netsh wlan set hostednetwork mode=allow ssid=Hello key=087654321>NUL
netsh wlan start hostednetwork>NUL
echo Wifi Name: Hello , Password: 087654321
pause
) else (
  echo "Hotspot cannot be established Driver Not Supportd!"
pause
)
del temp.txt
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
::netsh int tcp set global chimney=enabled
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
color A
@echo off & setlocal enabledelayedexpansion
Set "Copyname=Wifi Passwords"
Mode con cols=75 lines=8
cls & color 0A & echo.
  echo             ***********************************************
  echo                      %Copyname%
  echo             ***********************************************
  echo(
if _%1_==_Main_  goto :Main
Set Count=0
Set L=0
:Main
Call :init
Call :CountLines
Set "PasswordLog=%~dp0Wifi_Passwords_on_%ComputerName%.txt"
%Mod%
  echo(
  echo             ***********************************************
  echo                      %Copyname%
  echo             ***********************************************
  echo(
Call :Color 0E "                 [N][SSID] ================ Password" 1
echo(
(
  echo             ***********************************************
  echo                      %Copyname%
  echo             ***********************************************
  echo(
  echo                  [N][SSID] ==============^> "Password"
  echo(
  
)>"%PasswordLog%"
for /f "skip=2 delims=: tokens=2" %%a in ('netsh wlan show profiles') do (
    if not "%%a"=="" (
        set "ssid=%%a"
        set "ssid=!ssid:~1!"
    call :Getpassword "!ssid!"
    )
)
echo(
echo Done
If exist "%PasswordLog%" start "" "%PasswordLog%"
pause>nul
exit
:Getpassword
set "name=%1"
set "name=!name:"=!"
Set "passwd="
for /f "delims=: tokens=2" %%a in ('netsh wlan show profiles %1 key^=clear ^|find /I "Cont"') do (
  set "passwd=%%a"
  Set /a Count+=1
)

If defined passwd (
  set passwd=!passwd:~1!
  echo                  [!Count!][!name!] ====^> "!passwd!"
  echo                  [!Count!][!name!] ====^> "!passwd!" >> "%PasswordLog%"
) else (
  Set /a Count+=1
call :color 0C "                 [!Count!][!name!] The Password is empty" 1
  echo                  [!Count!][!name!] The Password is empty >> "%PasswordLog%"
)
exit /b
:init
prompt $g
for /F "delims=." %%a in ('"prompt $H. & for %%b in (1) do rem"') do set "BS=%%a"
exit /b
:color
set nL=%3
if not defined nL echo requires third argument & pause > nul & goto :eof
if %3 == 0 (
    <nul set /p ".=%bs%">%2 & findstr /v /a:%1 /r "^$" %2 nul & del %2 2>&1 & goto :eof
) else if %3 == 1 (
    echo %bs%>%2 & findstr /v /a:%1 /r "^$" %2 nul & del %2 2>&1 & goto :eof
)
exit /b
:CountLines
for /f "skip=2 delims=: tokens=2" %%a in ('netsh wlan show profiles') do (
    if not "%%a"=="" (
    set /a L+=1
  )
)
set /a L=!L! + 10
Set Mod=Mode con cols=75 Lines=!L!
exit /b
pause>nul
:end
exit