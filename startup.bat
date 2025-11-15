@echo off
taskkill /f /im MSIAfterburner.exe >nul 2>&1
taskkill /f /im RTSS.exe >nul 2>&1
taskkill /f /im EncoderServer.exe >nul 2>&1
taskkill /f /im RTSSHooksLoader64.exe >nul 2>&1
timeout /t 1 >nul 2>&1
C:\WinMemoryCleaner.exe /ModifiedPageList /CombinedPageList /ModifiedFileCache /ProcessesWorkingSet /RegistryCache /StandbyList /SystemWorkingSet /SystemFileCache /WorkingSet >nul 2>&1
C:\WinMemoryCleaner.exe /ModifiedPageList /CombinedPageList /ModifiedFileCache /ProcessesWorkingSet /RegistryCache /StandbyList /SystemWorkingSet /SystemFileCache /WorkingSet >nul 2>&1


