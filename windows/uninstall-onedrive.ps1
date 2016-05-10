taskkill /f /im OneDrive.exe
if ($ENV:PROCESSOR_ARCHITECTURE -eq "AMD64")
{
    %SystemRoot%/SysWOW64/OneDriveSetup.exe /uninstall
}
else
{
    %SystemRoot%\System32\OneDriveSetup.exe /uninstall
}
