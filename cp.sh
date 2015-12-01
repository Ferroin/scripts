#!/bin/sh
# cp.sh: Copy a file block by block with a progress indicator
#
# usage: cp.sh SOURCE DESTINATION
#
# This has a much smaller overall memory footprint for large files than
# regular GNU cp does.  I wrote it originally for doing kernel crashdumps
# on Linux, and still use a variant of the same code for that purpose.
#
# Copyright (c) 2014, Austin S. Hemmelgarn
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. The name of Austin S. Hemmelgarn may not be used to endorse or promote
#    products derived from this software without specific prior written
#    permission.  For permission or any legal details, please contact
#    ahferroin7@gmail.com.
# 4. Redistributions of any form whatsoever must retain the following
#    acknowledgment: "This product includes software developed by
#    Austin S. Hemmelgarn."
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

fsize=`stat -c %s ${1}`
count=$((${fsize}/1048576))
if [ $((${fsize}%1048576)) -ne 0 ] ; then
    count=$((${count}+1))
fi
echo "About to copy ${fsize} bytes in ${count} chunks."
for i in `seq 0 $((${count}-1))` ; do
    dd if=${1} of=${2} bs=1048576 conv=sparse,notrunc count=1 seek=${i} skip=${i} status=none
    /bin/echo -e -n "\e[2K\e[0G[$((${i}+1))/${count}]"
done
echo
