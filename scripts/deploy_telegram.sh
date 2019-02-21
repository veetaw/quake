#!/bin/bash

# todo build for different architectures

LAST_COMMIT_MESSAGE="$(git log -1 --pretty=%s | cat| head -c 50)" # limit to 50 chars

# to skip deploy commit should start with "skip"
if [[ $LAST_COMMIT_MESSAGE == skip* ]] ;
then
    exit
fi

LAST_COMMIT_HASH="$(git log -1 --pretty=%H | cat)"
LAST_COMMIT_BY_USER="$(git log -1 --pretty=%cN | cat)"
LAST_COMMIT_DATE="$(git log -1 --pretty=%cd | cat)"

CHAT_ID='-1001231501597'
CAPTION="$LAST_COMMIT_MESSAGE

*commit by :* $LAST_COMMIT_BY_USER
$LAST_COMMIT_DATE

[link (github)](https://github.com/veetaw/quake/commit/$LAST_COMMIT_HASH)"
APK_PATH="build/app/outputs/apk/release/app-release.apk"

../flutter/bin/flutter build apk --release
curl -F chat_id="$CHAT_ID" -F caption="$CAPTION" -F parse_mode="markdown" -F document=@"$APK_PATH" https://api.telegram.org/bot$BOT_TOKEN/sendDocument
