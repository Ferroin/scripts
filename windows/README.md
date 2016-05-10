# Overview
This folder contains a couple of windows specific PowerShell scripts,
and some registry hacks.  The PowerShell scripts are designed for and
only tested on Windows 10.  The registry hacks should apply cleanly on
any Windows system, but most only work as advertised on 10.

# List of current files
## registry
This directory contains all the registry edits I use regularly, check
the README file there for more info on each.

## uninstall-onedrive.ps1
This script will uninstall OneDrive.  You will also need to apply
registry/disable-one-drive.reg to hide it in the file manager.  Sadly,
this will need to be re-run each time you update to a new build of
Windows 10, as I have yet to figure out how to prevent the update from
re-installing OneDrive.
