@echo off 
powershell -Command "Stop-Process -Name wmiprvse -ErrorAction SilentlyContinue -Force"
taskkill /f /im MoUsoCoreWorker.exe
taskkill /f /im sppsvc.exe
taskkill /f /im TiWorker.exe
taskkill /f /im ApplicationFrameHost.exe
powershell -Command "Stop-Process -Name wmiprvse -ErrorAction SilentlyContinue -Force"
taskkill /f /im MoUsoCoreWorker.exe
taskkill /f /im sppsvc.exe
taskkill /f /im TiWorker.exe
taskkill /f /im ApplicationFrameHost.exe
taskkill /f /im mobsync.exe
taskkill /f /im userinit.exe
powershell -Command "Stop-Process -Name wmiprvse -ErrorAction SilentlyContinue -Force"
taskkill /f /im TrustedInstaller.exe
taskkill /f /im SettingSyncHost.exe
taskkill /f /im WmiPrvSE.exe
taskkill /f /im dasHost.exe
taskkill /f /im wlanext.exe
taskkill /f /im sppsvc.exe
taskkill /f /im sppsvc.exe
taskkill /f /im DWMBlurGlass.exe
taskkill /f /im msiexec.exe
taskkill /f /im MSIAfterburner.exe
taskkill /IM wmiprvse.exe /F /T
taskkill /IM TrustedInstaller.exe /F /T
taskkill /IM GamingServices.exe /F /T
taskkill /IM GamingServicesNet.exe /F /T
taskkill /IM WindowsPackageManagerServer.exe /F /T
taskkill /IM sppsvc.exe /F /T
taskkill /IM TiWorker.exe /F /T
taskkill /IM VSSVC.exe /F /T
taskkill /IM MoUsoCoreWorker.exe /F /T
taskkill /IM StoreDesktopExtension.exe /F /T
taskkill /IM WinStore.App.exe /F /T
taskkill /IM MusNotification.exe /F /T
taskkill /IM GamingServices.exe /F /T
taskkill /IM EABackgroundService.exe /F /T
taskkill /IM DataExchangeHost.exe /F /T
taskkill /IM mobsync.exe /F /T
net stop sppsvc
net stop DusmSvc
net stop RmSvc
net stop msiserver
taskkill /f /im taskhostw.exe
taskkill /f /im TiWorker.exe
taskkill /f /im msiexec.exe
taskkill /f /im dllhost.exe
taskkill /f /im rundll32.exe