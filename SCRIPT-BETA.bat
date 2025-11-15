@echo off

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Ce script doit etre execute en tant qu’administrateur.
    pause
    exit /b
)

ver | findstr /i "10.0" >nul
if errorlevel 1 (
    echo Ce script est conçu uniquement pour Windows 10/11.
    pause
    exit /b
)

setlocal EnableDelayedExpansion
                  
echo.
echo            Script Windows by Ryder-Blase     
echo          ==================================
echo.


echo Charger la ruche du User Default...
reg load "HKLM\DefUser" "C:\Users\Default\NTUSER.DAT" >nul 2>&1

echo Bypass du System Requirements de Windows 11...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Control Panel\UnsupportedHardwareNotificationCache" /v SV1 /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Control Panel\UnsupportedHardwareNotificationCache" /v SV2 /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\UnsupportedHardwareNotificationCache" /v SV1 /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\UnsupportedHardwareNotificationCache" /v SV2 /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\DefUser\UnsupportedHardwareNotificationCache" /v SV1 /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\DefUser\UnsupportedHardwareNotificationCache" /v SV2 /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\LabConfig" /v BypassCPUCheck /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\LabConfig" /v BypassRAMCheck /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\LabConfig" /v BypassSecureBootCheck /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\LabConfig" /v BypassStorageCheck /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\LabConfig" /v BypassTPMCheck /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\MoSetup" /v AllowUpgradesWithUnsupportedTPMOrCPU /t REG_DWORD /d 1 /f >nul 2>&1

echo Supression de Microsoft Edge...
 reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge" /f >nul 2>&1
 reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge Update" /f >nul 2>&1

 set "service_names=edgeupdate edgeupdatem"
 for %%n in (%service_names%) do (
 sc stop %%n >NUL 2>&1
 sc delete %%n >NUL 2>&1
 reg delete "HKLM\SYSTEM\CurrentControlSet\Services\%%n" /f >NUL 2>&1
 )

 for /f "skip=1 tokens=1 delims=," %%a in ('schtasks /query /fo csv') do (
  for %%b in (%%a) do (
   if "%%b"=="MicrosoftEdge" schtasks /delete /tn "%%~a" /f >NUL 2>&1))

 where /q "%ProgramFiles(x86)%\Microsoft\Edge\Application:*"
 start /w "" "%~dp0\Uninstall_Edge\Setup_Edge.exe" --uninstall --system-level --force-uninstall

 taskkill /im MicrosoftEdgeUpdate.exe /f >NUL 2>&1
 rd /s /q "%ProgramFiles(x86)%\Microsoft\Edge" >NUL 2>&1
 rd /s /q "%ProgramFiles(x86)%\Microsoft\EdgeCore" >NUL 2>&1
 rd /s /q "%ProgramFiles(x86)%\Microsoft\EdgeUpdate" >NUL 2>&1
 rd /s /q "%ProgramFiles(x86)%\Microsoft\Temp" >NUL 2>&1
 rd /s /q "%AllUsersProfile%\Microsoft\EdgeUpdate" >NUL 2>&1
 rd /s /q "%SystemRoot%\System32\MicrosoftEdgeCP.exe" >NUL 2>&1
 del /s /q "%AllUsersProfile%\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" >NUL 2>&1
 rd /s /q "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Microsoft Edge" >NUL 2>&1
 reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge" /f >NUL 2>&1
 reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Edge" /f >NUL 2>&1
 reg delete "HKCU\Software\Microsoft\Edge" /f >nul 2>&1
 reg add "HKLM\SOFTWARE\Policies\Microsoft\EdgeUpdate" /v DoNotUpdateToEdgeWithChromium /t REG_DWORD /d 1 /f >nul 2>&1
 del /s /q "%PUBLIC%\Desktop\Microsoft Edge.lnk" >nul 2>&1

echo Changement des OEM information...
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v Manufacturer /f >nul 2>&1
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v Model /f >nul 2>&1
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v SupportHours /f >nul 2>&1
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v SupportPhone /f >nul 2>&1
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v SupportURL /f >nul 2>&1
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v Logo /f >nul 2>&1

echo Changement du Nom du PC...
set /p PCNAME=Nom du PC :
powershell -Command "Rename-Computer -NewName "%PCNAME%" -Force" >nul 2>&1

 echo Suppression des apps inutiles...
 setlocal enabledelayedexpansion
 set apps=^
 3DBuilder;^
 AppUp.IntelManagementandSecurityStatus;^
 DolbyLaboratories.DolbyAccess;^
 DolbyLaboratories.DolbyDigitalPlusDecoderOEM;^
 OneNote;^
 SkypeApp;^
 People;^
 ZuneMusic;^
 ZuneVideo;^
 Microsoft.YourPhone;^
 MicrosoftSolitaireCollection;^
 BingNews;^
 BingWeather;^
 linkedin;^
 Microsoft.PowerAutomateDesktop;^
 HolographicFirstRun;^
 Microsoft.GetHelp;^
 Microsoft.Getstarted;^
 Microsoft.MicrosoftStickyNotes;^
 Microsoft.MixedReality.Portal;^
 Microsoft.Microsoft3DViewer;^
 Microsoft.Windows.DevHome;^
 Microsoft.MicrosoftOfficeHub;^
 Microsoft.Copilot;^
 Microsoft.Windows.Copilot;^
 Microsoft.Windows.Ai.Copilot;^
 Microsoft.Windows.Recall;^
 Microsoft.Todos;^
 Microsoft.Wallet;^
 Microsoft.Windows.CrossDevice;^
 Copilot;^
 OneConnect;^
 Clipchamp;^
 soundrecorder;^
 Microsoft.WindowsFeedbackHub
 for %%A in (%apps%) do (
     echo Supression de %%A...
    powershell -Command "Get-AppxPackage -AllUsers *%%A* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
    REM (Sysprep bug) powershell -Command "Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like '*%%A*' | Remove-AppxProvisionedPackage -AllUsers -Online -ErrorAction SilentlyContinue" >nul 2>&1
)

echo Supression des Widgets Windows...
powershell -Command "Get-AppxPackage *WebExperience* | Remove-AppxPackage -AllUsers" >nul 2>&1
REM (Sysprep bug) powershell -Command "Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like "*WebExperience*" | Remove-AppxProvisionedPackage -Online -AllUsers" >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v AllowNewsAndInterests /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" /v EnableFeeds /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\DefUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /t REG_DWORD /d 0 /f >nul 2>&1

echo Nettoyage de la Taskbar...
reg add "HKLM\DefUser\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v DisableNotificationCenter /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v DisableNotificationCenter /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v SearchboxTaskbarMode /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\DefUser\Software\Microsoft\Windows\CurrentVersion\Search" /v SearchboxTaskbarMode /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowTaskViewButton /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\DefUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowTaskViewButton /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\DefUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarMn /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\DefUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarMn /t REG_DWORD /d 0 /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" /f >nul 2>&1
reg delete "HKLM\DefUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" /f >nul 2>&1
REM powershell.exe -ExecutionPolicy Bypass -File "%~dp0\Taskbar_Layout.ps1"

echo Restauration du clique droit de Windows 10 (Legacy)...
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /ve /d "" /f >nul 2>&1
reg add "HKLM\DefUser\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /ve /d "" /f >nul 2>&1

:: Get Windows build number using PowerShell (since wmic is deprecated)
for /f %%a in ('powershell -NoProfile -Command "[Environment]::OSVersion.Version.Build"') do (
    set "build=%%a"
)

:: Show build number
echo Build number detected: !build!

:: Validate number
set /a buildCheck=!build! 2>nul
if "!buildCheck!"=="" (
    echo Build number is not a valid number.
    pause
    exit /b 1
)

:: Ask for confirmation before downloading and installing StartAllBack/StartIsBack
set /p confirmShell=Voulez-vous installer StartAllBack/StartIsBack et remplacer le shell Windows par StartAllBack et supprimer ShellExperience, StartMenuExperience, Search, etc ? (Y/N) : 
if /i not "%confirmShell%"=="Y" (
    echo Operation annulee par l'utilisateur.
    goto :skip_shell_replace
)

if !buildCheck! GEQ 22000 (
    echo Windows 11 or Server 2022+ detected. Installing StartAllBack...
    powershell -Command "Invoke-WebRequest -Uri 'https://startisback.sfo3.cdn.digitaloceanspaces.com/StartAllBack_3.9.15_setup.exe' -OutFile '%TEMP%\startallback.exe'" >nul 2>&1
    start /wait "" "%TEMP%\startallback.exe" >nul 2>&1
) else (
    echo Windows 10 or lower detected. Installing StartIsBack...
    powershell -Command "Invoke-WebRequest -Uri 'https://startisback.sfo3.cdn.digitaloceanspaces.com/StartIsBackPlusPlus_setup.exe' -OutFile '%TEMP%\startisback.exe'" >nul 2>&1
    start /wait "" "%TEMP%\startisback.exe" >nul 2>&1
)

echo Desactivation du Shell etc ... (SystemApps)
:: Detect NSudo.exe in script directory or system PATH
set "NSUDO_PATH=%~dp0NSudo.exe"
if not exist "%NSUDO_PATH%" set "NSUDO_PATH=NSudo.exe"

echo Remove C:\Program Files (x86)\Microsoft\EdgeWebView...
takeown /f "C:\Program Files (x86)\Microsoft\EdgeWebView" /r >nul 2>&1
rmdir /q /s "C:\Program Files (x86)\Microsoft\EdgeWebView" >nul 2>&1

 echo Supression de WebView
 where /q "%ProgramFiles(x86)%\Microsoft\EdgeWebView\Application:*"
 if %errorlevel% neq 0 goto cleanup_wv_junk
 start /w "" "%~dp0\Uninstall_Edge\Setup_Edge.exe" --uninstall --msedgewebview --system-level --force-uninstall

 :cleanup_wv_junk
 for /f "delims=" %%d in ('dir /ad /b /s "%ProgramFiles(x86)%\Microsoft\EdgeWebView" 2^>NUL ^| sort /r') do rd "%%d" 2>NUL

echo Desactivation de Windows Search...
sc config "WSearch" start=disabled >nul 2>&1
sc stop "WSearch" >nul 2>&1

taskkill /f /im ShellExperienceHost.exe >nul 2>&1
"%NSUDO_PATH%" -U:T -P:E cmd.exe /c move "C:\Windows\SystemApps\ShellExperienceHost_cw5n1h2txyewy" "C:\Windows\SystemApps\ShellExperienceHost_cw5n1h2txyewy.old"
taskkill /f /im StartMenuExperienceHost.exe >nul 2>&1
"%NSUDO_PATH%" -U:T -P:E cmd.exe /c move "C:\Windows\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy" "C:\Windows\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy.old"
taskkill /f /im SearchApp.exe >nul 2>&1 
"%NSUDO_PATH%" -U:T -P:E cmd.exe /c move "C:\Windows\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy" "C:\Windows\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy.old"
taskkill /f /im TextInputHost.exe >nul 2>&1
"%NSUDO_PATH%" -U:T -P:E cmd.exe /c move "C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy" "C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy.old"
"%NSUDO_PATH%" -U:T -P:E cmd.exe /c reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Control Panel\Settings\Network" /v ReplaceVan /t REG_DWORD /d 2 /f 
"%NSUDO_PATH%" -U:T -P:E cmd.exe /c reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC" /v EnableMtcUvc /t REG_DWORD /d 0 /f 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v UseWin32TrayClockExperience /t REG_DWORD /d 1 /f >nul 2>&1
taskkill /f /im ShellHost.exe >nul 2>&1
"%NSUDO_PATH%" -U:T -P:E cmd.exe /c move "C:\Windows\System32\ShellHost.exe" "C:\Windows\System32\ShellHost.exe.old"
schtasks /Change /TN "Microsoft\Windows\Server Manager\ServerManager"  /Disable >nul 2>&1

:skip_shell_replace

echo Desactiver la reinstallation de DevHome...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Orchestrator\UScheduler\DevHomeUpdate" /v workCompleted /t REG_DWORD /d 1 /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\WindowsUpdate\Orchestrator\UScheduler_Oobe\DevHomeUpdate" /f >nul 2>&1

echo Desactivation de BitLocker Device Encryption...
reg add "HKLM\SYSTEM\ControlSet001\Control\BitLocker" /v PreventDeviceEncryption /t REG_DWORD /d 1 /f >nul 2>&1

echo Desactivation du Chat Windows...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Chat" /v ChatIcon /t REG_DWORD /d 3 /f >nul 2>&1

echo Desactivation de Copilot...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v HubsSidebarEnabled /t REG_DWORD /d 0 /f >nul 2>&1

echo Desactivation complete de Recall et AI...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsAI" /v DisableAIDataAnalysis /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsAI" /v TurnOffWindowsAI /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Recall" /v DisableRecall /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsAI" /v DisableRecall /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Policies\Microsoft\Windows\WindowsAI" /v DisableAIDataAnalysis /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\DefUser\Software\Policies\Microsoft\Windows\WindowsAI" /v DisableAIDataAnalysis /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Experience" /v AllowCopilot /t REG_DWORD /d 0 /f >nul 2>&1

echo Desactivation de l'installation automatique de Teams...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Teams" /v DisableInstallation /t REG_DWORD /d 1 /f >nul 2>&1

echo Desactivation de New Outlook...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Mail" /v PreventRun /t REG_DWORD /d 1 /f >nul 2>&1

echo Desactivation de Cross Device Resume...
REG ADD "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Connectivity\DisableCrossDeviceResume" /v value /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\8\1387020943" /v EnabledStateOptions /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\8\1387020943" /v EnabledState /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\8\1387020943" /v Variant /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\8\1387020943" /v VariantPayload /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\8\1387020943" /v VariantPayloadKind /t REG_DWORD /d 0 /f >nul 2>&1

echo Desactivation des mises a jour automatiques d'Outlook via Windows Update...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Orchestrator\UScheduler\OutlookUpdate" /v workCompleted /t REG_DWORD /d 1 /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\WindowsUpdate\Orchestrator\UScheduler_Oobe\OutlookUpdate" /f >nul 2>&1

echo Configuration des politiques MRT (Malicious Software Removal Tool)...
reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v DontOfferThroughWUAU /t REG_DWORD /d 1 /f >nul 2>&1

echo Desactivation du Reserved Storage Manager...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v ShippedWithReserves /t REG_DWORD /d 0 /f >nul 2>&1

echo Suppression de OneDrive...
C:\Windows\System32\OneDriveSetup.exe /uninstall >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v DisableFileSyncNGSC /t REG_DWORD /d 1 /f >nul 2>&1


echo Installation des Logiciels depuis SRV-FICHIERS...
setlocal
set EXE_FOLDER=%~dp0\Basic_installers
 for %%F in ("%EXE_FOLDER%\*.exe") do (
    echo Running %%F
    start "" "%%F"
 )
endlocal

 setlocal
 set MSI_FOLDER=%~dp0\Basic_installers
 for %%F in ("%MSI_FOLDER%\*.msi") do (
    echo Running %%F
    start "" "%%F"
 )
 endlocal

echo Installation de Chrome...
powershell -Command "Invoke-WebRequest -Uri 'https://dl.google.com/chrome/install/latest/chrome_installer.exe' -OutFile '%TEMP%\chrome_installer.exe'" >nul 2>&1
start /wait "" "%TEMP%\chrome_installer.exe" /silent /install >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice" /v Progid /t REG_SZ /d "ChromeHTML" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\https\UserChoice" /v Progid /t REG_SZ /d "ChromeHTML" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\ftp\UserChoice" /v Progid /t REG_SZ /d "ChromeHTML" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.htm\UserChoice" /v Progid /t REG_SZ /d "ChromeHTML" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.html\UserChoice" /v Progid /t REG_SZ /d "ChromeHTML" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.shtml\UserChoice" /v Progid /t REG_SZ /d "ChromeHTML" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.webp\UserChoice" /v Progid /t REG_SZ /d "ChromeHTML" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.xht\UserChoice" /v Progid /t REG_SZ /d "ChromeHTML" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.xhtml\UserChoice" /v Progid /t REG_SZ /d "ChromeHTML" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.xml\UserChoice" /v Progid /t REG_SZ /d "ChromeHTML" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.pdf\UserChoice" /v Progid /t REG_SZ /d "ChromeHTML" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.svf\UserChoice" /v Progid /t REG_SZ /d "ChromeHTML" /f >nul 2>&1

echo Installation de 7-Zip...
powershell -Command "Invoke-WebRequest -Uri 'https://www.7-zip.org/a/7z2409-x64.exe' -OutFile '%TEMP%\7z2409-x64.exe'" >nul 2>&1
start /wait "" "%TEMP%\7z2409-x64.exe" /S >nul 2>&1

echo Installation de DirectX...
powershell -Command "Invoke-WebRequest -Uri 'https://download.microsoft.com/download/1/7/1/1718ccc4-6315-4d8e-9543-8e28a4e18c4c/dxwebsetup.exe' -OutFile '%TEMP%\dxwebsetup.exe'" >nul 2>&1
start /wait "" "%TEMP%\dxwebsetup.exe" /Q >nul 2>&1

echo Desactivation des Sponsored Apps (applications sponsorisees pour prevenir les pubs et les apps non desire)...

echo Desactivation de WindowsConsumerFeatures...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsConsumerFeatures /t REG_DWORD /d 1 /f >nul 2>&1

echo Desactivation du Content Delivery Manager pour l'utilisateur courant...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v ContentDeliveryAllowed /t REG_DWORD /d 0 /f >nul 2>&1

echo Desactivation du Content Delivery Manager pour le profil par defaut...
reg add "HKLM\DefUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v ContentDeliveryAllowed /t REG_DWORD /d 0 /f >nul 2>&1

echo Configuration des epingles du menu demarrer...
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Start" /v ConfigureStartPins /t REG_SZ /d "{\"pinnedList\": [{}]}" /f >nul 2>&1

echo Desactivation des fonctionnalites de gestion de contenu (utilisateur courant)...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v FeatureManagementEnabled /t REG_DWORD /d 0 /f >nul 2>&1

echo Desactivation des applications OEM preinstallees...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v OemPreInstalledAppsEnabled /t REG_DWORD /d 0 /f >nul 2>&1

echo Desactivation des applications preinstallees...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v PreInstalledAppsEnabled /t REG_DWORD /d 0 /f >nul 2>&1

echo Desactivation de l'activation precedente des applications preinstallees...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v PreInstalledAppsEverEnabled /t REG_DWORD /d 0 /f >nul 2>&1

echo Desactivation des installations silencieuses d'applications...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SilentInstalledAppsEnabled /t REG_DWORD /d 0 /f >nul 2>&1

echo Desactivation de SoftLanding et du contenu abonne...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SoftLandingEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContentEnabled /t REG_DWORD /d 0 /f >nul 2>&1

echo Desactivation des differents contenus abonnes (IDs specifiques)...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-310093Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338387Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338388Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338389Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338393Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-353694Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-353696Enabled /t REG_DWORD /d 0 /f >nul 2>&1

echo Desactivation des suggestions dans le panneau systeme...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0 /f >nul 2>&1

echo Application des memes reglages au profil par defaut...
reg add "HKLM\DefUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v FeatureManagementEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\DefUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v OemPreInstalledAppsEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\DefUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v PreInstalledAppsEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\DefUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v PreInstalledAppsEverEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\DefUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SilentInstalledAppsEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\DefUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SoftLandingEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\DefUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContentEnabled /t REG_DWORD /d 0 /f >nul 2>&1

echo Desactivation des contenus abonnes (profil par defaut)...
reg add "HKLM\DefUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-310093Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\DefUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338387Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\DefUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338388Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\DefUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338389Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\DefUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338393Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\DefUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-353694Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\DefUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-353696Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\DefUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0 /f >nul 2>&1

echo Suppression des sous-cles Subscriptions et SuggestedApps pour l'utilisateur courant...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\Subscriptions" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SuggestedApps" /f >nul 2>&1

echo Suppression des sous-cles Subscriptions et SuggestedApps pour le profil par defaut...
reg delete "HKLM\DefUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\Subscriptions" /f >nul 2>&1
reg delete "HKLM\DefUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SuggestedApps" /f >nul 2>&1

echo Desactivation du contenu lie a l'etat du compte consommateur...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableConsumerAccountStateContent /t REG_DWORD /d 1 /f >nul 2>&1

echo Desactivation du contenu optimise pour le cloud...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableCloudOptimizedContent /t REG_DWORD /d 1 /f >nul 2>&1

echo Desactivation de PushToInstall (poussee d'installations sur le Store)
reg add "HKLM\SOFTWARE\Policies\Microsoft\PushToInstall" /v DisablePushToInstall /t REG_DWORD /d 1 /f >nul 2>&1

echo Parametrage de la telemetrie...

echo Desactivation de la telemetrie principale...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1 
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1

echo Desactivation de la publicite et collecte de donnees utilisateur (session en cours)...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Privacy" /v TailoredExperiencesWithDiagnosticDataEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" /v HasAccepted /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Input\TIPC" /v Enabled /t REG_DWORD /d 0 /f >nul 2>&1

echo Desactivation de la personnalisation basee sur la saisie (session en cours)...
reg add "HKCU\Software\Microsoft\InputPersonalization" /v RestrictImplicitInkCollection /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\InputPersonalization" /v RestrictImplicitTextCollection /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\InputPersonalization\TrainedDataStore" /v HarvestContacts /t REG_DWORD /d 0 /f >nul 2>&1

echo Refus de la politique de confidentialite personnalisee (session en cours)...
reg add "HKCU\Software\Microsoft\Personalization\Settings" /v AcceptedPrivacyPolicy /t REG_DWORD /d 0 /f >nul 2>&1

echo Desactivation de la publicite et collecte de donnees utilisateur (profil par defaut)...
reg add "HKLM\DefUser\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\DefUser\Software\Microsoft\Windows\CurrentVersion\Privacy" /v TailoredExperiencesWithDiagnosticDataEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\DefUser\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" /v HasAccepted /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\DefUser\Software\Microsoft\Input\TIPC" /v Enabled /t REG_DWORD /d 0 /f >nul 2>&1

echo Desactivation de la personnalisation basee sur la saisie (profil par defaut)...
reg add "HKLM\DefUser\Software\Microsoft\InputPersonalization" /v RestrictImplicitInkCollection /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\DefUser\Software\Microsoft\InputPersonalization" /v RestrictImplicitTextCollection /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\DefUser\Software\Microsoft\InputPersonalization\TrainedDataStore" /v HarvestContacts /t REG_DWORD /d 0 /f >nul 2>&1

echo Refus de la politique de confidentialite personnalisee (profil par defaut)...
reg add "HKLM\DefUser\Software\Microsoft\Personalization\Settings" /v AcceptedPrivacyPolicy /t REG_DWORD /d 0 /f >nul 2>&1

echo Application de strategies de groupe pour limiter la telemetrie...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v LimitEnhancedDiagnosticDataWindowsAnalytics /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v LimitDiagnosticLogCollection /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v LimitDumpCollection /t REG_DWORD /d 1 /f >nul 2>&1

echo Desactivation du reporting d'erreurs Windows envoye a Microsoft ...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v LoggingDisabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v DontSendAdditionalData /t REG_DWORD /d 1 /f >nul 2>&1

echo Desactivation et arret du service de telemetrie 'DiagTrack'...
sc config "DiagTrack" start=disabled >nul 2>&1
sc stop "DiagTrack" >nul 2>&1

echo Desactivation et arret des services de telemetrie...
sc config "DiagTrack" start=disabled >nul 2>&1
sc stop "DiagTrack" >nul 2>&1
sc stop dmwappushservice >nul 2>&1
sc config dmwappushservice start=disabled >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice" /v Start /t REG_DWORD /d 4 /f >nul 2>&1
echo "" > %ProgramData%\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl >nul 2>&1

echo Desactivation avancee de la telemetrie et tracking...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v MaxTelemetryAllowed /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v AITEnable /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v DisableInventory /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v DisableUAR /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /v CEIPEnable /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /v CEIPEnable /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v DisabledByGroupPolicy /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /v PreventDeviceMetadataFromNetwork /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v DontReportInfectionInformation /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\TabletPC" /v PreventHandwritingDataSharing /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\TextInput" /v AllowLinguisticDataCollection /t REG_DWORD /d 0 /f >nul 2>&1

echo Desactivation de Windows Spotlight features...
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsSpotlightFeatures /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKU\.DEFAULT\Software\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsSpotlightFeatures /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsSpotlightWindowsWelcomeExperience /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKU\.DEFAULT\Software\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsSpotlightWindowsWelcomeExperience /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsSpotlightOnActionCenter /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKU\.DEFAULT\Software\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsSpotlightOnActionCenter /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsSpotlightOnSettings /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKU\.DEFAULT\Software\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsSpotlightOnSettings /t REG_DWORD /d 1 /f >nul 2>&1

echo Desactivation de Bing in Start Menu...
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v ShowRunAsDifferentUserInStart /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v DisableSearchBoxSuggestions /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\DefUser\Software\Policies\Microsoft\Windows\Explorer" /v ShowRunAsDifferentUserInStart /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\DefUser\Software\Policies\Microsoft\Windows\Explorer" /v DisableSearchBoxSuggestions /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v ConnectedSearchUseWebOverMeteredConnections /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v DisableWebSearch /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v ConnectedSearchUseWeb /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v CortanaConsent /t REG_DWORD /d 0 /f >nul 2>&1 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v BingSearchEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v AllowSearchToUseLocation /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\DefUser\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v CortanaConsent /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\DefUser\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v BingSearchEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\DefUser\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v AllowSearchToUseLocation /t REG_DWORD /d 0 /f >nul 2>&1

echo Deleting Application Compatibility Appraiser...
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{0600DD45-FAF2-4131-A006-0B17509B9F78}" /f >nul 2>&1

echo Deleting Customer Experience Improvement Program...
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{4738DE7A-BCC1-4E2D-B1B0-CADB044BFA81}" /f >nul 2>&1
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{6FAC31FA-4A85-4E64-BFD5-2154FF4594B3}" /f >nul 2>&1
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{FC931F16-B50A-472E-B061-B6F79A71EF59}" /f >nul 2>&1

echo Desactivation des taches planifiees de telemetrie...
schtasks /Change /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Chkdsk\Proxy" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Windows Error Reporting\QueueReporting" /Disable >nul 2>&1

echo Desactivation de .NET Optimization Service (NGEN)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CI\NGEN" /v "C:\Windows\Microsoft.NET\Framework\v4.0.30319\mscorsvw.exe" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CI\NGEN" /v "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\mscorsvw.exe" /t REG_DWORD /d 0 /f >nul 2>&1

echo Desactivation de NVMe Perf Throttling...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Classpnp" /v NVMeDisablePerfThrottling /t REG_DWORD /d 1 /f >nul 2>&1

echo Desactivation de FTH (Fault Tolerant Heap)...
reg add "HKLM\SOFTWARE\Microsoft\FTH" /v Enabled /t REG_DWORD /d 0 /f >nul 2>&1

echo Supression de Galerie du nav panel de l'explorateur de fichier...
reg add "HKCU\Software\Classes\CLSID\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}" /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\DefUser\Software\Classes\CLSID\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}" /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 0 /f >nul 2>&1
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}" /f >nul 2>&1

echo Supression de Accueil du nav panel de l'explorateur de fichier...
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{f874310e-b6b7-47dc-bc84-b9e6b38f5903}" /f >nul 2>&1

echo Desactivation de SysMain... 
sc config "SysMain" start=disabled >nul 2>&1
sc stop SysMain >nul 2>&1

echo Desactivation de DPS... 
sc config "DPS" start=disabled >nul 2>&1
sc stop DPS >nul 2>&1

echo Desactivation de FontCache... 
sc config "FontCache" start=disabled >nul 2>&1
sc stop FontCache >nul 2>&1

echo Desactivation de WerSvc... 
sc config "WerSvc" start=disabled >nul 2>&1
sc stop WerSvc >nul 2>&1

echo Desactivation services bloatware supplementaires...
sc config "RetailDemo" start=disabled >nul 2>&1
sc config "wisvc" start=disabled >nul 2>&1
sc config "PcaSvc" start=disabled >nul 2>&1
sc config "TabletInputService" start=disabled >nul 2>&1
sc config "SyncCenter" start=disabled >nul 2>&1
sc config "Fax" start=disabled >nul 2>&1
sc config "MapsBroker" start=disabled >nul 2>&1
sc config "RemoteRegistry" start=disabled >nul 2>&1
sc config "WbioSrvc" start=disabled >nul 2>&1
sc stop PcaSvc >nul 2>&1
sc stop wisvc >nul 2>&1
sc stop SyncCenter >nul 2>&1
sc stop Fax >nul 2>&1
sc stop MapsBroker >nul 2>&1
sc stop RemoteRegistry >nul 2>&1
sc stop WbioSrvc >nul 2>&1

echo Application de SvcHostSplit pour reduire le nombre de SvcHost...
for /f "tokens=*" %%p in ('powershell -NoProfile -Command "& {(Get-CimInstance -ClassName Win32_OperatingSystem).TotalVisibleMemorySize}"') do (
    set m=%%p
    goto :done
)
:done
set "HEX=%m%"

set /A DEC=0x%HEX%

reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v SvcHostSplitThresholdInKB /t REG_DWORD /d "%DEC%" /f >nul 2>&1	

echo Changement des priorite CPU du Scheduler...
reg add "HKLM\SYSTEM\ControlSet001\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 38 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "ForegroundBoost" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "ThreadBoostType" /t REG_DWORD /d "2" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "ThreadSchedulingModel" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "AdjustDpcThreshold" /t REG_DWORD /d "800" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "DeepIoCoalescingEnabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "IdealDpcRate" /t REG_DWORD /d "800" /f >nul 2>&1

echo Reduction des interruptions pour sauver CPU cycles...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v DistributeTimers /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v GlobalTimerResolutionRequests /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v MaxDynamicTickDuration /t REG_DWORD /d 10 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v MinimumDpcRate /t REG_DWORD /d 1 /f >nul 2>&1

echo Desactivation des animations inutiles qui consomment CPU...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "SchedulerAssistThreadFlagOverride" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" /v "LowLatencyMode" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Executive" /v "EnableGroupAwareScheduling" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "EnablePriorityBoost" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "ThreadPrioritization" /t REG_DWORD /d 255 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Executive" /v "RealTimePriorityBoost" /t REG_DWORD /d 1 /f >nul 2>&1

echo Kernel Tweaks...
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MaxDynamicTickDuration" /t REG_DWORD /d "10" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MaximumSharedReadyQueueSize" /t REG_DWORD /d "128" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "BufferSize" /t REG_DWORD /d "32" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "IoQueueWorkItem" /t REG_DWORD /d "32" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "IoQueueWorkItemToNode" /t REG_DWORD /d "32" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "IoQueueWorkItemEx" /t REG_DWORD /d "32" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "IoQueueThreadIrp" /t REG_DWORD /d "32" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "ExTryQueueWorkItem" /t REG_DWORD /d "32" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "ExQueueWorkItem" /t REG_DWORD /d "32" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "IoEnqueueIrp" /t REG_DWORD /d "32" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "XMMIZeroingEnable" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "UseNormalStack" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "UseNewEaBuffering" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "StackSubSystemStackSize" /t REG_DWORD /d "65536" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v DpcWatchdogProfileOffset /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v DpcTimeout /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v IdealDpcRate /t REG_DWORD /d 1 /f >nul 2>&1 
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v MaximumDpcQueueDepth /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v MinimumDpcRate /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v DpcWatchdogPeriod /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v ThreadDpcEnable /t REG_DWORD /d 0 /f >nul 2>&1

REM echo Set Print Spooler to Manual...
REM sc config "Spooler" start=demand >nul 2>&1
REM sc stop "Spooler" >nul 2>&1

echo Direct3D Tweaks...
Reg add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "FullDebug" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "DisableDM" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "EnableMultimonDebugging" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "LoadDebugRuntime" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "DisableMMX" /t REG_DWORD /d "0" /f >nul 2>&1

echo Desactivation des animations et effets visuels pour performances...
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\DWM" /v AlwaysHibernateThumbnails /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\DefUser\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKLM\DefUser\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul 2>&1

echo Optimisation GPU et gestion energie...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v EnablePreemption /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v PowerThrottlingOff /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v HibernateEnabledDefault /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v CsEnabled /t REG_DWORD /d 0 /f >nul 2>&1

echo Desactivation des services de localisation et capteurs...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v DisableLocation /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v DisableWindowsLocationProvider /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v DisableLocationScripting /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v DisableSensors /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\lfsvc" /v Start /t REG_DWORD /d 4 /f >nul 2>&1

echo Desactivation de Activity History et Timeline...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableActivityFeed /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v PublishUserActivities /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v UploadUserActivities /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowTaskViewButton /t REG_DWORD /d 0 /f >nul 2>&1

echo Applying SystemProfile MMCSS Tweaks.
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d "10" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NoLazyMode" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "AlwaysOn" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Affinity" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 31 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Background Only" /t REG_SZ /d "False" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Latency Sensitive" /t REG_SZ /d "False" /f >nul 2>&1

echo Applying IRQ Priority Tweaks...
:: DirectX Graphics Kernel - Highest priority
reg add "HKLM\SYSTEM\CurrentControlSet\services\DXGKrnl\Parameters" /v "ThreadPriority" /t REG_DWORD /d 15 /f >nul 2>&1
:: Nvidia GPU Driver - Highest priority
reg add "HKLM\SYSTEM\CurrentControlSet\services\nvlddmkm\Parameters" /v "ThreadPriority" /t REG_DWORD /d 15 /f >nul 2>&1
:: AMD GPU Driver - Highest priority
reg add "HKLM\SYSTEM\CurrentControlSet\services\atikmdag\Parameters" /v "ThreadPriority" /t REG_DWORD /d 15 /f >nul 2>&1
:: USB 3 HUB Driver - Lowest priority
reg add "HKLM\SYSTEM\CurrentControlSet\services\USBHUB3\Parameters" /v "ThreadPriority" /t REG_DWORD /d 1 /f >nul 2>&1
:: USB xHCI Host Controller - Lowest priority
reg add "HKLM\SYSTEM\CurrentControlSet\services\USBXHCI\Parameters" /v "ThreadPriority" /t REG_DWORD /d 1 /f >nul 2>&1
:: High Definition Audio (HDAudBus) - Lowest priority
reg add "HKLM\SYSTEM\CurrentControlSet\services\HDAudBus\Parameters" /v "ThreadPriority" /t REG_DWORD /d 1 /f >nul 2>&1
:: USB Audio Class Driver (USBAudio) - Lowest priority
reg add "HKLM\SYSTEM\CurrentControlSet\services\USBAudio\Parameters" /v "ThreadPriority" /t REG_DWORD /d 1 /f >nul 2>&1

echo Activation de FSE (Fullscreen Exclusive)
reg add "HKCU\System\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v "GameDVR_DXGIHonorFSEWindowsCompatible" /t REG_DWORD /d 1 /f >nul 2>&1

echo Activation de Windowed Game Optimizations
REG ADD "HKEY_CURRENT_USER\Software\Microsoft\DirectX\GraphicsSettings" /v "SwapEffectUpgradeCache" /t REG_DWORD /d 1 /f >nul 2>&1
REG ADD "HKEY_CURRENT_USER\Software\Microsoft\DirectX\UserGpuPreferences" /v "DirectXUserGlobalSettings" /t REG_SZ /d "SwapEffectUpgradeEnable=1;" /f >nul 2>&1

echo Activation de Verbose...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v verbosestatus /t REG_DWORD /d 1 /f >nul 2>&1

echo Suppression de NDU (Network Monitoring Servides)
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Ndu" /f >nul 2>&1

echo Executive Tweak
REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Executive" /v AdditionalCriticalWorkerThreads /t REG_DWORD /d "%NUMBER_OF_PROCESSORS%" /f >nul 2>&1
REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Executive" /v AdditionalDelayedWorkerThreads /t REG_DWORD /d "%NUMBER_OF_PROCESSORS%" /f >nul 2>&1

echo Application de WLAN Tweaks...
reg add "HKLM\SOFTWARE\Microsoft\Wlansvc" /v L2NAWLANMode /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Wlansvc" /v AllowAPMode /t REG_BINARY /d 01000000 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Wlansvc" /v DisableBackgroundScanOptimization /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Wlansvc" /v ShowDeniedNetworks /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Wlansvc" /v AllowVirtualStationExtensibility /t REG_DWORD /d 0 /f >nul 2>&1

echo Desactivation de Nagle Algorithm pour reduire la latence reseau...
for /f "tokens=*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" ^| findstr "HKEY"') do (
    reg add "%%a" /v TcpAckFrequency /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "%%a" /v TcpNoDelay /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "%%a" /v TCPDelAckTicks /t REG_DWORD /d 0 /f >nul 2>&1
)

echo Optimisation TCP/IP pour le gaming et streaming...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v DefaultTTL /t REG_DWORD /d 64 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpWindowSize /t REG_DWORD /d 65535 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v Tcp1323Opts /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v MTU /t REG_DWORD /d 1500 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v MSS /t REG_DWORD /d 1460 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpMaxDupAcks /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpTimedWaitDelay /t REG_DWORD /d 30 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v GlobalMaxTcpWindowSize /t REG_DWORD /d 65535 /f >nul 2>&1

echo Desactivation du QoS Packet Scheduler...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v NonBestEffortLimit /t REG_DWORD /d 0 /f >nul 2>&1
for /f "tokens=*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" ^| findstr "HKEY"') do (
    reg add "%%a" /v DisableTaskOffload /t REG_DWORD /d 0 /f >nul 2>&1
)

echo SerializeTimerExpiration Tweaks
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" /v SerializeTimerExpiration /t REG_DWORD /d 1 /f >nul 2>&1

echo Interrupt Steering Tweaks
REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "InterruptSteeringMode" /t REG_DWORD /d 1 /f >nul 2>&1
REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "InterruptSteeringTargetProc" /t REG_DWORD /d 1 /f >nul 2>&1

echo Application de Disk Tweaks...
fsutil behavior set disableLastAccess 1 >NUL 2>nul
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d "0" /f >NUL 2>nul
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableSuperfetch" /t REG_DWORD /d "0" /f >NUL 2>nul
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableBoottrace" /t REG_DWORD /d "0" /f >NUL 2>nul
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "SfTracingState" /t REG_DWORD /d "0" /f >NUL 2>nul

echo Activation de LargeSystemCache... 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 1 /f >nul 2>&1

echo Modification des tailles de pool memoire...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v NonPagedPoolSize /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v PagedPoolSize /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v SecondLevelDataCache /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v SessionPoolSize /t REG_DWORD /d 4 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v SessionViewSize /t REG_DWORD /d 48 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v SystemPages /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v ClearPageFileAtShutdown /t REG_DWORD /d 0 /f >nul 2>&1

echo Desactivation des Audio Enhancements systeme...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render" /v DisableProtectedAudioDG /t REG_DWORD /d 1 /f >nul 2>&1
for /f "delims=" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render"') do (
    reg add "%%a\Properties" /v "{1da5d803-d492-4edd-8c23-e0c0ffee7f0e},0" /t REG_DWORD /d 1 /f >nul 2>&1
)

echo Optimisation du buffer audio pour latence minimale / Disk Tweaks...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Audiosrv" /v DependOnService /t REG_MULTI_SZ /d "AudioEndpointBuilder\0RpcSs" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Latency Sensitive" /t REG_SZ /d "True" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "NoLazyMode" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\stornvme\Parameters" /v "QueueDepth" /t REG_DWORD /d "64" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\stornvme\Parameters" /v "NvmeMaxReadSplit" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\stornvme\Parameters" /v "NvmeMaxWriteSplit" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\stornvme\Parameters" /v "ForceFlush" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\stornvme\Parameters" /v "ImmediateData" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\stornvme\Parameters" /v "MaxSegmentsPerCommand" /t REG_DWORD /d "256" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\stornvme\Parameters" /v "MaxOutstandingCmds" /t REG_DWORD /d "256" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\stornvme\Parameters" /v "ForceEagerWrites" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\stornvme\Parameters" /v "MaxQueuedCommands" /t REG_DWORD /d "256" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\stornvme\Parameters" /v "MaxOutstandingIORequests" /t REG_DWORD /d "256" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\stornvme\Parameters" /v "NumberOfRequests" /t REG_DWORD /d "1500" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\stornvme\Parameters" /v "IoSubmissionQueueCount" /t REG_DWORD /d "3" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\stornvme\Parameters" /v "IoQueueDepth" /t REG_DWORD /d "64" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\stornvme\Parameters" /v "HostMemoryBufferBytes" /t REG_DWORD /d "1500" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\stornvme\Parameters" /v "ArbitrationBurst" /t REG_DWORD /d "256" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\StorNVMe\Parameters\Device" /v "QueueDepth" /t REG_DWORD /d "64" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\StorNVMe\Parameters\Device" /v "NvmeMaxReadSplit" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\StorNVMe\Parameters\Device" /v "NvmeMaxWriteSplit" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\StorNVMe\Parameters\Device" /v "ForceFlush" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\StorNVMe\Parameters\Device" /v "ImmediateData" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\StorNVMe\Parameters\Device" /v "MaxSegmentsPerCommand" /t REG_DWORD /d "256" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\StorNVMe\Parameters\Device" /v "MaxOutstandingCmds" /t REG_DWORD /d "256" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\StorNVMe\Parameters\Device" /v "ForceEagerWrites" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\StorNVMe\Parameters\Device" /v "MaxQueuedCommands" /t REG_DWORD /d "256" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\StorNVMe\Parameters\Device" /v "MaxOutstandingIORequests" /t REG_DWORD /d "256" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\StorNVMe\Parameters\Device" /v "NumberOfRequests" /t REG_DWORD /d "1500" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\StorNVMe\Parameters\Device" /v "IoSubmissionQueueCount" /t REG_DWORD /d "3" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\StorNVMe\Parameters\Device" /v "IoQueueDepth" /t REG_DWORD /d "64" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\StorNVMe\Parameters\Device" /v "HostMemoryBufferBytes" /t REG_DWORD /d "1500" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\StorNVMe\Parameters\Device" /v "ArbitrationBurst" /t REG_DWORD /d "256" /f >nul 2>&1
fsutil behavior set memoryusage 2 >NUL 2>nul
fsutil behavior set mftzone 2 >NUL 2>nul
fsutil behavior set disabledeletenotify 0 >NUL 2>nul
fsutil behavior set encryptpagingfile 0 >NUL 2>nul
fsutil behavior set disable8dot3 1 >NUL 2>nul
call :ControlSet "Control\FileSystem" "NtfsDisable8dot3NameCreation" "1"
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v ClearPageFileAtShutdown /t REG_DWORD /d 0 /f >nul 2>&1

fsutil behavior set disablecompression 1 >nul

wmic logicaldisk where "DriveType='3' and DeviceID='%systemdrive%'" get DeviceID 2>&1 | find "%systemdrive%" >nul && set "storageType=SSD" || set "storageType=HDD"

if "%storageType%" equ "SSD" (
    fsutil behavior set disableLastAccess 0
    call :ControlSet "Control\FileSystem" "NtfsDisableLastAccessUpdate" "2147483648"
) >nul

if "%storageType%" equ "HDD" (
    fsutil behavior set disableLastAccess 1
    call :ControlSet "Control\FileSystem" "NtfsDisableLastAccessUpdate" "2147483649"
) >nul

goto :EOF

:ControlSet
rem Set registry key values
rem Parameters: %1 - registry path, %2 - key name, %3 - key value
reg add "HKLM\SYSTEM\CurrentControlSet\%1" /v %2 /t REG_DWORD /d %3 /f 


echo Desactivation de Hibernate pour liberer de la place (hiberfil.sys)...
powercfg -h off >nul 2>&1
powercfg -h on >nul 2>&1

echo Activation de Fast Startup...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "EnableFastStartup" /t REG_DWORD /d "1" /f >nul 2>&1

echo Application de Boot Tweaks... (Speed up the Winlogon)
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "DelayedDesktopSwitchTimeout" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "StartupDelayInMSec" /t REG_SZ /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "RunStartupScriptSync" /t REG_DWORD /d "0" /f >nul 2>&1
bcdedit /set bootmenupolicy legacy >nul 2>&1
bcdedit /timeout 3 >nul 2>&1
Reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKLM\DefUser\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f >nul 2>&1
reg add HKLM\System\CurrentControlSet\Control\Processor /v Capabilities /t REG_DWORD /d 0x0007e066 /f >nul 2>&1

echo Application de Shutdown Tweaks... (Speed up the Shutdown)
Reg add "HKCU\Control Panel\Desktop" /v "WaitToKillAppTimeout" /t REG_SZ /d "2000" /f >nul 2>&1
reg add "HKLM\DefUser\Control Panel\Desktop" /v "WaitToKillAppTimeout" /t REG_SZ /d "2000" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Control" /v "WaitToKillServiceTimeout" /t REG_SZ /d "2000" /f >nul 2>&1
Reg add "HKCU\Control Panel\Desktop" /v "AutoEndTasks" /t REG_SZ /d "1" /f >nul 2>&1
reg add "HKLM\DefUser\Control Panel\Desktop" /v "AutoEndTasks" /t REG_SZ /d "1" /f >nul 2>&1
Reg add "HKCU\Control Panel\Desktop" /v "HungAppTimeout" /t REG_SZ /d "2000" /f >nul 2>&1
reg add "HKLM\DefUser\Control Panel\Desktop" /v "HungAppTimeout" /t REG_SZ /d "2000" /f >nul 2>&1

echo Activation de Ultimate Performance Plan... 
powercfg /duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 99999999-9999-9999-9999-999999999999 >nul 2>&1
powercfg /SETACTIVE 99999999-9999-9999-9999-999999999999 >nul 2>&1

echo Desactivation de MemoryCompression... (Reduce CPU Usage)
PowerShell -Command "Disable-MMAgent -MemoryCompression" >nul 2>&1
PowerShell -Command "Disable-MMAgent -PageCombining" >nul 2>&1

echo Desactivation de ReservedStorage WinSxS...
dism /Online /Set-ReservedStorageState /State:Disabled >nul 2>&1

echo Nettoyage de WinSxS...
Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase >nul 2>&1
Dism.exe /online /Cleanup-Image /SPSuperseded >nul 2>&1

echo Nettoyage...
cleanmgr /sagerun:50 >nul 2>&1

echo Remove C:\Program Files (x86)\Microsoft\EdgeUpdate...
takeown /f "C:\Program Files (x86)\Microsoft\EdgeUpdate" /r >nul 2>&1
rmdir /q /s "C:\Program Files (x86)\Microsoft\EdgeUpdate" >nul 2>&1


echo Supression du dossier temporaire C:\Perflogs...
rmdir /q /s "C:\Perflogs" >nul 2>&1

echo Remove %APPDATA%\Edge Folder...
rmdir /q /s "%LOCALAPPDATA%\Microsoft\Edge\" >nul 2>&1

echo Supression des fichiers temporaires...
del /q /f /s %TEMP%\* >nul 2>&1
del /q /f /s C:\Windows\Temp\* >nul 2>&1
del /q /f /s C:\Users\%USERNAME%\AppData\Local\Temp\* >nul 2>&1

echo Supression des Logs...
del /f /q C:\Windows\System32\winevt\Logs\* >nul 2>&1

echo Application des Tweaks pour skip OOBE (Pour utiliser le script depuis OOBE)...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" /v BypassNRO /t REG_DWORD /d 1 /f >nul 2>&1
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE /v DisableVoice /t REG_DWORD /d 1 /f >nul 2>&1
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE /v HideEULAPage /t REG_DWORD /d 1 /f >nul 2>&1
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE /v HideOEMRegistrationScreen /t REG_DWORD /d 1 /f >nul 2>&1
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE /v HideOnlineAccountScreens /t REG_DWORD /d 1 /f >nul 2>&1
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE /v HideWirelessSetupInOOBE /t REG_DWORD /d 1 /f >nul 2>&1
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE /v ProtectYourPC /t REG_DWORD /d 3 /f >nul 2>&1
REM reg add HKEY_LOCAL_MACHINE\SYSTEM\Setup /v OOBEInProgress /t REG_DWORD /d 0 /f >nul 2>&1
REM reg add HKEY_LOCAL_MACHINE\SYSTEM\Setup /v OOBEInProgressDriverUpdatesPostponed /t REG_DWORD /d 0 /f >nul 2>&1
REM reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE /v LaunchUserOOBE /f >nul 2>&1
REM reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE /v DefaultAccountAction /f >nul 2>&1
REM reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE /v RecoveryOOBEEnabled /f >nul 2>&1
REM reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE /v DefaultAccountSAMName /f >nul 2>&1
REM reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE /v DefaultAccountSID /f >nul 2>&1
REM net user /del defaultuser0 >nul 2>&1
REM net user Administrateur /active:yes

echo Installation de WinMemoryCleaner pour clear /ModifiedPageList /ProcessesWorkingSet /StandbyList /SystemWorkingSet ...
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/IgorMundstein/WinMemoryCleaner/releases/download/2.8/WinMemoryCleaner.exe' -OutFile '%SYSTEMDRIVE%\WinMemoryCleaner.exe'" >nul 2>&1
C:\WinMemoryCleaner.exe /ModifiedPageList /ProcessesWorkingSet /StandbyList /SystemWorkingSet >nul 2>&1
copy /y startup.vbs "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\startup.vbs" >nul 2>&1
mkdir "C:\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" >nul 2>&1
copy /y startup.vbs "C:\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\startup.vbs" >nul 2>&1
copy /y startup.vbs "\Microsoft\Windows\Start Menu\Programs\Startup\startup.vbs" >nul 2>&1
copy /y TASK.vbs "\Microsoft\Windows\Start Menu\Programs\Startup\TASK.vbs" >nul 2>&1
copy /y startup.bat "C:\Startup.bat" >nul 2>&1
copy /y TASK.bat "C:\TASK.bat" >nul 2>&1

echo Decharger la ruche...
reg unload "HKLM\DefUser" >nul 2>&1

echo Redemarrer le PC avec shutdown /t 0 /r
pause
shutdown /t 0 /r >nul 2>&1
