# Overview
This is a somewhat random collection of scripts that I've written.
Most of these are either small enough or domain-specific enough not to
warrant their own repository.

In general, the shell scripts should work as-is on almost any Linux
system, and might work on other UNIX derivates.  Anything not written
in shell script has no dependencies outside of the standard library for
the language it is written in, unless otherwise noted.

Everything in this repository is licensed undeer a modified BSD license,
check LICENSE for details.

# Contents
## cp.sh
This is a simple script to copy a file, it works like traditional cp,
but has a much smaller memory footprint that GNU cp, and provides a nice
progress indicator.  I use this as part of my kernel crash-dump setup
on Linux systems.

## gen-ucode-cpio
A simple script to generate a microcode archive for Xen or Linux.
It requires your CPU microcode to be installed already.

## getkeys.sh
Simple script to get keystrokes from a input device on Linux.  Needs
'input-events' from the input-tools package.  This was originally written
as a trivial debugging aid, but I found it to be useful for dealing with
things that claim to be keyboards but really aren't (like some barcode
scanners, and a lot of USB connected industrial sensor devices).

## secure-boot/
A couple of scripts to simplify setting up UEFI Secure Boot.  sb-init.sh
sets up a basic directory structure, copies out the current system
keys, and then generates new ones that can be used to sign things
locally. sb-install.sh must be run from Secure Boot Setup Mode,
and installs the keys generated by sb-init.sh alongside the ones it
copied out.  The general idea here is to circumvent Secure Boot while
still allowing usage of existing software (I wrote them so I could get
Linux booting under Secure Boot, and still boot Windows, and not have
to re-sign the WIndows loader every time Windows decided to update it).

## win-reg
A couple of specific registry changes for Windows, check the README in
that directory for specifics.

## wfdps.py
This is a Python script for computing damage-per-second for weapons in
first-person shooters.  It was originally written with the stat system
from Warframe in mind, but it should work with only minor changes needed
for many other games (for example, it works perfectly for the games in
the Borderlands series).  Written mostly as a proof of concept, and to
show one of my friends how much of a small program is often dedicated
simply to control-flow logic and configuration parsing.
