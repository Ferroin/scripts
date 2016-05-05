# Overview
This folder contains a couple of files for making specific modifications
to the Windows Registry.  I only have ones to add the changes, not remove
them, as I don't usually need to remove them on my systems, and it's
not hard to figure out what to change if you look at the files themselves.

# List of current files
## disable-fast-boot.reg
This disables 'Fast Boot' on Windows 8, 8.1, and 10.  This feature
doesn't work on some older hardware (the symptom is that your computer
doesn't shut down when you tell it to unless you run 'stop-computer'
from an administrative powershell session).  It can also interfere
with multi-boot setups involving OS'es that don't support it (which is
everything except the above mentioned Windows versions).

## rtc-is-utc.reg
This makes Windows treat the hardware RTC as if it's set to UTC instead
of the local timezone.  This is particularly useful if you are dual
booting with almost any other OS in existence (especially UNIX-like
ones), as Windows is about the only OS that expects the RTC to be set
to the local timezone.  It can also prevent issues on laptops which are
set to automatically set the timezone when traveling between timezones
while the system is off.

## user-tcp-qos.reg
This overrides the default behavior in Windows 7 and newer of blatantly
ignoring application's attempts to set the QoS on their network traffic.
It's probably not hugely useful for most people, but it can improve
networking behavior when you have a good ISP who actually honors the
DSCP fields in IP headers (sadly a decent percentage of them don't).
