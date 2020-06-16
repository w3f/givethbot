#!/bin/sh

/scripts/deploy.sh -c ${ENVIRONMENT} -t helm -a "--set image.tag=${CIRCLE_TAG} --set botCredentials=${BOT_CREDENTIALS} --set clientSecret=${CLIENT_SECRET} --set credentials=${CREDENTIALS} --set mainRoom=${MAIN_ROOM} givethbot w3f/givethbot"
