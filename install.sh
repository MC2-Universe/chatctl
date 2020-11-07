#!/bin/bash

# Pre-release Q3 2020 - Canary - 3.8.0-canary.rc.0
readonly VERSION="3.8.0-canary.rc.0"
# readonly GITLAB_TOKEN=$GITLAB_API_TOKEN
readonly CHATCTL_DOWNLOAD_URL="https://raw.githubusercontent.com/MC2-Universe/chatctl/master/chatctl"
readonly CHATCTL_DIRECTORY="/usr/local/bin"

if [ ${EUID} -ne 0 ]; then
    echo "This script must be run as root. Cancelling" >&2
    exit 1
fi
if ! [[ -t 0 ]]; then
    echo "This script is interactive, please run: bash -c \"\$(curl https://raw.githubusercontent.com/MC2-Universe/chatctl/master/chatctl)\"" >&2
    exit 1
fi
if [ ! -f "$CHATCTL_DIRECTORY" ]; then
    if [ ${#args[@]} -ne 2 ]; then
        curl -L $CHATCTL_DOWNLOAD_URL -o /tmp/chatctl
    fi
    if  [ $? != 0 ]; then
        echo "Error downloading chatctl."
        exit 1
    else
        mv /tmp/chatctl $CHATCTL_DIRECTORY/
        chmod 755 $CHATCTL_DIRECTORY/chatctl
    fi
    $CHATCTL_DIRECTORY/chatctl install $@
else
    echo "You already have chatctl installed, use chatctl to manage your UniverseChat installation."
    echo "Run chatctl help for more info."
    exit 1
fi
