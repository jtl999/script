#!/bin/bash

set -o errexit

read -p "Enter key passphrase (empty if none): " -s password
echo

tmp="$(mktemp -d)"

export password

for key in releasekey platform shared media networkstack; do
    if [[ -n $password ]]; then
        openssl pkcs8 -in $key.pk8 -inform DER -passin env:password | openssl pkcs8 -topk8 -outform DER -out "$tmp/$key.pk8" -nocrypt
    fi
done

unset password

mv "$tmp"/* .
rmdir "$tmp"
