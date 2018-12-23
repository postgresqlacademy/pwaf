#!/bin/bash

IS_RUNNING=`ps aux|grep "main.py"|grep -v "grep"|wc -l`

if [ $IS_RUNNING -eq 0 ]; then
    ./main.py >> main_log 2>&1 &
fi