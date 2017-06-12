#!/usr/bin/env python3
'''termclock_classic.py: An ASCII-art binary clock for your terminal.

Usage: termclock_classic.py

Hit Ctrl-C to exit.

Copyright (c) 2017, Austin S. Hemmelgarn
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice,
   this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
3. The name of Austin S. Hemmelgarn may not be used to endorse or promote
   products derived from this software without specific prior written
   permission.  For permission or any legal details, please contact
   ahferroin7@gmail.com.
4. Redistributions of any form whatsoever must retain the following
   acknowledgment: "This product includes software developed by
   Austin S. Hemmelgarn."

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
'''

import os
import shutil
import signal
import sys
import termios
import time

# This specifies the string to send to the terminal to get the desired
# color sequence.  Default is ANSI SGR sequences for red on black.
_COLOR_SEQUENCE = '\x1b[40m\x1b[31m'

# This specifies the box drawing character to use.
_BOX = '#'
# Comment out the above and uncomment one of the follwoing to use one
# of various Unicode characters.
#_BOX = '█'
#_BOX = '▒'
#_BOX = '⏹'
#_BOX = '•'
#_BOX = '⏺'

# This specifies how many lines to put between each block vertically.
_VSEP = 1

# Same, just horizontally.
_HSEP = 2

# These dictate how to move to the beginning of the next line and
# clear it, and hwo to return to the top of the screen and clear the
# entire screen.
_NL = '\x1b[1E\x1b[K'
_TOP = '\x1b[H\x1b[2J'

def compose_classic_clock(t):
    '''This computes the clock display for the given bit array.

       This one gives a traditional one column per digit binary clock.'''
    size = shutil.get_terminal_size()
    lines = (size[1] - (5 * _VSEP)) // 4
    columns = (size[0] - (7 * _HSEP)) // 6
    bits = get_bit_array_classic(t)
    result = _COLOR_SEQUENCE + _TOP + (' ' * (columns * 6 + _HSEP * 7)) + _NL
    for row in range(3, -1, -1):
        for line in range(0, lines):
            result += ' ' * _HSEP
            for column in range(0, 6):
                if bits[row][column] == 1:
                    result += (_BOX * columns) + (' ' * _HSEP)
                else:
                    result += (' ' * columns) + (' ' * _HSEP)
            result += ' ' + _NL
        for i in range(0, _VSEP):
            result += (' ' * (columns * 6 + _HSEP * 7)) + _NL
    return result

def get_bit_array_classic(t):
    '''Return a bit array for compose_classic_clock() from the given time.'''
    bits = [[], [], [], []]
    digits = [
        (t.tm_hour - (t.tm_hour % 10)) // 10,
        t.tm_hour % 10,
        (t.tm_min - (t.tm_min % 10)) // 10,
        t.tm_min % 10,
        (t.tm_sec - (t.tm_sec % 10)) // 10,
        t.tm_sec % 10
    ]
    for item in digits:
        bits[0].append(item & 0x01)
        bits[1].append((item & 0x02) >> 1)
        bits[2].append((item & 0x04) >> 2)
        bits[3].append((item & 0x08) >> 3)
    return bits

def display_clock(signum, frame):
    '''Get the current time and write out the clock.'''
    sys.stdout.write(compose_classic_clock(time.localtime()))
    termios.tcdrain(sys.stdout.fileno())
    return True

if __name__ == '__main__':
    signal.signal(signal.SIGALRM, display_clock)
    signal.setitimer(signal.ITIMER_REAL, 0.5, 1)
    while True:
        signal.pause()
