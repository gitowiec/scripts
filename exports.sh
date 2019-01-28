#!/bin/sh


export CHROME_BIN=`which google-chrome || which chromium-browser`
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export DOTNET_CLI_TELEMETRY_OPTOUT=1
