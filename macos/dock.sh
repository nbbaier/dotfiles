#!/bin/bash

dockutil --no-restart --remove all
dockutil --no-restart --add "/System/Applications/System Settings.app"
dockutil --no-restart --add "/Applications/Slack.app"
dockutil --no-restart --add "/Applications/Discord.app"
dockutil --no-restart --add "/System/Applications/Messages.app"
dockutil --no-restart --add "/Applications/Arc.app"
dockutil --no-restart --add "/Applications/Ghostty.app"
dockutil --no-restart --add "/Applications" --display stack --sort name
dockutil --no-restart --add '~/Downloads' --display stack

killall Dock
