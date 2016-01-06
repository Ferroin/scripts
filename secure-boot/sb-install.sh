#!/bin/bash
#
# sb-install.sh: Install updated signing keys for UEFI Secure Boot.
#
# This is a simple script to automate installation of locally generated signing keys for UEFI secure boot.
#
# Copyright (c) 2015, Austin S. Hemmelgarn
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
echo "Initializing KEK."
efi-updatevar -e -f /etc/keys/efi/old_KEK.esl KEK
efi-updatevar -a -c /etc/keys/efi/KEK.crt KEK
echo "Initializing db."
efi-updatevar -e -f /etc/keys/efi/old_db.esl db
efi-updatevar -a -c /etc/keys/efi/db.crt db
echo "Initializing dbx."
efi-updatevar -e -f /etc/keys/efi/old_dbx.esl dbx
echo "Asserting machine ownership and switching to user mode."
efi-updatevar -f /etc/keys/efi/PK.auth PK
echo "Generating backup copies of new Secure Boot configuration."
efi-readvar -v PK -o /etc/keys/efi/new_PK.esl
efi-readvar -v KEK -o /etc/keys/efi/new_KEK.esl
efi-readvar -v db -o /etc/keys/efi/new_db.esl
efi-readvar -v dbx -o /etc/keys/efi/new_dbx.esl
echo "Secure Boot has been configured, make sure you properly sign your kernel with the key in /etc/keys/efi/db.key."
