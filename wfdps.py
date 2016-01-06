#!/usr/bin/env python3
'''
wfdps.py: A script to compute average DPS for a weapon in Warframe

This is a script I wrote to compute the average raw (pre-resistance/bonus)
DPS of a given weapon build in the game Warframe.  In general, the logic
should work simillarly for most other shooter games, although I provide
no guarantee of the quality of the results for other usage.

You'll need Python 3.4 or higher to run this, you can get it from:
http://python.org
It may work with older versions, but I've not tested it on them, so
don't expect any bugfixes for issues specific to older versions.

Do not ask me to put a GUI on this, I will not do so, no matter how much
you beg.  I am considering having the ability to pass in a file of stats,
and get a result, but that is not something that is availible yet.

For info on how to use this, run it without any arguments.

If you're on Windows, you'll need to run it from either powershell or cmd like this:
python wfdps.py

TODO:
    * Add support for handling weapons where ammo consumption doesn't
      equate to damage rate (Glaxion and friends).

Copyright (c) 2015, Austin S. Hemmelgarn
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
POSSIBILITY OF SUCH DAMAGE.'''

def compute_dps(stats):
    '''Compute the average DPS of a weapon with the given stats.

       stats should be a dict similar to what is returned by
       argparse.ArgumentParser.parse_args()'''
    # This checks for red crit values, and adjusts numbers accordingly
    # In essence, it converts things so what is normally calculating for crits
    # is calculating for red crits.
    if stats.critchance > 100:
        stats.critchance = stats.critchance - 100
        stats.dmg = stats.dmg * stats.critmult
        stats.critmult = 2
    critchance = stats.critchance / 100
    # This is some relatively simple math.  It pretty much takes the percentage
    # of time you don't crit, the percentage you do, and the damage for each,
    # and combines them in a weighted average.
    avgperpellet = ((stats.dmg / stats.multishot) * (1 - critchance)) + ((stats.dmg / stats.multishot) * critchance * stats.critmult)
    # This is even simpler, we take the per bullet damage computed above and
    # multiply it by the number of bullets in a single shot.
    avgpershot = avgperpellet * stats.multishot
    if stats.firerate > 0:
        # If we didn't get the reload time and magazine size, then the average
        # DPS is just the per-shot damage times the firerate.
        avgdps = avgpershot * stats.firerate
        if (stats.reload and stats.reload > 0) and stats.magazine:
            # Here, we compute how long it takes to empty the magazine
            magtime = stats.magazine / stats.firerate
            # And this uses the ratio of reload time to the time it takes to
            # empty the magazine to adjust the DPS value accordingly.
            avgdps = avgdps / ((stats.reload / magtime) + 1)
    else:
        # In this case, we've been told to ignore fire rate.  If we have the
        # reload time, the DPS is the per-shot times the magazine size, divided
        # by the reload time, otherwise it's just the per-shot damage.
        if stats.reload and stats.reload > 0:
            avgdps = avgpershot * stats.magazine / stats.reload
        else:
            avgdps = avgpershot
    if stats.channelmult:
        # This just multiplies the channeling multiplier into the DPS to get
        # the average DPS while channeling.
        avgcdps = avgdps * stats.channelmult
        return (avgperpellet, avgpershot, avgdps, avgcdps)
    else:
        return (avgperpellet, avgpershot, avgdps)

def main():
    '''Boring stuff just to wrap the function above so it's usable as a script.'''
    import argparse
    parser = argparse.ArgumentParser(description='Comput a weapon\'s average DPS', epilog='Results do not factor in any bonuses for different dmage types or dmage resistance from armor.  Results for weapons that are not fully automatic will also be off (the returned values for such weapons are theoretical maximums).  We currently do not directly handle weapons that deal damage at a different rate than they fire.  You can account for such weapons by scaling the magazine size so that it equals the number of damage ticks the weapon deals while emptying it\'s magazine.')
    parser.add_argument('--dmg', '--damage', help='Base damage vaule.  This is the sum of the individual damage types for the weapon.', type=float, required=True)
    parser.add_argument('--critchance', help='Critical hit chance, expressed as a percentage without the %% sign.', type=float, required=True)
    parser.add_argument('--critmult', help='Critical dmage multiplier.', type=float, required=True)
    parser.add_argument('--firerate', help='Fire rate in shots per second, or attack speed for melee weapons. Specify 0 here for weapons like the Tigris that are unaffected by fire rate.', type=float, required=True)
    parser.add_argument('--magazine', help='Magazine size.', type=int)
    parser.add_argument('--reload', help='Reload speed, in seconds, specify 0 here for stuff that does not need reloaded.', type=float)
    parser.add_argument('--multishot', help='Number of individual projectiles.  Damage is assumed to be divided evenly between them.  Check the Warframe wiki for a list of pellet counts for shotguns, then multiply that by the %% multishot bonus divided by 100.  For other weapons with a single projectile, this should be the percentage multishot bonus divided by 100, plus 1.', type=float, default=1)
    parser.add_argument('--channelmult', help='Channeling damage multiplier for melee weapons.', type=float)
    args = parser.parse_args()
    if ((args.reload and not args.magazine) or \
       (args.magazine and not args.reload)):
        print('If you specify either magazine size or reload speed, you must specify the other.')
        exit(1)
    if (args.channelmult and (args.magazine or args.reload or (args.multishot != 1))):
        print('Magazie size, reload speed, and multishot make no sense when used with a channeling multiplier')
        exit(1)
    result = compute_dps(args)
    if not args.channelmult:
        print('Average per-bullet damage: {0:.2F}'.format(result[0]))
    print('Average per-shot damage; {0:.2F}'.format(result[1]))
    print('Average DPS: {0:.2F}'.format(result[2]))
    if (args.channelmult):
        print('Average DPS while channeling: {0:.2F}'.format(result[3]))
    exit(0)

if __name__ == '__main__':
    main()
