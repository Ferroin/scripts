# Overvies
This contains a handful of scripts written for UNIX like systems.
They were all orginally written on Linux, but are generally vaild POSIX
shell scripts.  Any specific dependencies are noted in the description
of the script.

# List of current files
## cp.sh
A dead simple shell based implementation of the traditional cp utility.
This came about due to a need for something that had a small memory
footprint to be used for copying kernel crashdumps to disk before
rebooting.  Somewhat interestingly, it has a smaller memory footprint than
both GNU cp and GNU dd when copying files larger than a few MB in size.
It also has a nice progress indicator showing how many blocks have been
copied out of the total.  Preforms the copy in 1MB chunks.  The progress
indicator only displays correctly on an ANSI compatible terminal (which is
almost all modern terminal emulators and most virtual terminal devices).
Has no dependencies beyond the standard UNIX utilities.

## gen-ucode-cpio
This is a really simple script to generate a CPIO archive of processor
microcode in the format expected by both Xen and Linux's early microcode
loader on x86.  It requires that you have the microcode installed in
/lib/firmware where Linux expects to find it.  If you don't, you'll just
get an empty CPIO archive.  Uses a sub-directory of the CWD for staging,
and cleans up after it's done.

## getkeys.sh
This script is Linux specific.  It returns a string of keys pressed
on a given input device, and exits after a set time of no activity.
This was originally written to handle a USB connected dial indicator
that identified as a keyboard, but it works just as well for pretty
much any other similar fake keyboard.  Because of how it works, things
that return control keycodes will probably not work as expected and may
need post-processing.  Depends on 'input-events' from the input-tools
package.
