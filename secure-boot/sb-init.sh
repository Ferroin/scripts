#!/bin/bash
#
# sb-init.sh: Do some initial setup for sb-install.sh
#
# The primary purpose of this script is to generate the initial directory
# structure for the sb-install.sh script.  Everything is conditional such
# that it's safe to run this on a system that it has already been run on.
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
mkdir -p /etc/keys/efi
chmod 700 /etc/keys/efi
if [ ! -e /etc/keys/efi/old_PK.esl ] ; then
    efi-readvar -v PK -o /etc/keys/efi/old_PK.esl
fi
if [ ! -e /etc/keys/efi/old_KEK.esl ] ; then
    efi-readvar -v KEK -o /etc/keys/efi/old_KEK.esl
fi
if [ ! -e /etc/keys/efi/old_db.esl ] ; then
    efi-readvar -v db -o /etc/keys/efi/old_db.esl
fi
if [ ! -e /etc/keys/efi/old_dbx.esl ] ; then
    efi-readvar -v dbx -o /etc/keys/efi/old_dbx.esl
fi
if [ ! -e /etc/keys/efi/PK.crt ] ; then
    echo "Generating new Platform Key"
    openssl req -new -x509 -newkey rsa:2048 -keyout /etc/keys/efi/PK.key -out /etc/keys/efi/PK.crt -subj "/CN=Autogenerated Platform Key/"
fi
if [ ! -e /etc/keys/efi/KEK.crt ] ; then
    echo "Generating new Key Exchange Key"
    openssl req -new -x509 -newkey rsa:2048 -keyout /etc/keys/efi/KEK.key -out /etc/keys/efi/KEK.crt -subj "/CN=Autogenerated Key Exchange Key/"
fi
if [ ! -e /etc/keys/efi/db.crt ] ; then
    echo "Generating new Signing Key"
    openssl req -new -x509 -newkey rsa:2048 -keyout /etc/keys/efi/db.key -out /etc/keys/efi/db.crt -subj "/CN=Autogenerated Signing Key/"
fi
cert-to-efi-sig-list -g "$(uuidgen)" /etc/keys/efi/PK.crt /etc/keys/efi/PK.esl
sign-efi-sig-list -k /etc/keys/efi/PK.key -c /etc/keys/efi/PK.crt /etc/keys/efi/PK /etc/keys/efi/PK.esl /etc/keys/efi/PK.auth
cat /etc/keys/efi/PK.crt /etc/keys/efi/KEK.crt /etc/keys/efi/db.crt > /etc/keys/efi.pem
