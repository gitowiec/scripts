#!/bin/sh


export CHROME_BIN=`which google-chrome || which chromium-browser`
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export EDITOR='subl --wait'
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export WINEARCH=win32