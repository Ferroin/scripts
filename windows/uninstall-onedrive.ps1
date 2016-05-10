taskkill /f /im OneDrive.exe
if ($ENV:PROCESSOR_ARCHITECTURE -eq "AMD64")
{
    C:\Windows\SysWOW64\OneDriveSetup.exe /uninstall
}
else
{
    C:\Windows\System32\OneDriveSetup.exe /uninstall
}
