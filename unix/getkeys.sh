#!/bin/sh
#
# getkeys.sh: Get a list of keys pressed on a given input device, with
#             an inactivity timeout
#
# usage: getkeys.sh TIMEOUT DEVICE
#        TIMEOUT is a timeout in seconds before getkeys.sh exits by itself
#        DEVICE is the input device file to check
#
# Copyright (c) 2014-2015, Austin S. Hemmelgarn
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
tmp=`tempfile`
input-events -t ${1} ${2} > ${tmp} 2>&1
echo
data=`grep KEY ${tmp}`
cat > ${tmp} << EOF
${data}
EOF
data=`tail -n +2 ${tmp} | grep pressed | cut -d ' ' -f 3`
cat > ${tmp} << EOF
${data}
EOF
ex -s -c '%s/\n//' -c 'wqa' ${tmp}
cat ${tmp}
