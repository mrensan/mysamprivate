#!/usr/bin/env bash

#     This program is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.
#
#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
#
#     You should have received a copy of the GNU General Public License
#     along with this program.  If not, see <https://www.gnu.org/licenses/>.

#     MySam-Private v1.2

set -e

LOCAL_PATH=$HOME/Documents/SAM_LOCAL
SHARED_PATH=$HOME/Dropbox\ \(Personal\)/SAM_SHARED
MEDIA=private

if [[ ! -d "$LOCAL_PATH" ]]
then
    echo "$LOCAL_PATH does not exist on your filesystem."
    exit 1
fi

if [[ ! -d "$SHARED_PATH" ]]
then
    echo "$SHARED_PATH does not exist on your filesystem."
    exit 1
fi

if [[ ! $1 =~ ^open|persist|close$ ]]
then
    echo
    echo "Usage: mysam.sh COMMAND"
    echo
    echo "A tool for sharing private stuff in cloud"
    echo
    echo "Management Commands:"
    echo
    echo "open      To decrypt and extract files on your local path"
    echo "persist   To compress and encrypt files on your shared path and clean local path"
    echo "close     To clean your local path, the changes will be missed"
    echo
    exit 1
fi

TMP_PATH=$(mktemp -d)
trap "rm -rf $TMP_PATH" EXIT

function open_local() {
    cp -v "$SHARED_PATH/$MEDIA.tar.gz.gpg" "$TMP_PATH"

    export GPG_TTY=$(tty)
    export PINENTRY_USER_DATA="USE_CURSES=1"
    gpg --verbose --output "$TMP_PATH/$MEDIA.tar.gz" --decrypt "$TMP_PATH/$MEDIA.tar.gz.gpg"

    tar xvf "$TMP_PATH/$MEDIA.tar.gz" -C $(dirname "${LOCAL_PATH}")
}

function toshare() {
    tar -C $(dirname "${LOCAL_PATH}") -pcvzf "$TMP_PATH/$MEDIA.tar.gz" $(basename "${LOCAL_PATH}")

    export GPG_TTY=$(tty)
    export PINENTRY_USER_DATA="USE_CURSES=1"
    gpg --verbose --symmetric "$TMP_PATH/$MEDIA.tar.gz"

    mv -v "$TMP_PATH/$MEDIA.tar.gz.gpg" "$SHARED_PATH"
}

function clean_local() {
    rm -rfv "$LOCAL_PATH"/* 2>/dev/null
}

case $1 in
	open)
		echo "** Open"
        clean_local
        open_local
		;;
	persist)
		echo "** Persist"
        toshare
        clean_local
		;;
	close)
		echo "** Close"
        clean_local
		;;
	*)
		echo "Are you kidding me?"
		;;
esac

echo "Done!"
