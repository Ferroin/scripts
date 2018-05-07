# Overview
This folder contains a couple of files for making specific modifications
to the Windows Registry.  I only have ones to add the changes, not remove
them, as I don't usually need to remove them on my systems, and it's
not hard to figure out what to change if you look at the files themselves.

# List of current files
## disable-auto-app-install.reg
This will disable the 'App Discovery' function in Windows 10.
This particular bit of malware (which Microsoft calls a feature) will
randomly install top rated apps from the Windows Store, even if the
Windows Store is not available on the system.  Technically, you can
disable this manually by switching off 'Suggestions' in the Start menu
settings, but this instead completely disables it and prevents it from
being turned on in the settings app.  This also disables the display of
'suggested' conent in the Settings app, and the mechanisms used to
pre-load third-party apps when you install or upgrade Windows.

## disable-fast-boot.reg
This disables 'Fast Boot' on Windows 8, 8.1, and 10.  This feature doesn't
work on some older hardware (the symptom is that your computer doesn't
shut down when you tell it to unless you run 'stop-computer' from an
administrative powershell session).  It can also interfere with UEFI
based multi-boot configurations involving OS'es that don't support it
(which is everything except the above mentioned Windows versions).

## disable-one-drive.reg
This will prevent OneDrive from being shown in the File Explorer side-pane.
To actually uninstall OneDrive, check uninstall-onedrive.ps1 from the
next directory up.

## rtc-is-utc.reg
This makes Windows treat the hardware RTC as if it's set to UTC instead
of the local timezone.  This is particularly useful if you are dual
booting with almost any other OS in existence (especially UNIX-like
ones), as Windows is the only widely used OS that expects the RTC to
be set to the local timezone.  It can also prevent issues on laptops
which are set to automatically set the timezone when traveling between
timezones while the system is off.

## user-tcp-qos.reg
This overrides the default behavior in Windows 7 and newer of blatantly
ignoring application's attempts to set the QoS on their network traffic.
It's probably not hugely useful for most people, but it can improve
networking behavior when you have a good ISP who actually honors the DSCP
fields in IP headers (sadly a decent percentage of them don't appear to).
I find that this can improve network latency while you are streaming in
the background or doing big transfers of data.
