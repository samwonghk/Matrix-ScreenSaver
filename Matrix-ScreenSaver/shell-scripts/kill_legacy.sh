#!/bin/sh

#  kill_legacy.sh
#  Matrix-ScreenSaver
#
#  Created by Sam Wong on 05/01/2024.
#  

kill -9 $(ps -A | grep legacyScreenSaver | head -1 | awk '{print $1}')
